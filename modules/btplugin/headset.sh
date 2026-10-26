#!/usr/bin/env bash
set -u

CMD="${1:-status}"

fail() { echo "ERROR|$1"; exit 1; }

command -v pactl >/dev/null 2>&1 || fail "pactl not found"

find_card() {
    pactl list cards short 2>/dev/null | awk '{print $2}' | grep -m1 '^bluez_card\.'
}

norm() {
    local c
    c=$(echo "$1" | tr '[:upper:]' '[:lower:]' | tr -d '"[:space:]')
    case "$c" in
        ldac*) echo ldac ;;
        aac*)  echo aac ;;
        *)     echo "$c" ;;
    esac
}

get_codec() {
    local card=$1 out

    out=$(pactl list sinks 2>/dev/null | awk -v k="${card#bluez_card.}" '
        /^[[:space:]]*Name:/ { cur = $2 }
        index(cur, k) && /(api\.bluez5\.codec|bluetooth\.codec) =/ {
            gsub(/.*= "|".*/, ""); print; exit
        }')

    if [ -z "$out" ]; then
        out=$(pactl list cards 2>/dev/null | awk -v c="$card" '
            /^[[:space:]]*Name:/ { incard = ($2 == c) }
            incard && /Active Profile:/ { ap = $3 }
            incard && /codec / && /sinks:/ { k = $1; sub(/:$/, "", k); line[k] = $0 }
            END { if (ap in line) { s = line[ap]; sub(/.*codec /, "", s); sub(/[),].*/, "", s); print s } }')
    fi

    if [ -z "$out" ]; then
        out=$(pactl send-message "/card/$card/bluez" get-codec 2>/dev/null | tr -d '"[:space:]')
        [[ "$out" =~ ^[0-9]+$ ]] && out=""
    fi

    norm "$out"
}

get_battery() {
    local mac=$1 b key dev
    b=$(bluetoothctl info "$mac" 2>/dev/null \
        | sed -n 's/.*Battery Percentage:.*(\([0-9]*\)).*/\1/p' | head -n1)
    if [ -z "$b" ] && command -v upower >/dev/null 2>&1; then
        key=${mac//:/_}
        dev=$(upower -e 2>/dev/null | grep -i -m1 "$key")
        [ -n "$dev" ] && b=$(upower -i "$dev" 2>/dev/null \
            | awk '/percentage:/ { gsub("%", "", $2); print int($2); exit }')
    fi
    echo "${b:-}"
}

print_status() {
    local card=$1 mac=${1#bluez_card.}
    mac=${mac//_/:}
    echo "$(get_codec "$card")|$(get_battery "$mac")"
}

find_profile() {
    pactl list cards 2>/dev/null | awk -v c="$1" -v t="$2" '
        /^[[:space:]]*Name:/ { incard = ($2 == c) }
        incard && /sinks:/ && tolower($0) ~ ("codec " t "[ ),_]") && $0 !~ /available: no/ {
            k = $1; sub(/:$/, "", k); print k; exit
        }'
}

available_codecs() {
    pactl list cards 2>/dev/null | awk -v c="$1" '
        /^[[:space:]]*Name:/ { incard = ($2 == c) }
        incard && /A2DP/ && /sinks:/ && /codec / {
            s = $0; sub(/.*codec /, "", s); sub(/[),].*/, "", s); print s
        }' | sort -u | paste -sd, -
}

wait_codec() {
    local card=$1 want=$2
    for _ in 1 2 3 4 5 6 7 8; do
        sleep 0.5
        [ "$(get_codec "$card")" = "$want" ] && return 0
    done
    return 1
}

CARD=$(find_card) || fail "No Bluetooth headphones connected"

case "$CMD" in
    status)
        print_status "$CARD"
        ;;
    toggle)
        current=$(get_codec "$CARD")
        if [ "$current" = "ldac" ]; then target=aac; else target=ldac; fi

        ok=0

        prof=$(find_profile "$CARD" "$target")
        if [ -n "$prof" ]; then
            pactl set-card-profile "$CARD" "$prof" >/dev/null 2>&1
            wait_codec "$CARD" "$target" && ok=1
        fi

        if [ "$ok" != 1 ]; then
            if [ "$target" = "aac" ]; then candidates=(aac AAC); else candidates=(ldac ldac_hq); fi
            for c in "${candidates[@]}"; do
                pactl send-message "/card/$CARD/bluez" switch-codec "\"$c\"" >/dev/null 2>&1
                wait_codec "$CARD" "$target" && { ok=1; break; }
            done
        fi

        if [ "$ok" != 1 ]; then
            fail "${target^^} is unavailable. Current: ${current:-?}. Available: $(available_codecs "$CARD")"
        fi
        print_status "$CARD"
        ;;
    *)
        fail "Unknown command: $CMD"
        ;;
esac

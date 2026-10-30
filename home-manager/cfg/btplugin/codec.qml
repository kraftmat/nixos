import QtQuick
import qs.Common
import qs.Services
import qs.Widgets
import qs.Modules.Plugins

PluginComponent {
    id: root

    readonly property int pollInterval: 30
    readonly property int lowThreshold: 20
    readonly property string scriptPath: Qt.resolvedUrl("headset.sh").toString().replace(/^file:\/\//, "")

    property bool connected: false
    property bool busy: false
    property string codec: ""
    property int battery: -1

    readonly property string codecLabel: codec === "" ? "" : codec.toUpperCase()
    readonly property bool lowBattery: connected && battery >= 0 && battery <= lowThreshold
    readonly property color accent: !connected ? Theme.surfaceVariantText : (lowBattery ? Theme.error : Theme.primary)
    readonly property string batteryText: !connected ? "" : (battery >= 0 ? battery + "%" : "?")

    function applyStatus(out) {
        const line = (out || "").trim().split("\n")[0];
        if (!line || line.indexOf("ERROR") === 0) {
            connected = false;
            codec = "";
            battery = -1;
            return;
        }
        const p = line.split("|");
        connected = true;
        codec = p[0] || "";
        battery = (p[1] !== undefined && p[1] !== "") ? parseInt(p[1]) : -1;
    }

    function refresh() {
        if (busy)
            return;
        Proc.runCommand("btCodecSwitcher.status", ["bash", scriptPath, "status"], (stdout, exitCode) => {
            if (!root.busy)
                root.applyStatus(exitCode === 0 ? stdout : "");
        }, 100, 10000, root);
    }

    function toggleCodec() {
        if (!connected || busy)
            return;
        busy = true;
        Proc.runCommand("btCodecSwitcher.toggle", ["bash", scriptPath, "toggle"], (stdout, exitCode) => {
            root.busy = false;
            if (exitCode === 0) {
                root.applyStatus(stdout);
            } else {
                const parts = (stdout || "").trim().split("|");
                ToastService.showError("Codec switch failed", parts.length > 1 ? parts[1] : "Unknown error");
                root.refresh();
            }
        }, 0, 20000, root);
    }

    Timer {
        interval: root.pollInterval * 1000
        repeat: true
        triggeredOnStart: true
        running: root.surfaceLive !== false
        onTriggered: root.refresh()
    }

    pillClickAction: () => root.toggleCodec()
    pillRightClickAction: () => root.refresh()

    horizontalBarPill: Component {
        Row {
            spacing: Theme.spacingXS
            opacity: root.busy ? 0.5 : 1.0

            StyledText {
                anchors.verticalCenter: parent.verticalCenter
                text: root.batteryText
                font.pixelSize: Theme.fontSizeSmall
                font.weight: Font.Medium
                color: root.lowBattery ? Theme.error : Theme.surfaceText
            }

            StyledText {
                anchors.verticalCenter: parent.verticalCenter
                visible: root.connected && root.codecLabel !== ""
                text: root.codecLabel
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.surfaceVariantText
            }
        }
    }

    verticalBarPill: Component {
        Column {
            spacing: Theme.spacingXXS
            opacity: root.busy ? 0.5 : 1.0

            StyledText {
                anchors.horizontalCenter: parent.horizontalCenter
                text: root.batteryText
                font.pixelSize: Theme.fontSizeSmall
                font.weight: Font.Medium
                color: root.lowBattery ? Theme.error : Theme.surfaceText
            }

            StyledText {
                anchors.horizontalCenter: parent.horizontalCenter
                visible: root.connected && root.codecLabel !== ""
                text: root.codecLabel
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.surfaceVariantText
            }
        }
    }
}

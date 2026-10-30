{ ... }:

{
  xdg.configFile."MangoHud/MangoHud.conf".text = ''
    legacy_layout=0
    horizontal=0
    round_corners=8
    background_alpha=0.6
    background_color=202020
    text_color=FFFFFF
    gpu_color=34A853
    cpu_color=4285F4
    fps_color=FBBC05
    position=top-left
    table_columns=3
    gpu_text=GPU
    gpu_stats
    gpu_temp
    gpu_junction_temp
    gpu_core_clock
    gpu_mem_clock
    gpu_power
    cpu_text=CPU
    cpu_stats
    cpu_temp
    cpu_clock
    vram
    ram
    fps
    frametime
    frame_timing=1
    histogram
    display_server
    engine
    vulkan_driver
    hud_no_margin
  '';
}

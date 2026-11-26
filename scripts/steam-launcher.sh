#!/usr/bin/env bash
#
# Steam launch option router
# Centralized & backup-friendly
#
#

set -euo pipefail

# Global environment (safe for all games)
#export \
#    LD_PRELOAD="" \
#    STEAM_USE_NATIVE_CONTROLLERS=1 \
#    MANGOHUD_CONFIGFILE="$HOME/.config/MangoHud/MangoHud.conf" \
    #VK_LOADER_LAYERS_ENABLE=VK_LAYER_MANGOHUD_overlay_x86_64


error_dialog() {
    yad --center \
        --title="Steam Launcher Error" \
        --image=dialog-error \
        --width=400 \
        --button=OK:0 \
        --text="$1"
}


# Check if argument is even passed
if [[ $# -lt 1 ]]; then
    error_dialog "No game selector flag was provided."
    exit 1
fi

FLAG="$1"
shift   # IMPORTANT: remove the selector flag so %command% works

case "$FLAG" in
    -Default) # A Default/General preset
        gamescope \
            --mangoapp \
            --force-grab-cursor \
            --adaptive-sync \
            -r 60 \
            -W 2560 -H 1440 \
            -f \
            -- gamemoderun "$@"
        ;;
    -NoGamescope) # A Default/General preset
        gamemoderun mangohud "$@"
        ;;
    -Vostok) # Road to Vostok -- Force Vulkan
        gamescope \
            --force-grab-cursor \
            --adaptive-sync \
            -r 60 \
            -W 2560 -H 1440 \
            -f \
            -- gamemoderun "$@" --rendering-driver vulkan --rendering-method forward_plus
        ;;
    -Zomboid) # Zomboid
        #DXVK_FRAME_RATE=60 \
        LD_PRELOAD="" \
        LOW_LATENCY_LAYER=1 \
        gamescope \
            --mangoapp \
            --force-grab-cursor \
            --adaptive-sync \
            -r 60 \
            -W 2560 -H 1440 \
            -f \
            -- gamemoderun "$@" -Xmx16g -Xms8g
        ;;
    -Sulfer) # Sulfer
        #DXVK_FRAME_RATE=60 \
        LD_PRELOAD="" \
        LOW_LATENCY_LAYER=1 \
        gamescope \
            --mangoapp \
            --force-grab-cursor \
            --adaptive-sync \
            -r 60 \
            -W 2560 -H 1440 \
            -f \
            -- gamemoderun "$@"
        ;;
    -SnowRunner) # SnowRunner
        #DXVK_FRAME_RATE=60 \
        gamescope \
            --force-grab-cursor \
            --adaptive-sync \
            -r 60 \
            -W 2560 -H 1440 \
            -f \
            -- gamemoderun "$@"
        ;;
    -Silverfish) # Project Silverfish
        #DXVK_FRAME_RATE=60 \
        gamescope \
            --force-grab-cursor \
            --adaptive-sync \
            -r 60 \
            -w 1920 -h 1080 \
            -W 2560 -H 1440 \
            -F fsr \
            -f \
            -- gamemoderun "$@"
        ;;
    -BeamNG) # BeamNG Drive
        #DXVK_FRAME_RATE=60 \
        #PROTON_USE_DXVK=1 \
        LD_PRELOAD="/home/sokoloft/.local/share/BeamNG/BeamNG.drive/beamng_Earth/libbngearth_gcpatch.so:$LD_PRELOAD"
        STEAM_USE_NATIVE_CONTROLLERS=1 \
        SDL_VIDEODRIVER=wayland \
        LOW_LATENCY_LAYER=1 \
        gamescope \
            --mangoapp \
            --force-grab-cursor \
            --adaptive-sync \
            -r 60 \
            -W 2560 -H 1440 \
            -f \
            -- gamemoderun ./BinLinux/BeamNG.drive.x64 "$@" -gfx vk
        ;;
    -MotorTown) # Motor Town
        #DXVK_FRAME_RATE=60 \
        #PROTON_USE_DXVK=1 \
        #LD_PRELOAD="" \
        STEAM_USE_NATIVE_CONTROLLERS=1 \
        LOW_LATENCY_LAYER=1 \
        gamescope \
            --mangoapp \
            --force-grab-cursor \
            --adaptive-sync \
            -r 60 \
            -W 2560 -H 1440 \
            -f \
            -- gamemoderun "$@"
        ;;
    -DRG) # Deep Rock Galactic
        #DXVK_FRAME_RATE=60 \
        PROTON_ENABLE_WAYLAND=1 \
        LOW_LATENCY_LAYER=1 \
        gamescope \
            --mangoapp \
            --force-grab-cursor \
            --adaptive-sync \
            -r 60 \
            -W 2560 -H 1440 \
            -f \
            -- gamemoderun "$@" -nosplash
        ;;
    -Cyberpunk) # Cyberpunk 2077
        PROTON_ENABLE_WAYLAND=1 \
        gamescope \
            --mangoapp \
            --force-grab-cursor \
            --adaptive-sync \
            -r 60 \
            -W 2560 -H 1440 \
            -f \
            -- gamemoderun "$@" --launcher-skip --intro-skip
        ;;
    -RON) # Ready or Not
        gamescope \
            --force-grab-cursor \
            --adaptive-sync \
            -r 60 \
            -W 2560 -H 1440 \
            -f \
            -- gamemoderun "$@" -d3d11
        ;;
    -Bannerlord) # Mount & Blade II: Bannerlord
        DXVK_FRAME_RATE=60 \
        gamescope \
            --force-grab-cursor \
            --adaptive-sync \
            -r 60 \
            -W 2560 -H 1440 \
            -f \
            -- gamemoderun "$@"
        ;;
    *)
        error_dialog "No valid launch option provided."
        exit 1
        ;;
esac

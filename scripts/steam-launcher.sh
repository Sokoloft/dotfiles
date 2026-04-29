#!/usr/bin/env bash
#
# Steam launch option router
# Centralized & backup-friendly
#
#

set -euo pipefail

# Global environment (safe for all games)
export \
    LD_PRELOAD="" \
    STEAM_USE_NATIVE_CONTROLLERS=1 \
    MANGOHUD_CONFIGFILE="$HOME/.config/MangoHud/MangoHud.conf" \
    VK_LOADER_LAYERS_ENABLE=VK_LAYER_MANGOHUD_overlay_x86_64


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
        gamescope \
            --force-grab-cursor \
            --adaptive-sync \
            -r 60 \
            -W 2560 -H 1440 \
            -f \
            -- gamemoderun "$@" -Xmx16g -Xms16g
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
        #SDL_VIDEODRIVER=wayland \
        gamescope \
            --force-grab-cursor \
            --adaptive-sync \
            -r 60 \
            -W 2560 -H 1440 \
            -f \
            -- gamemoderun "$@" -gfx vk
        ;;
    -DRG) # Deep Rock Galactic
        #DXVK_FRAME_RATE=60 \
        gamescope \
            --force-grab-cursor \
            --adaptive-sync \
            -r 60 \
            -W 2560 -H 1440 \
            -f \
            -- gamemoderun "$@" -nosplash
        ;;
    -Cyberpunk) # Cyberpunk 2077
        WINEDLLOVERRIDES="winmm,version=n,b" \
        gamescope \
            --force-grab-cursor \
            --adaptive-sync \
            -r 60 \
            -W 2560 -H 1440 \
            -f \
            -- gamemoderun "$@" --launcher-skip -modded
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

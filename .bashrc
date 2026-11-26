#
# ~/.bashrc
#

# Statics
DIR="$HOME/.local/dotfiles"
EDITOR=kate


# System
alias cls=clear
alias ff=fastfetch


# My terminal coloring
PS1="\[\e[38;2;200;200;200m\]╭─ [\$(date +'%-I:%M %p')] \[\e[1;34m\]\u\[\e[0;38;2;200;200;200m\]@\[\e[1;36m\]\h \[\e[0;32m\]\w\n\[\e[38;2;200;200;200m\]╰─\[\e[1;36m\]\\$ \[\e[0m\]"

# Config editing/dirs
alias edit-bashrc="$EDITOR $DIR/.bashrc"
alias reload-bashrc="source $HOME/.bashrc"
alias dotfiles="cd $DIR"
alias reload-configs="ln -nsf $DIR/configs/* $HOME/.config"

# Scripts & Tools
alias random="$DIR/scripts/randomstr.py"
alias spotx="bash <(curl -sSL https://spotx-official.github.io/run.sh)"

case "$HOSTNAME" in
  5700X) # 5700X Main Desktop
    alias temps="watch sensors amdgpu-pci-0a00 zenpower-pci-00c3 it8655-isa-0290"
    alias edit-steamlauncher="$EDITOR $DIR/scripts/steam-launcher.sh"
  ;;
  x250) # Thinkpad x250
    alias temps="watch sensors coretemp-isa-0000 thinkpad-isa-0000 pch_wildcat_point-virtual-0 drivetemp-scsi-0-0"
  ;;
  5520) # Dell Latitude 5520
    alias temps="watch sensors dell_smm-virtual-0"
  ;;
  *)
    echo "Error: Hostname not defined!"
    ;;
esac

# Automatically configure btop battery display
btop_conf="$DIR/configs/btop/btop.conf"
show_battery=false

for supply in /sys/class/power_supply/*; do
    if [[ -f "$supply/type" && $(<"$supply/type") == "Battery" ]]; then
        show_battery=true
        break
    fi
done

if [[ -f "$btop_conf" ]] && ! grep -qx "show_battery = $show_battery" "$btop_conf"; then
    sed -i "s/^show_battery = .*/show_battery = $show_battery/" "$btop_conf"
fi

unset btop_conf show_battery supply



fastfetch

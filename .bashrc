# My .bashrc
#
# 4/6/26
# Sokoloft
#

# Statics
DIR="$HOME/.local/dotfiles"
EDITOR=kate


# System
alias cls=clear
alias ff=fastfetch
alias update-grub="sudo grub-mkconfig -o /boot/grub/grub.cfg"
alias edit-grub="$EDITOR /etc/default/grub"

# My terminal coloring
PS1="\[\033[31m\][\$(date +'%-I:%M %p')] - \[\033[1;34m\]\u\[\033[1;31m\]@\[\033[1;36m\]\h:\[\033[1;31m\]\w\\$\[\033[0m\] "

# Config editing/dirs
alias edit-bashrc="$EDITOR $DIR/.bashrc"
alias reload-bashrc="source $HOME/.bashrc"
alias dotfiles="cd $DIR"
alias reload-configs="ln -nsf $DIR/configs/* $HOME/.config"

# Scripts
alias random="$DIR/scripts/randomstr.py"

case "$HOSTNAME" in
  3600XT) # 3600XT Main Desktop
    alias spotx="bash <(curl -sSL https://spotx-official.github.io/run.sh)"
    alias spotdl="$HOME/.venv/bin/spotdl"
    alias temps="watch sensors amdgpu-pci-0a00 zenpower-pci-00c3 it8655-isa-0290"
    alias edit-steamlauncher="$EDITOR $DIR/scripts/steam-launcher.sh"
  ;;
  x250) # Thinkpad x250
    LAPTOP=True
    alias temps="watch sensors coretemp-isa-0000 thinkpad-isa-0000 pch_wildcat_point-virtual-0 drivetemp-scsi-0-0"
  ;;
  5520) # Dell Latitude 5520
    LAPTOP=True
    alias temps="watch sensors dell_smm-virtual-0"
  ;;
  *)
    echo "Error: Hostname not defined!"
    ;;
esac

# Shared laptop alias's
if [ $LAPTOP ]; then
  alias xairmute="$HOME/.venv/bin/xairmute"
fi

fastfetch

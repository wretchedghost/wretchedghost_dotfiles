#!/bin/bash

# init-setup.sh
# This script is designed to pull files from this directory and place them in the home folder. Designed for a newly installed server.
#

# Check if running as with sudo
if [[ "$EUID" -ne 0 ]]; then
    echo "This script must be run as root or with sudo."
    exit 1
fi

echo "Script running with sudo privileges. Proceeding..."
apt update && apt upgrade -y
apt install vim tmux rsync neofetch sudo ufw git ssh openssh-server -y

echo "Next I will run interactively to create ssh-keygen key with ed25519..."
yes "y" | ssh-keygen -t ed25519 -N ''

echo "Running a git pull of my dotfiles and rsyncing them to home directory..."
su wretchedghost
cd ~/
mkdir git && cd git
git clone https://github.com/wretchedghost/wretchedghost_dotfiles
cd wretchedghost_dotfiles
rsync -av .tmux .config .vim .vimrc .bashrc ~/
source ~/.bashrc

while true; do
    read -p "Do you want to install tailscale? (y/n): " response
    case $response in 
        [Yy]* )
            echo "Continuing..."
            su root
            if ! command -v tailscale &> /dev/null; then
                curl -fsSL https://tailscale.com/install.sh | sh
            fi
            tailscale up
            break
            ::
        [Nn]* )
            echo "Exiting."
            exit 0
            ;;
        *)
            echo "Invalid input. Please answer 'y' or 'n'."
            ;;
    esac
done



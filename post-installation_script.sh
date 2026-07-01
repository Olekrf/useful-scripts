#!/bin/bash
set -e

packages=("nvim" "alacritty" "fish" "discord" "steam" "curl" "git" "firefox")


if [ -f /etc/os-release ]; then
    . /etc/os-release
    
    case "$ID" in
        fedora)
            sudo dnf install -y "${packages[@]}"
            sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null

sudo dnf install -y code

            ;;
        arch)
            sudo pacman -Syu --noconfirm "${packages[@]}"
            sudo pacman -S --noconfirm code
            ;;
    esac
else
    echo "Can't recognize your distribution"
    exit 1
fi


mkdir -p "$HOME/.config/alacritty"


curl -fsSL https://install.danklinux.com | sh

if ! grep -q 'program = "/usr/bin/fish"' "$HOME/.config/alacritty/alacritty.toml"; then
    echo -e "\n[terminal.shell]" >> "$HOME/.config/alacritty/alacritty.toml"
    echo 'program = "/usr/bin/fish"' >> "$HOME/.config/alacritty/alacritty.toml"
fi
if [ ! -d "$HOME/.config/nvim" ]; then
    git clone https://github.com/LazyVim/starter "$HOME/.config/nvim"
    rm -rf "$HOME/.config/nvim/.git"
fi

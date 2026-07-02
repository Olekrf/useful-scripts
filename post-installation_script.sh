#!/bin/bash
set -e

packages=("nvim" "alacritty" "fish" "steam" "curl" "git" "firefox" "dolphin" "htop" "fastfetch")


if [ -f /etc/os-release ]; then
    . /etc/os-release
    
    case "$ID" in
        fedora)
            sudo dnf install -y "${packages[@]}"
            sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null

sudo dnf install -y code

flatpak remote-add --if-not-exists flathub https://flathub.org
flatpak install flathub dev.vencord.Vesktop


            ;;
        arch)
            sudo pacman -S --needed git base-devel
            git clone https://archlinux.org/yay.git
            cd yay
            makepkg -si
            yay -S vesktop-bin
            sudo pacman -Syu --noconfirm "${packages[@]}"
            sudo pacman -S --noconfirm code sddm 
            ;;
    esac
else
    echo "Can't recognize distribution"
    exit 1
fi


mkdir -p "$HOME/.config/alacritty"

read -p "Install DankLinux with niri or hyprland? (y/n): " install_danklinux
if [[ "$install_danklinux" =~ ^[Yy]$ ]]; then
    curl -fsSL https://install.danklinux.com | sh
fi

if ! grep -q 'program = "/usr/bin/fish"' "$HOME/.config/alacritty/alacritty.toml"; then
    echo -e "\n[terminal.shell]" >> "$HOME/.config/alacritty/alacritty.toml"
    echo 'program = "/usr/bin/fish"' >> "$HOME/.config/alacritty/alacritty.toml"
fi
if [ ! -d "$HOME/.config/nvim" ]; then
    git clone https://github.com/LazyVim/starter "$HOME/.config/nvim"
    rm -rf "$HOME/.config/nvim/.git"
fi

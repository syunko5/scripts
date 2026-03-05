#!/bin/bash
set -e # Exit on error
sudo -v

# ----------------------
#       Variables
# ----------------------

pkgsCore=(
    hyprland
    noctalia-shell
    hyprshot
    swayimg
    xorg-xwayland
    xdg-desktop-portal-hyprland
    fish
    kitty
    yazi
    micro
    fastfetch
    fzf
    bat
    pulsemixer
    solaar
    ttf-jetbrains-mono-nerd
)
pkgsApps=(
    firefox
    vesktop
    steam
    spotify
    vscodium
    lobster
    ani-cli
)

# ----------------------
#       Functions
# ----------------------

preinstall() {
    echo "[SETUP] Running preinstallation scripts"
    sudo pacman -S --needed reflector --noconfirm
    sudo reflector -c Brazil,Argentina,Chile -a 12 -f 10 -p https --sort rate --save /etc/pacman.d/mirrorlist
	sudo pacman -Syy --needed base-devel git stow --noconfirm

    sudo sed -i '38c\ParallelDownloads = 50' /etc/pacman.conf
	sudo sed -i '94c\[multilib]' /etc/pacman.conf
	sudo sed -i '95c\Include = /etc/pacman.d/mirrorlist' /etc/pacman.conf
	
	cd ~
	git clone https://aur.archlinux.org/yay.git
	cd yay
	makepkg -si --noconfirm
	cd ..
	rm -rf yay
	
}

dotfiles_setup() {
	echo "[SETUP] Setting up dotfiles"
    cd ~
	git clone https://github.com/syunko5/dotfiles.git
	cd dotfiles
	stow .
	cd ..
}

install_packages() {
	echo "[SETUP] Installing packages"
	yay -S --needed "${pkgsCore[@]}", "${pkgsApps[@]}" --noconfirm
}

audio_services() {
	echo "[SETUP] Setting up audio services"
	yay -S --needed pipewire pipewire-alsa pipewire-pulse wireplumber --noconfirm
	systemctl --user enable pipewire
}

# ----------------------
#       Execution
# ----------------------

preinstall
dotfiles_setup
install_packages
audio_services

sudo pacman -Syyu --noconfirm
echo "[SETUP] Script finished!"

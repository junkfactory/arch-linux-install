#!/bin/bash
# TODO: Make this script interactive

ln -s /usr/bin/vim /usr/bin/vi
export EDITOR=vim
useradd -m -g users -G storage,power amontecillo
passwd amontecillo

ln -sf /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
# uncomment en_US.UTF-8
sed -i '177s/.//' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "vivo-arch" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 vivo-arch.localdomain vivo-arch" >> /etc/hosts

sudo timedatectl set-ntp true
sudo hwclock --systohc

sudo reflector -c US -a 20 -p "https,http" -f 10 --sort rate --save /etc/pacman.d/mirrorlist

pacman -S --noconfirm \
    linux-zen \
    linuz-zen-headers \
    linux-firmware \
    btrfs-progs \
    grub \
    efibootmgr \
    networkmanager \
    network-manager-applet \
    dialog \
    wpa_supplicant \
    avahi \
    xdg-user-dirs \
    xdg-utils \
    gvfs \
    gvfs-smb \
    nfs-utils \
    inetutils \
    dnsutils \
    bluez \
    bluez-utils \
    alsa-utils \
    pulseaudio \
    openssh \
    bash-completion \
    openssh \
    rsync \
    acpi \
    acpi_call \
    tlp \
    dnsmasq \
    blueman \
    nss-mdns \
    acpid \
    ntfs-3g \
    terminus-font \
    xf86-video-amdgpu \

#xfce desktop
pacman -S --noconfirm \
    xorg-server \
    lightdm \
    lightdm-gtk-greeter \
    lightdm-gtk-greeter-settings \
    xfce4 \
    xfce4-goodies \
    arc-gtk-theme \
    arc-icon-theme 


grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable avahi-daemon
systemctl enable tlp 
systemctl enable reflector.timer
systemctl enable fstrim.timer
systemctl enable acpid
sudo systemctl enable lightdm

echo "amontecillo ALL=(ALL) ALL" >> /etc/sudoers.d/amontecillo

# TODO
# vi /etc/mkinitcpio.conf
# ### update modules with btrfs
# MODULES=(btrfs amdgpu)
# Rebuild init cpio
# mkiniticpio -p linux-zen






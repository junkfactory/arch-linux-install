#!/bin/bash

ln -sf /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
hwclock --systohc
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

sudo reflector -c US -a 12 --sort rate --save /etc/pacman.d/mirrorlist


# You can add xorg to the installation packages, I usually add it at the DE or WM install script
# You can remove the tlp package if you are installing on a desktop or vm

pacman -S --noconfirm \
    grub \
    efibootmgr \
    networkmanager \
    network-manager-applet \
    dialog \
    wpa_supplicant \
    mtools \
    dosfstools \
    reflector \
    base-devel \
    linux-headers \
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
    # cups \
    hplip \
    alsa-utils \
    pulseaudio \
    bash-completion \
    openssh \
    rsync \
    reflector \
    acpi \
    acpi_call \
    tlp \
    virt-manager \
    qemu \
    qemu-arch-extra \
    edk2-ovmf \
    bridge-utils \
    dnsmasq \
    vde2 \
    openbsd-netcat \
    ebtables \
    iptables \
    ipset \
    firewalld \
    flatpak \
    sof-firmware \
    nss-mdns \
    acpid \
    os-prober \
    ntfs-3g \
    terminus-font

# pacman -S --noconfirm xf86-video-amdgpu
# pacman -S --noconfirm nvidia nvidia-utils nvidia-settings

grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable NetworkManager
systemctl enable bluetooth
# systemctl enable cups.service
# systemctl enable sshd
systemctl enable avahi-daemon
systemctl enable tlp # You can comment this command out if you didn't install tlp, see above
systemctl enable reflector.timer
systemctl enable fstrim.timer
systemctl enable libvirtd
systemctl enable firewalld
systemctl enable acpid

echo "amontecillo ALL=(ALL) ALL" >> /etc/sudoers.d/amontecillo

printf "\e[1;32mDone! Type exit, umount -a and reboot.\e[0m"




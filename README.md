# Installing Arch Linux for Dummies
Download the archlinux iso and flash to a udb drive the boot it.

## Setup Partitions
Make sure you're operating on the correct drive
```
fdisk -l
```
Create partitions with new GPT
```
fdisk /dev/nvme0n1
/dev/nvme0n1p1 - EFI
/dev/nvme0n1p2 - Linux swap
/dev/nvme0n1p3 - Linux filesystem
```
Format partitions
```
mkfs.fat -F32 /dev/nvme0n1p1
mkswap /dev/nvme0n1p2
mkfs.btrfs /dev/nvme0n1p3
```
Create BTRFS subvolumes
```
mount /dev/nvme0n1p3 /mnt
cd /mnt
btrfs subvolume create @
btrfs subvolume create @home
#unmount filesystem for new mount options
cd
umount /mnt
```
Mount partitions with proper options for BTRFS
```
mount -o noatime,compress=zstd,space_cache=v2,discard=async,subvol=@ \
    /dev/nvme0n1p3 /mnt
mkdir -p /mnt/boot/efi
mkdir /mnt/home
mount -o noatime,compress=zstd,space_cache=v2,discard=async,subvol=@home \
    /dev/nvme0n1p3 /mnt/home
mount /dev/nvme0n1p1 /mnt/boot/efi
swapon /dev/nvme0n1p2
```
Generate fstab
```
genfstab -U /mnt >> /mnt/etc/fstab
```
Bootstrap Arch Linux
```
pacstrap /mnt base
arch-chroot /mnt
```
Setup users and password
```
useradd -m -g users -G storage,power amontecillo
passwd amontecillo
```
## Configure system
Install linux zen kernel
```
pacman -S linux-zen linux-zen-headers linux-firmware git vim
ln -s /usr/bin/vim /usr/bin/vi
```
Clone and execute base-install-uefi.sh
```
git clone https://github.com/junkfactory/arch-linux-install.git
cd arch-linux-install
./base-install-uefi.sh
```
Update mkinitcpio.conf
```
vi /etc/mkinitcpio.conf
### update modules with btrfs
MODULES=(btrfs amdgpu)
```
Rebuild init cpio
```
mkiniticpio -p linux-zen
```
Reboot system and hope it boots up
```
exit
umount -a
reboot
```
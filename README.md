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
swapon /dev/nvme0n1p2
```

Bootstrap Arch Linux
```
pacstrap /mnt base base-devel reflector git vim
genfstab -U /mnt >> /mnt/etc/fstab
mount /dev/nvme0n1p1 /mnt/boot/efi
arch-chroot /mnt
```
## Configure system
Clone and execute base-install-uefi.sh
```
git clone https://github.com/junkfactory/arch-linux-install.git
cd arch-linux-install
./base-install-uefi.sh
```
Reboot system and hope it boots up
```
exit
umount -a
reboot
```
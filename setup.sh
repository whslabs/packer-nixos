#! /bin/sh

parted /dev/vda -- mklabel gpt
parted /dev/vda -- mkpart primary 512MB -8GB
parted /dev/vda -- mkpart primary linux-swap -8GB 100%
parted /dev/vda -- mkpart ESP fat32 1MB 512MB
parted /dev/vda -- set 3 esp on

mkfs.ext4 -L nixos /dev/vda1
mkswap -L swap /dev/vda2
swapon /dev/vda2
mkfs.fat -F 32 -n boot /dev/vda3
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot
nixos-generate-config --root /mnt
curl -o /mnt/etc/nixos/configuration.nix $HTTP/configuration.nix
nixos-install --no-root-password
reboot

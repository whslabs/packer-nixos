#! /bin/sh

parted /dev/vda -- mklabel msdos
parted /dev/vda -- mkpart primary 1MB -8GB

parted /dev/vda -- mkpart primary linux-swap -8GB 100%

mkfs.ext4 -L nixos /dev/vda1
mkswap -L swap /dev/vda2

mount /dev/disk/by-label/nixos /mnt/

swapon /dev/vda2

nixos-generate-config --root /mnt/

curl -o /mnt/etc/nixos/configuration.nix $HTTP/configuration.nix

nixos-install --no-root-password

reboot

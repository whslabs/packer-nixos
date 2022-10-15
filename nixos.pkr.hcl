packer {
  required_plugins {
    qemu = {
      version = ">= 1.0.6"
      source  = "github.com/hashicorp/qemu"
    }
  }
}

source "qemu" "nixos" {
  accelerator  = "kvm"
  boot_wait    = "5s"
  disk_size    = "100G"
  iso_checksum = "42188c4b51bcf6bad19c5c46f521f82c85f210fcb8028d25094f8c12cd9b2c16"
  iso_url      = "https://channels.nixos.org/nixos-22.05/latest-nixos-minimal-x86_64-linux.iso"
  memory       = 8192
  ssh_password = "packer"
  ssh_username = "packer"
  boot_command = [
    "<enter><wait20>",

    "sudo -i<enter>",

    "parted /dev/vda -- mklabel msdos<enter>",
    "parted /dev/vda -- mkpart primary 1MB -8GB<enter>",

    "parted /dev/vda -- mkpart primary linux-swap -8GB 100%<enter>",

    "mkfs.ext4 -L nixos /dev/vda1<enter>",
    "mkswap -L swap /dev/vda2<enter>",

    "mount /dev/disk/by-label/nixos /mnt/<enter>",

    "swapon /dev/vda2<enter>",

    "nixos-generate-config --root /mnt/<enter>",

    "curl -o /mnt/etc/nixos/configuration.nix http://{{ .HTTPIP }}:{{ .HTTPPort }}/configuration.nix<enter>",

    "nixos-install --no-root-password && reboot<enter>",
  ]
  http_content = {
    "/configuration.nix" = file("configuration.nix")
  }
}

build {
  sources = ["source.qemu.nixos"]
}

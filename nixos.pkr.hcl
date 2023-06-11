packer {
  required_plugins {
    qemu = {
      version = ">= 1.0.9"
      source  = "github.com/hashicorp/qemu"
    }
  }
}

source "qemu" "nixos" {
  accelerator  = "kvm"
  boot_wait    = "5s"
  disk_size    = "100G"
  efi_boot     = true
  iso_checksum = "c3d3387c84393269a1f8d4b8122d1fda1b195879ac250e6cf51e7498010f026e"
  iso_url      = "https://channels.nixos.org/nixos-23.05/latest-nixos-minimal-x86_64-linux.iso"
  memory       = 4096
  ssh_password = "packer"
  ssh_username = "packer"
  boot_command = [
    "<enter><wait20>",

    "sudo -i<enter>",

    "export HTTP=http://{{ .HTTPIP }}:{{ .HTTPPort }}<enter>",

    "curl $HTTP/setup.sh | sh<enter>",
  ]
  http_content = {
    "/configuration.nix" = file("configuration.nix")
    "/setup.sh"          = file("setup.sh")
  }
}

build {
  sources = ["source.qemu.nixos"]
}

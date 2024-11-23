packer {
  required_plugins {
    qemu = {
      version = ">= 1.1.0"
      source  = "github.com/hashicorp/qemu"
    }
  }
}

source "qemu" "nixos" {
  accelerator  = "kvm"
  boot_wait    = "5s"
  disk_size    = "100G"
  efi_boot     = true
  iso_checksum = "7d0fea5002a2d36223cb2da99bc6598b613c8147d379be5f7bc4eeb964556746"
  iso_url      = "https://channels.nixos.org/nixos-24.05/latest-nixos-minimal-x86_64-linux.iso"
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

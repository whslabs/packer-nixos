```sh
packer init nixos.pkr.hcl
^init^build^
(
name=nixos
cp output-nixos/packer-nixos $name.qcow2
virt-install \
  --boot loader=/usr/share/edk2/ovmf/OVMF_CODE.fd \
  --connect qemu:///system \
  --disk $name.qcow2 \
  --import \
  --memory 2048 \
  --name $name \
  --network bridge:virbr0 \
  --os-variant nixos-unstable \
  --vcpus 2 \
  ;
)
```

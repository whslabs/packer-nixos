```sh
packer init nixos.pkr.hcl
^init^build^
(
name=nixos
cp output-nixos/packer-nixos $name.qcow2
virt-install \
  --disk $name.qcow2 \
  --import \
  --memory 2048 \
  --name $name \
  --network bridge:virbr0 \
  --os-variant nixos-22.05 \
  --vcpus 2 \
  ;
)
```

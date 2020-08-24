# Terrafom Provisionar Ambiente KVM - libvit
Script terraform para provisionar multiplas instâncias de VMs em ambiente KVM - libvit. Utilizando uma imagem base(.iso) Centos7.8.

#### Pré requisitos:
- KVM libvirt
- golang v1.13
- Terraform v0.12
- Terraforme plugin terraform-provider-libvirt (https://github.com/dmacvicar/terraform-provider-libvirt)

Neste script a variavél instance_count, default=3 determinará o número de instancias que serão provisionadas.

```terraform
variable "instance_count" {
  default = "3"
}

```

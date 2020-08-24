# Script Proviona Ambiente Cluster Cloudera com 3 VMs
# Autor: Michael Christian
# github: mchristian279

provider "libvirt" {
  uri = "qemu:///system"
}

#Inicio Bloco de variaveis
variable "instance_count" {
  default = "3"
}

variable "disk_img" {
  default = "file:///home/mreis/Imagens/CentOS-7-x86_64-GenericCloud-1511.qcow2"
}

variable "vm_network_addresses" {
  description = "Configura Rede"
  default     = "192.168.10.0/24"
}

variable "vm_addresses" {
  default = {
    "0" = "192.168.10.10"
    "1" = "192.168.10.11"
    "2" = "192.168.10.12"
  }

}

variable "vm_network_name" {
  description = "Define o nome da rede no KVM"
  default     = "clustercloudera"
}

variable "domain_name" {
  default = "lab.local"
}
#Fim bloco de variaveis

#Inicio configuracao de provisionamento
resource "libvirt_volume" "os_image" {
  name   = "os_image"
  pool   = "Dados"
  source = var.disk_img
}

#Volume
resource "libvirt_volume" "volume" {
  name           = "cloudera-${count.index}"
  pool           = "Dados"
  base_volume_id = libvirt_volume.os_image.id
  count          = var.instance_count
}

#Rede
resource "libvirt_network" "vm_network" {

  name      = var.vm_network_name
  addresses = ["${var.vm_network_addresses}"]
  domain    = var.domain_name
  mode      = "nat"
  dhcp {
    enabled = false
  }

  dns {
    local_only = true
  }

  autostart = true
}

#VM
resource "libvirt_domain" "domain" {
  name   = "cloudera-${count.index}"
  memory = "1024"
  vcpu   = "2"

  network_interface {
    network_id     = libvirt_network.vm_network.id
    hostname       = "cloudera-${count.index}"
    addresses      = ["${var.vm_addresses[count.index]}"]
    wait_for_lease = true

  }

  disk {
    volume_id = libvirt_volume.volume[count.index].id
  }
  count = var.instance_count
}

#Saidas
output "Disco" {
  value = libvirt_volume.volume.*.id
}

output "Rede" {
  value = libvirt_network.vm_network.id
}

output "IP" {
  value = libvirt_domain.domain.*.network_interface.0.addresses
}
#Fim configuracao de provisionamento

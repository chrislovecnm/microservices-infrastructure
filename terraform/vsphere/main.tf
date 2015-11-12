variable "datacenter" {}
variable "cluster" {}
variable "template" {}
variable "ssh_user" {}
variable "consul_dc" {}
variable "network_interface_label" {}
variable "datastore" {}

variable "short_name" {default = "mi"}
variable "long_name" {default = "microservices-infrastructure"}

variable "control_count" {default = 3}
variable "worker_count" {default = 2}
variable "control_vcpu" { default = 1 }
variable "worker_vcpu" { default = 1 }
variable "control_ram" { default = 4096 }
variable "worker_ram" { default = 4096 }

provider "vsphere" {
  user           = "${var.vsphere_user}"
  password       = "${var.vsphere_password}"
  vcenter_server = "${var.vcenter_server}"
}

resource "vsphere_virtual_machine" "mi-control-nodes" {
  name = "${var.short_name}-control-${format("%02d", count.index+1)}"
  domain = "localdomain"

  datacenter = "${var.datacenter}"
  cluster = "${var.cluster}"

  vcpu = "${var.control_vcpu}"
  memory = "${var.control_ram}"

  network_interface {
    label = "${var.network_interface_label}"
  }

  disk {
    datastore = "${var.datastore}"
    template =  "${var.template}"
    size=32
  }

  count = "${var.control_count}"

  custom_configuration_parameters = {
    "role" = "control"
    "ssh_user" = "${var.ssh_user}"
    "consul_dc" = "${var.consul_dc}"
  }
}

resource "vsphere_virtual_machine" "mi-worker-nodes" {
  name = "${var.short_name}-worker-${format("%03d", count.index+1)}"
  domain = "localdomain"

  datacenter = "${var.datacenter}"
  cluster = "${var.cluster}"

  vcpu = "${var.worker_vcpu}"
  memory = "${var.worker_ram}"

  network_interface {
    label = "${var.network_interface_label}"
  }

  disk {
    datastore = "${var.datastore}"
    template =  "${var.template}"
    size=32
  }

  count = "${var.worker_count}"

  custom_configuration_parameters = {
    "role" = "worker"
    "ssh_user" = "${var.ssh_user}"
    "consul_dc" = "${var.consul_dc}"
  }
}

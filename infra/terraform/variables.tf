// ========================================================================== //
// Infrastructure variables

variable "proxmox_node_name" {
  description = "The name of the Proxmox node (there's only one at the moment)."
  type        = string
}

variable "proxmox_datastore" {
  description = "The default datastore to use for VM disks."
  type        = string
}

variable "ubuntu2604_template_vm_id" {
  description = "The VM ID of the Ubuntu 26.04 template VM to clone."
  type        = number
}

variable "network_prefix" {
  description = "The network prefix to use for the home network."
  type        = string
}

variable "network_mask" {
  description = "Network mask to use for the home network."
  type        = string
}

variable "dns_servers" {
  description = "The DNS servers to use for the VMs."
  type        = list(string)
}
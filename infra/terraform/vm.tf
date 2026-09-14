resource "proxmox_virtual_environment_vm" "k3s_nodes" {
  for_each  = local.k3s_nodes

  name      = each.key
  vm_id     = each.value.vm_id
  node_name = var.proxmox_node_name

  clone {
    vm_id = var.ubuntu2604_template_vm_id
  }

  agent {
    enabled = true
  }
  
  cpu {
    cores = each.value.cpu_cores
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = each.value.memory_mb
  }

  disk {
    datastore_id = var.proxmox_datastore
    interface    = "scsi0"
  }

  initialization {
    dns {
      servers = var.dns_servers
    }
    ip_config {
      ipv4 {
        address = each.value.ip_address
      }
    }
  }
}
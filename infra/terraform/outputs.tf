output "k3s_nodes" {
  description = "K3s node information"

  value = {
    for name, vm in proxmox_virtual_environment_vm.k3s_nodes :
    name => {
      vm_id      = vm.vm_id
      cpu_cores  = local.k3s_nodes[name].cpu_cores 
      memory_mb  = local.k3s_nodes[name].memory_mb
      ip_address = split("/", local.k3s_nodes[name].ip_address)[0]
    }
  }
}
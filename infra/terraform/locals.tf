locals {
    k3s_nodes = {
        "k3s-master" = {
            vm_id       = 100
            cpu_cores   = 2
            memory_mb   = 8192
            ip_address  = "${var.network_prefix}.210/${var.network_mask}"
        }
        "k3s-worker-1" = {
            vm_id       = 101
            cpu_cores   = 1
            memory_mb   = 8192 
            ip_address  = "${var.network_prefix}.211/${var.network_mask}"
        }
        "k3s-worker-2" = {
            vm_id       = 102
            cpu_cores   = 1
            memory_mb   = 8192
            ip_address  = "${var.network_prefix}.212/${var.network_mask}"
        }
    }
}
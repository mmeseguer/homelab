terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "~>0.112.0"
    }
  }
}

provider "proxmox" {
    # No endpoint or api_token set, we use environment variables instead:
    # export PROXMOX_VE_ENDPOINT='https://server_ip:8006/'
    # export PROXMOX_VE_API_TOKEN='your_api_token_here'
}
# Infra

In this folder reside all the necessary pieces to go from a freshly installed Proxmox server to an operational Kubernetes homelab cluster.

## What's here

| Folder | Tool | What it does |
|---|---|---|
| [`proxmox/`](./proxmox) | Bash + Manual | Creates LXCs and VM templates on the hypervisor. Meant to be executed on the Proxmox host |
| [`terraform/`](./terraform) | Terraform | Provisions the k3s node VMs from the template |
| [`bootstrap/`](./bootstrap) | Bash + Manual | Configuration done before Ansible own the provisioning |
| [`ansible/`](./ansible) | Ansible | Configuration management for all hosts (single inventory) |

## Execution order by host type

**Proxmox** (✅ in production)
1. [`proxmox/host-setup.md`](./proxmox/host-setup.md) - Configure Proxmox after a typical installation

**Management LXC** (🚧 in progress)
1. [`proxmox/management-lxc.sh`](./proxmox/management-lxc.sh) — creates LXC 200 in Proxmox
2. [`bootstrap/management-lxc-bootstrap.md`](./bootstrap/management-lxc-bootstrap.md) — manual steps (base packages, GitHub auth, cloning the repo)
3. `ansible-playbook playbooks/management.yaml` — applies the necessary roles to setup the management LXC.

**K3s nodes** (🚧 in progress)
1. [`proxmox/ubuntu_img.sh`](./proxmox/ubuntu_img.sh) — builds the Ubuntu cloud-init template
2. `terraform/` — creates the node VMs from the template *(pending)*
3. cloud-init / `bootstrap/` — minimal prep before Ansible
4. `ansible/` — `k3s` role *(pending)*

## Why it's organized this way

Each tool lives in a single folder (one Ansible inventory, one Terraform state) instead of being duplicated per host type. The actual execution order differs by host, so it's documented here rather than encoded in folder names.
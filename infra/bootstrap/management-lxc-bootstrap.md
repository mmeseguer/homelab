# Bootstrap

Necessary steps to prepare a new management host before the configuration gets owned by Ansible

## Prerrequisites

The host must have:
- User configured with sudo permissions
- SSH access configured with public key authentication

All of this is handled through the [proxmox/management-lxc.sh](../proxmox/management-lxc.sh) script during LXC creation.

## Install bootstrap tools

```bash
sudo apt update
sudo apt install -y git gh ansible
```

## GitHub authentication

```bash
gh auth login
```

Select:

```
GitHub.com
HTTPS
Login with a web browser
```

Configure Git to use the credentials from Github CLI:

```bash
gh auth setup-git
```

Check authentication:

```bash
gh auth status
```

## Clone the repository

```bash
git clone https://github.com/mmeseguer/homelab.git ~/homelab
```
## Apply Ansible configuration

```bash
cd ~/homelab/ansible
ansible-playbook playbooks/management.yaml
```

## Add the private SSH key

```bash
vim ~/.ssh/id_rsa
# Paste the private key
chmod 600 .ssh/id_rsa
```
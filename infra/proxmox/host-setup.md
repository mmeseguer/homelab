# Proxmox host setup

One-time manual steps performed after the initial Proxmox install, before any automation existed.

Everything is executed in the Proxmox host through SSH.

## Create a Proxmox administrator and disable the default one

Always a good practice to be done to avoid automated attacks through obscurity. Replace with the real username:

```bash
username=toreplace
pveum user add "$username@pve"
pveum passwd "$username@pve"
pveum aclmod / -user "$username@pve" -role Administrator

pveum user modify root@pam --enable 0
```

## Harden SSH connection

Same principle, disable the default root access through SSH and use a separated user with only Public Key authentication.

- Install and configure passwordless sudo for the user
```bash
# Reusing the previously set $username variable
apt update && apt install sudo
echo "$username ALL=(ALL) NOPASSWD:ALL" > "/etc/sudoers.d/90-$username"
```
- Create user
```bash
useradd -m -s /bin/bash $username
usermod -aG sudo $username
```
- Setup public key
```bash
su - $username
mkdir ~/.ssh
vi ~/.ssh/authorized_keys # add the public key
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
exit # to return to the root user
```
- Check that we are able to login to the newly created user through SSH using public key and that sudo works as expected
- Harden sshd:
```bash
echo "PasswordAuthentication no" > /etc/ssh/sshd_config.d/90-homelab.conf
echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config.d/90-homelab.conf
echo "PermitRootLogin no" >> /etc/ssh/sshd_config.d/90-homelab.conf

service sshd restart
```
## Install cloud-image-utils

To be able to interact with Cloud init
```bash
apt update && apt install -y cloud-image-utils
```

## Create user for Terraform

Create a dedicated user for Terraform and limit its permissions

```bash
# Create user
pveum user add terraform@pve

# Create role
pveum role add Terraform -privs "VM.Allocate,VM.Audit,VM.Clone,VM.Config.CPU,VM.Config.Memory,VM.Config.Disk,VM.Config.Network,VM.Config.Cloudinit,VM.Config.Options,VM.Config.HWType,VM.PowerMgmt,Datastore.AllocateSpace,Datastore.Audit,SDN.Use,Sys.Audit"

# Assign role
pveum aclmod / -user terraform@pve -role Terraform
```

Create the API token for the user

```bash
pveum user token add terraform@pve provider --privsep=0
```

Save the output in the password manager as there's no way to get this information again, it should be regenerated.
# This script downloads the latest Ubuntu 26.04 cloud image and creates a Proxmox template VM with cloud-init support.
# It is meant to be executed on the Proxmox host, and it requires internet access to download the image.

# Download the latest Ubuntu 26.04 cloud image
img_name="ubuntu-26.04-cloudinit.img"
wget https://cloud-images.ubuntu.com/resolute/current/resolute-server-cloudimg-amd64.img -O $img_name

# Create a template VM for the Ubuntu cloud image
vm_id=9000
name="ubuntu26.04-cloudinit-template"
memory=2048
cores=2

qm create $vm_id --name $name --memory $memory --cores $cores --net0 virtio,bridge=vmbr0

# Import the cloud image into the VM
qm importdisk $vm_id $img_name local-lvm
qm set $vm_id --scsihw virtio-scsi-pci --scsi0 local-lvm:vm-$vm_id-disk-0
qm set $vm_id --ide2 local-lvm:cloudinit
qm set $vm_id --boot order=scsi0

# Configure the Proxmox integrated console
qm set $vm_id --serial0 socket --vga serial0

# Pre-create admin user with its ssh public key
ssh_pub_key="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQChVlO1xIsJrUIZKQWUr/gMUH6dBsSG77YdgKtQ2vbaReAdjIyUVRfoS6dzuvc8XE8WCWFnuIjA68eZ8OuadBfCIoiviGO3ru1/yuFpLdtnwYsv4xw9Rt/OaOWdM7+2AMPJ1hwPLl6v6e2gJReWir/3YRLMp7lc9z1olvVsySDMElrykl1F8EjiJFm7vkWI+A7IDFtRpM02ngAaScvouXYrMJFHj4ZRCC1L/856D1GgiGZIMlNDN6uayKi3lXhUBs4h6cq+1ZowY0n/hb0BnxlG1RPYOV58a29toUkL3a1um/kgQBBU86P/JepFG8SH6g8kBRXGFGDPeRfBIGWnf4/Kn/YKEz7kkf6ZL4EWX4aAGuwCDYjvlgG6MkgEg0TMtdU4pfVqDLIAZehjdz/jNM0/ccE2CPpue56ovJ2DQckPt1IGNYlyNCEfYGCurkm3SMQOlFRwzNTRIS29NMpOe1rDK8NLaP4egr7o/4GcUmvrZ4KpsQGbAQBpnwr3S5mD7/M="

echo $ssh_pub_key > id_rsa.pub

qm set $vm_id --sshkey id_rsa.pub

# Set as template
qm template $vm_id

# Clean up
rm id_rsa.pub
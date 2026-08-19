#######################################################################################################################################
# The initial deploy of the LXC jump host is done directly on the Proxmox host,
# the reason for this is to avoid innecessary complexity in the initial setup.
# The script makes the necessary configurations so that the container is ready to be provisioned with Ansible.
#######################################################################################################################################

# Configuration
lxc_id="200"
hostname="management"
ip="192.168.0.250/24"
gw="192.168.0.1"
cores="2"
memory="2048"
swap="512"
user="marc"

# Create a new LXC container for the jump host
pct create $lxc_id local:vztmpl/ubuntu-24.04-standard_24.04-2_amd64.tar.zst \
  --hostname $hostname \
  --cores $cores \
  --memory $memory \
  --swap $swap \
  --rootfs local-lvm:8 \
  --net0 name=eth0,bridge=vmbr0,ip=$ip,gw=$gw \
  --unprivileged 1 \
  --features nesting=1,keyctl=1 \
  --ssh-public-keys /root/.ssh/authorized_keys

# Start the container and enable it to start on boot
pct start $lxc_id
pct set $lxc_id -onboot 1

# Set up the user account and SSH access
pct exec $lxc_id -- useradd \
  --create-home \
  --shell /bin/bash \
  $user

pct exec $lxc_id -- usermod \
  --append \
  --groups sudo \
  $user

pct exec $lxc_id -- mkdir -p /home/$user/.ssh
pct push $lxc_id /root/.ssh/authorized_keys /home/$user/.ssh/authorized_keys

pct exec $lxc_id -- chown -R $user:$user /home/$user/.ssh
pct exec $lxc_id -- chmod 700 /home/$user/.ssh
pct exec $lxc_id -- chmod 600 /home/$user/.ssh/authorized_keys

pct exec $lxc_id -- sh -c \
  "echo \"$user ALL=(ALL) NOPASSWD:ALL\" > /etc/sudoers.d/$user"

pct exec $lxc_id -- chmod 440 /etc/sudoers.d/$user
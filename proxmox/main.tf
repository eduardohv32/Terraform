variable "cloud_init_template_name"{
    type = string
}

 variable "proxmox_node"{
    type = string
}

# variable "ssh_key" {
#    type = string
#    sensitive = true
#}

resource "proxmox_vm_qemu" "Debian12" {
  count = 1
  name = "Debian11-test"
  target_node = var.proxmox_node
  clone = var.cloud_init_template_name
  agent = 1
  os_type = "cloud-init"
  cores = 1
  sockets = 1
  cpu = "host"
  memory = 2048
  scsihw = "virtio-scsi-pci"
  bootdisk = "scsi0"

  disk {
    slot = 0
    size = "20G"
    type = "scsi"
    storage = "local"
  }

  network {
    model = "virtio"
    bridge = "vmbr0"
  }
  
  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  ipconfig0 = "ip=10.0.1.20${count.index + 1}/24,gw=10.0.1.1"
  nameserver = "10.0.1.250"
  
  #sshkeys = <<EOF
  #${var.ssh_key}
  #EOF
}
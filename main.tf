terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "2.6.7"
    }
  }
}

provider "proxmox" {
  pm_api_url = "https://192.168.171.119:8006/api2/json"
  pm_user = "terraform@pam"
  pm_password = var.proxmox_pass
  pm_tls_insecure = true
  pm_log_enable = true
}

locals {
  admin_user = "benjamin"
  search_domain = "flat.lan"
}

variable "proxmox_pass" {
  sensitive = true
  type = string
  description = "proxmox ve password"
}
variable "admin_password" {
  description = "admin user password in vm"
  sensitive = true
  type = string
}
variable "ssh_pub_key" {
  type = string
}

resource "proxmox_vm_qemu" "ubu-wiki" {
  name = "wiki"
  target_node = "proxmox"
  desc = "Personal Wiki. Managed by terraform"
  clone = "ci-ubuntu-template"
  os_type = "cloud-init" 
  memory = 2048
  cores = 2

  # cloud init settings
  ciuser = local.admin_user
  cipassword = var.admin_password
  sshkeys = var.ssh_pub_key
  ipconfig0 = "dhcp"
  searchdomain = local.search_domain
}
variable "prefix" {
  description = "Name prefix for all Azure resources."
  type        = string
  default     = "vm-demo"
}

variable "vm_name" {
  description = "Virtual machine name."
  type        = string
  default     = "vm-demo-01"
}

variable "location" {
  description = "Azure region for the VM stack."
  type        = string
  default     = "eastus"
}

variable "vm_size" {
  description = "Azure VM size."
  type        = string
  default     = "Standard_B2s"
}

variable "admin_username" {
  description = "Admin username for SSH access."
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key" {
  description = "SSH public key content for the VM admin user."
  type        = string
}

variable "vnet_cidr" {
  description = "CIDR block for the virtual network."
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block for the VM subnet."
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_ssh_source_cidr" {
  description = "Private CIDR allowed to SSH to the VM over the VNet."
  type        = string
  default     = "10.0.0.0/16"
}

variable "tags" {
  description = "Tags applied to all created resources."
  type        = map(string)
  default = {
    managed_by = "terraform"
  }
}

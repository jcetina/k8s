variable "location" {
  type        = string
  description = "Location for the vm"
}

variable "rg_name" {
  type        = string
  description = "Resource group name for the vm"

}

variable "vm_name" {
  type        = string
  description = "Name for the vm"
}

variable "ssh_key" {
  type        = string
  description = "SSH key for the vm"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID for the vm"
}

variable "create_public_ip" {
  type        = bool
  description = "Create a public IP for the vm"
  default     = false
}

variable "zones" {
  type        = list(string)
  description = "Zones for the vm"
  default     = []
}

variable "vm_sku" {
  type        = string
  description = "VM SKU for the vm"
  default     = "Standard_DS1_v2"
}

variable "zone" {
  type        = string
  description = "Zone for the vm"
}
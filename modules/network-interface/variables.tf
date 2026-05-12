variable "name" {
  description = "Name of the network interface."
  type        = string
}

variable "location" {
  description = "Azure region for the network interface."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group where the network interface is created."
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for the NIC IP configuration."
  type        = string
}

variable "public_ip_id" {
  description = "Public IP ID attached to the NIC."
  type        = string
}

variable "tags" {
  description = "Tags applied to the network interface."
  type        = map(string)
  default     = {}
}

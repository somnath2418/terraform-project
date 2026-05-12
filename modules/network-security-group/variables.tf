variable "name" {
  description = "Name of the network security group."
  type        = string
}

variable "location" {
  description = "Azure region for the network security group."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group where the network security group is created."
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID associated with this network security group."
  type        = string
}

variable "rdp_source_address_prefix" {
  description = "Source CIDR allowed to RDP. Use a trusted public IP range, not 0.0.0.0/0, for production."
  type        = string
  default     = "*"
}

variable "tags" {
  description = "Tags applied to the network security group."
  type        = map(string)
  default     = {}
}

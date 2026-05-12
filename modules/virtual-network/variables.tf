variable "name" {
  description = "Name of the virtual network."
  type        = string
}

variable "location" {
  description = "Azure region for the virtual network."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group where the virtual network is created."
  type        = string
}

variable "address_space" {
  description = "CIDR blocks for the virtual network."
  type        = list(string)

  validation {
    condition     = length(var.address_space) > 0
    error_message = "At least one VNet address space must be provided."
  }
}

variable "dns_servers" {
  description = "Optional custom DNS servers."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags applied to the virtual network."
  type        = map(string)
  default     = {}
}

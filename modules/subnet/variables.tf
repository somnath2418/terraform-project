variable "name" {
  description = "Name of the subnet."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group containing the virtual network."
  type        = string
}

variable "virtual_network_name" {
  description = "Virtual network where the subnet is created."
  type        = string
}

variable "address_prefixes" {
  description = "CIDR prefixes for the subnet."
  type        = list(string)

  validation {
    condition     = length(var.address_prefixes) > 0
    error_message = "At least one subnet address prefix must be provided."
  }
}

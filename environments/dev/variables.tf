variable "location" {
  description = "Azure region for dev resources."
  type        = string
  default     = "eastus"
}

variable "vnet_address_space" {
  description = "Dev virtual network address space."
  type        = list(string)
  default     = ["10.10.0.0/16"]
}

variable "subnet_address_prefixes" {
  description = "Dev subnet address prefixes."
  type        = list(string)
  default     = ["10.10.1.0/24"]
}

variable "vm_size" {
  description = "Dev Windows VM size."
  type        = string
  default     = "Standard_D2s_v3"
}

variable "admin_username" {
  description = "Windows local administrator username."
  type        = string
  sensitive   = true
}

variable "admin_password" {
  description = "Windows local administrator password."
  type        = string
  sensitive   = true
}

variable "rdp_source_address_prefix" {
  description = "Trusted source CIDR for RDP access."
  type        = string
  default     = "*"
}

variable "enable_auto_shutdown" {
  description = "Enable VM auto-shutdown."
  type        = bool
  default     = true
}

variable "auto_shutdown_time" {
  description = "Daily auto-shutdown time in HHMM 24-hour format."
  type        = string
  default     = "1900"
}

variable "auto_shutdown_timezone" {
  description = "Timezone used by the shutdown schedule."
  type        = string
  default     = "UTC"
}

variable "tags" {
  description = "Additional tags for dev resources."
  type        = map(string)
  default = {
    Owner      = "platform-team"
    CostCenter = "it-dev"
  }
}

variable "name" {
  description = "Name of the Windows virtual machine."
  type        = string

  validation {
    condition     = length(var.name) <= 64
    error_message = "Azure Windows VM resource name must be 64 characters or fewer."
  }
}

variable "computer_name" {
  description = "Windows computer name. Must be 15 characters or fewer."
  type        = string

  validation {
    condition     = length(var.computer_name) >= 1 && length(var.computer_name) <= 15
    error_message = "Windows computer_name must be between 1 and 15 characters."
  }
}

variable "location" {
  description = "Azure region for the virtual machine."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group where the virtual machine is created."
  type        = string
}

variable "vm_size" {
  description = "Azure VM size."
  type        = string

  validation {
    condition     = can(regex("^Standard_[A-Za-z0-9]+", var.vm_size))
    error_message = "VM size must be a valid Azure Standard_* size."
  }
}

variable "admin_username" {
  description = "Local administrator username for the Windows VM."
  type        = string
  sensitive   = true

  validation {
    condition     = !contains(["administrator", "admin", "user", "test"], lower(var.admin_username))
    error_message = "Use a non-default administrator username."
  }
}

variable "admin_password" {
  description = "Local administrator password for the Windows VM."
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.admin_password) >= 14
    error_message = "Admin password must be at least 14 characters."
  }
}

variable "nic_id" {
  description = "Network interface ID attached to the VM."
  type        = string
}

variable "enable_auto_shutdown" {
  description = "Whether to configure Azure auto-shutdown for the VM."
  type        = bool
  default     = true
}

variable "auto_shutdown_time" {
  description = "Daily auto-shutdown time in HHMM 24-hour format."
  type        = string
  default     = "1900"

  validation {
    condition     = can(regex("^([01][0-9]|2[0-3])[0-5][0-9]$", var.auto_shutdown_time))
    error_message = "Auto-shutdown time must use HHMM 24-hour format."
  }
}

variable "auto_shutdown_timezone" {
  description = "Timezone used by the auto-shutdown schedule."
  type        = string
  default     = "UTC"
}

variable "tags" {
  description = "Tags applied to the Windows VM and shutdown schedule."
  type        = map(string)
  default     = {}
}

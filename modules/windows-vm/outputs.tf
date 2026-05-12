output "id" {
  description = "Windows VM ID."
  value       = azurerm_windows_virtual_machine.this.id
}

output "name" {
  description = "Windows VM name."
  value       = azurerm_windows_virtual_machine.this.name
}

output "private_ip_address" {
  description = "Primary private IP address."
  value       = azurerm_windows_virtual_machine.this.private_ip_address
}

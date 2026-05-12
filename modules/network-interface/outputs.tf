output "id" {
  description = "Network interface ID."
  value       = azurerm_network_interface.this.id
}

output "name" {
  description = "Network interface name."
  value       = azurerm_network_interface.this.name
}

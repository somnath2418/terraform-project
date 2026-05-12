output "id" {
  description = "Public IP resource ID."
  value       = azurerm_public_ip.this.id
}

output "ip_address" {
  description = "Assigned public IP address. Dynamic public IPs may be empty until Azure allocates the address."
  value       = azurerm_public_ip.this.ip_address
}

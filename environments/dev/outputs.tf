output "resource_group_name" {
  description = "Dev resource group name."
  value       = module.resource_group.name
}

output "vm_name" {
  description = "Dev Windows VM name."
  value       = module.windows_vm.name
}

output "vm_private_ip_address" {
  description = "Dev Windows VM private IP address."
  value       = module.windows_vm.private_ip_address
}

output "vm_public_ip_address" {
  description = "Dev Windows VM public IP address."
  value       = module.public_ip.ip_address
}

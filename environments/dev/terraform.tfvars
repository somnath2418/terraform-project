location                  = "eastus"
vnet_address_space        = ["10.10.0.0/16"]
subnet_address_prefixes   = ["10.10.1.0/24"]
vm_size                   = "Standard_D2s_v3"
admin_username            = "tfadminuser"
rdp_source_address_prefix = "203.0.113.10/32"
enable_auto_shutdown      = true
auto_shutdown_time        = "1900"
auto_shutdown_timezone    = "UTC"

# Set the password through TF_VAR_admin_password, GitHub Actions secrets, or a secure local secret store.
# admin_password = "REPLACE_WITH_A_SECURE_PASSWORD"

tags = {
  Owner      = "platform-team"
  CostCenter = "it-dev"
}

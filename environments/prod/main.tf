locals {
  environment = "prod"
  workload    = "winvm"
  name_prefix = "${local.environment}-${local.workload}"

  common_tags = merge(var.tags, {
    Environment = local.environment
    Workload    = local.workload
    ManagedBy   = "Terraform"
  })
}

module "resource_group" {
  source = "../../modules/resource-group"

  name            = "${local.name_prefix}-rg"
  location        = var.location
  prevent_destroy = true
  tags            = local.common_tags
}

module "virtual_network" {
  source = "../../modules/virtual-network"

  name                = "${local.name_prefix}-vnet"
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  address_space       = var.vnet_address_space
  tags                = local.common_tags
}

module "subnet" {
  source = "../../modules/subnet"

  name                 = "${local.name_prefix}-snet"
  resource_group_name  = module.resource_group.name
  virtual_network_name = module.virtual_network.name
  address_prefixes     = var.subnet_address_prefixes
}

module "network_security_group" {
  source = "../../modules/network-security-group"

  name                      = "${local.name_prefix}-nsg"
  location                  = module.resource_group.location
  resource_group_name       = module.resource_group.name
  subnet_id                 = module.subnet.id
  rdp_source_address_prefix = var.rdp_source_address_prefix
  tags                      = local.common_tags
}

module "public_ip" {
  source = "../../modules/public-ip"

  name                = "${local.name_prefix}-pip"
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  tags                = local.common_tags
}

module "network_interface" {
  source = "../../modules/network-interface"

  name                = "${local.name_prefix}-nic"
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  subnet_id           = module.subnet.id
  public_ip_id        = module.public_ip.id
  tags                = local.common_tags

  depends_on = [
    module.network_security_group
  ]
}

module "windows_vm" {
  source = "../../modules/windows-vm"

  name                   = "${local.name_prefix}-vm"
  computer_name          = "prdwinvm01"
  location               = module.resource_group.location
  resource_group_name    = module.resource_group.name
  vm_size                = var.vm_size
  admin_username         = var.admin_username
  admin_password         = var.admin_password
  nic_id                 = module.network_interface.id
  enable_auto_shutdown   = var.enable_auto_shutdown
  auto_shutdown_time     = var.auto_shutdown_time
  auto_shutdown_timezone = var.auto_shutdown_timezone
  tags                   = local.common_tags
}

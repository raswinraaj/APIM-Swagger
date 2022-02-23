
locals {
  common_tags = merge(var.common_tags, {    
    "environment" = "dev"    
  })
}

resource "azurerm_resource_group" "main" {
  name = var.resourcegroup_name
  location = var.location
  tags = local.common_tags
}

module "appserviceplan" {
  source              = "./modules/appserviceplan"
  suffix              = var.suffix
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location  
  common_tags         = local.common_tags
}
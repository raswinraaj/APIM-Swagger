
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
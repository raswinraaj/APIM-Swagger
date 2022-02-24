
locals {
  common_tags = merge(var.common_tags, {
    "environment" = "dev"
  })
}

resource "azurerm_resource_group" "main" {
  name     = var.resourcegroup_name
  location = var.location
  tags     = local.common_tags
}

module "appserviceplan" {
  source              = "./modules/appserviceplan"
  suffix              = var.suffix
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  common_tags         = local.common_tags
}

module "appservice" {
  source                  = "./modules/webapp"
  suffix                  = var.suffix
  app_service_plan_id     = module.appserviceplan.app_service_plan_id
  resource_group_name     = azurerm_resource_group.main.name
  location                = azurerm_resource_group.main.location
  common_tags             = local.common_tags
  appname                 = "swagger-${var.suffix}"
  deployment_package_path = var.deployment_package_path
}

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

module "apim" {
  source                    = "./modules/apim"  
  suffix                    = var.suffix
  resource_group_name       = azurerm_resource_group.main.name
  location                  = var.location  
  common_tags               = local.common_tags
}

data "http" "swagger" {
  url = "https://${module.appservice.default_site_hostname}/swagger/v1/swagger.json"
  request_headers = {
    Accept = "application/json"
  }
}
# Create API
resource "azurerm_api_management_api" "swaggerdemoapi" {

  api_management_name = module.apim.apim_name
  display_name        = "Swagger Demo API"
  name                = "swagger-demo-api"
  path                = "demo"
  service_url         = "https://${module.appservice.default_site_hostname}/"
  revision            = "1"
  resource_group_name = azurerm_resource_group.main.name
  protocols = [
    "https"
  ]

  subscription_required = true
  import {
    content_format = "openapi+json"
    content_value  = data.http.swagger.body
  }
  subscription_key_parameter_names {
    header = "Ocp-Apim-Subscription-Key"
    query  = "subscription-key"
  }
}

resource "azurerm_api_management_product_api" "product_api_mapping" {  
  api_name            = azurerm_api_management_api.swaggerdemoapi.name
  product_id          = module.apim.demo_app_product_id
  api_management_name = module.apim.apim_name
  resource_group_name = azurerm_resource_group.main.name
}
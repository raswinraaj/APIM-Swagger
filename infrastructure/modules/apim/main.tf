resource "azurerm_api_management" "apimgmt" {
  name                = "apim-swagger-${var.suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  publisher_name      = "Test Publisher"
  publisher_email     = var.publisher_email
  sku_name            = "Developer_1"
  identity {
    type = "SystemAssigned"
  }
  tags                 = var.common_tags 
}

resource "azurerm_api_management_product" "demo_app_product" {
  api_management_name   = azurerm_api_management.apimgmt.name
  display_name          = "DemoApp"
  product_id            = "demo-app-${var.suffix}"
  published             = true
  resource_group_name   = azurerm_api_management.apimgmt.resource_group_name
  subscription_required = true
}

resource "azurerm_api_management_group" "demo_app_group" {
  name                = "demo-app-group"
  resource_group_name = azurerm_api_management.apimgmt.resource_group_name
  api_management_name = azurerm_api_management.apimgmt.name
  display_name        = "DemoApp"
  description         = "DemoApp"
}

resource "azurerm_api_management_product_group" "demo_app_product_group" {
  product_id          = "demo-app-${var.suffix}"
  group_name          = azurerm_api_management_group.demo_app_group.name
  api_management_name = azurerm_api_management.apimgmt.name
  resource_group_name = azurerm_api_management.apimgmt.resource_group_name
}


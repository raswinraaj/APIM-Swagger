resource "azurerm_app_service_plan" "main" {
  name                = "plan-app-${var.suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  kind                = var.appsvcplan_kind
  sku {
    tier     = var.appsvcplan_sku_tier
    size     = var.appsvcplan_sku_size
    capacity = var.appsvcplan_sku_capacity
  }
  tags = var.common_tags
}
output "apim_id" {
  value = azurerm_api_management.apimgmt.id
}

output "gateway_url" {
  value = azurerm_api_management.apimgmt.gateway_url
}

output "management_api_url" {
  value = azurerm_api_management.apimgmt.management_api_url
}

output "portal_url" {
  value = azurerm_api_management.apimgmt.portal_url
}

output "public_ip_addresses" {
  value = azurerm_api_management.apimgmt.public_ip_addresses
}

output "demo_app_product_id" {
  value = azurerm_api_management_product.demo_app_product.product_id
}

output "apim_name" {
  value = azurerm_api_management.apimgmt.name
}
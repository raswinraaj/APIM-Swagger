resource "random_id" "swagger_demo_app" {
  byte_length = 3
}

resource "azurerm_storage_account" "swagger_demo_app" {
  location                 = var.location
  resource_group_name      = var.resource_group_name
  name                     = "${var.suffix}webapp${random_id.swagger_demo_app.hex}"
  account_kind             = "Storage"
  account_replication_type = "LRS"
  account_tier             = "Standard"
  tags                     = var.common_tags
}

resource "azurerm_storage_blob" "package" {
  storage_account_name   = local.deployment_storage_account_name
  storage_container_name = local.deployment_storage_container_name
  name                   = "${var.suffix}-swagger-service-deployment-package-${filesha256(var.deployment_package_path)}.zip"
  type                   = "Block"
  source                 = var.deployment_package_path
}

locals {
  sas_start_time  = "2021-01-01T00:00:00Z"
  sas_expiry_date = timeadd(local.sas_start_time, "${100 * 365 * 24}h")
}

data "azurerm_storage_account_sas" "package" {
  connection_string = azurerm_storage_account.swagger_demo_app.primary_connection_string
  https_only        = true

  start  = formatdate("YYYY-MM-DD", local.sas_start_time)
  expiry = formatdate("YYYY-MM-DD", local.sas_expiry_date)

  permissions {
    read    = true
    add     = false
    create  = false
    delete  = false
    list    = false
    process = false
    update  = false
    write   = false
  }

  resource_types {
    object    = true
    container = false
    service   = false
  }

  services {
    blob  = true
    file  = false
    queue = false
    table = false
  }
}

resource "azurerm_app_service" "swagger_demo_app" {
  location            = var.location
  resource_group_name = var.resource_group_name
  app_service_plan_id = var.app_service_plan_id
  name                = "swagger-${var.suffix}"
  version             = "~3"
  tags                = var.common_tags


  storage_connection_string = azurerm_storage_account.swagger_demo_app.primary_connection_string

  app_settings = {
    dotnet_framework_version = "v4.0"
    http2_enabled            = true
    min_tls_version          = "1.2"
    WEBSITE_RUN_FROM_PACKAGE = "https://${azurerm_storage_blob.package.storage_account_name}.blob.core.windows.net/${azurerm_storage_blob.package.storage_container_name}/${azurerm_storage_blob.package.name}${data.azurerm_storage_account_sas.package.sas}"
  }

  site_config {
    use_32_bit_worker_process = false
    http2_enabled             = true
  }
}
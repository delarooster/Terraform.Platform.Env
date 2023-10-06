# Copyright (c) 2023 Mesh. All rights reserved.

#Storage account creation
resource "azurerm_storage_account" "adx-timeseries" {
  name                            = "${local.prefix_short}sa"
  resource_group_name             = data.azurerm_resource_group.rg.name
  location                        = var.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false
  enable_https_traffic_only       = true
}

#Application insights creation
resource "azurerm_application_insights" "adx-timeseries" {
  name                = "${local.prefix}ai"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
  application_type    = "web"
}

resource "azurerm_service_plan" "windows-adx" {
  name                = "${local.prefix}asp"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name

  os_type  = "Windows"
  sku_name = "F1"

  tags = {
    provisioned_by = "terraform"
  }
}

resource "azurerm_function_app" "adx-timeseries" {
  count                      = var.functionappcount
  name                       = "${local.prefix_short}fa${count.index}"
  location                   = var.location
  resource_group_name        = data.azurerm_resource_group.rg.name
  app_service_plan_id        = azurerm_service_plan.windows-adx.id
  storage_account_name       = azurerm_storage_account.adx-timeseries.name
  storage_account_access_key = azurerm_storage_account.adx-timeseries.primary_access_key
  https_only                 = true
  version                    = "~3"

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    APPINSIGHTS_CONNECTION_STRING              = azurerm_application_insights.adx-timeseries.connection_string
    APPINSIGHTS_INSTRUMENTATIONKEY             = azurerm_application_insights.adx-timeseries.instrumentation_key
    APPINSIGHTS_PROFILERFEATURE_VERSION        = "1.0.0"
    ApplicationInsightsAgent_EXTENSION_VERSION = "~2"
    DiagnosticServices_EXTENSION_VERSION       = "~3"
    FUNCTIONS_EXTENSION_VERSION                = "~3"
    FUNCTIONS_WORKER_RUNTIME                   = "dotnet"
    WEBSITE_ENABLE_SYNC_UPDATE_SITE            = true
    WEBSITE_RUN_FROM_PACKAGE                   = "1"
  }

  tags = {
    provisioned_by = "terraform"
  }
}
resource "azurerm_servicebus_namespace" "service_bus" {
  name                = "${local.prefix_short}sb"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
  sku                 = "Standard"
  zone_redundant      = false
}

resource "azurerm_servicebus_queue" "queue" {
  name         = "test-queue"
  namespace_id = azurerm_servicebus_namespace.service_bus.id

  enable_partitioning = true
}

resource "azurerm_servicebus_topic" "topic" {
  name         = "test-topic"
  namespace_id = azurerm_servicebus_namespace.service_bus.id

  enable_partitioning = true
}
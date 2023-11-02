# resource "azurerm_servicebus_namespace" "service_bus" {
#   name                = "${local.prefix_short}sb"
#   location            = var.location
#   resource_group_name = data.azurerm_resource_group.rg.name
#   sku                 = "Standard"
#   zone_redundant      = false
# }

data "azurerm_servicebus_namespace" "service_bus" {
  name                = "dvmeshsb"
  resource_group_name = "rg-mesh-dv"
}


resource "azurerm_servicebus_queue" "queue" {
  name         = "test-prod-queue"
  namespace_id = data.azurerm_servicebus_namespace.service_bus.id

  enable_partitioning = true
}

resource "azurerm_servicebus_topic" "topic" {
  name         = "test-prod-topic"
  namespace_id = data.azurerm_servicebus_namespace.service_bus.id

  enable_partitioning = true
}
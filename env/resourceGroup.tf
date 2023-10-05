# Copyright (c) 2023 Mesh. All rights reserved.

data "azurerm_resource_group" "rg" {
  name = "rg-${var.name}-${var.env}"
}
# Copyright (c) 2023 Mesh. All rights reserved.

output "resource_group_name" {
  value = data.azurerm_resource_group.rg.name
}
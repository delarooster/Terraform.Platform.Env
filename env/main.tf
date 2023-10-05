# Copyright (c) 2023 Mesh. All rights reserved.

locals {
  prefix       = "${var.env}${var.name}"
  prefix_lower = lower(local.prefix)
  prefix_short = replace(local.prefix_lower, "/[-_]/", "")
}

terraform {
  required_providers {
    azurerm = {
      version = "3.72.0"
    }
  }
  backend "azurerm" {
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}
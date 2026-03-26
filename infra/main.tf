# MLOps Infrastructure for Superstore Forecast Model
# Deploys only the Managed Online Endpoint into an EXISTING Azure ML Workspace.
# The workspace (and its storage account, key vault, ACR, App Insights)
# are assumed to already exist. No duplicate resources are created.

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.80.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = ">= 1.9.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azapi" {}

# Reference the EXISTING Azure ML Workspace (no new resources created)
data "azurerm_machine_learning_workspace" "existing" {
  name                = var.ml_workspace_name
  resource_group_name = var.resource_group_name
}

# Managed Online Endpoint for real-time inference
# The azurerm provider does not have a native resource for
# MachineLearningServices/workspaces/onlineEndpoints.
# Use the azapi provider to create the endpoint directly via ARM API.
resource "azapi_resource" "online_endpoint" {
  type      = "Microsoft.MachineLearningServices/workspaces/onlineEndpoints@2024-04-01"
  name      = var.endpoint_name
  parent_id = data.azurerm_machine_learning_workspace.existing.id
  location  = var.location

  tags = var.tags

  identity {
    type = "SystemAssigned"
  }

  body = {
    properties = {
      authMode = "Key"
    }
  }

  response_export_values = [
    "properties.scoringUri"
  ]
}

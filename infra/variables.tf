variable "ml_workspace_name" {
  description = "Name of your existing Azure ML workspace"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group containing the existing Azure ML workspace"
  type        = string
}

variable "location" {
  description = "Azure region (must match the existing workspace)"
  type        = string
  default     = "eastus2"
}

variable "endpoint_name" {
  description = "Name of the managed online endpoint to create"
  type        = string
  default     = "superstore-forecast-endpoint"
}

variable "tags" {
  description = "Tags applied to the endpoint"
  type        = map(string)
  default = {
    project     = "superstore-forecast"
    environment = "dev"
  }
}

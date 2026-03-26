output "ml_workspace_name" {
  description = "Name of the existing Azure ML workspace"
  value       = data.azurerm_machine_learning_workspace.existing.name
}

output "ml_workspace_id" {
  description = "Resource ID of the existing Azure ML workspace"
  value       = data.azurerm_machine_learning_workspace.existing.id
}

output "endpoint_name" {
  description = "Name of the managed online endpoint"
  value       = azapi_resource.online_endpoint.name
}

output "scoring_uri" {
  description = "Scoring URI of the managed online endpoint"
  value       = azapi_resource.online_endpoint.output.properties.scoringUri
}

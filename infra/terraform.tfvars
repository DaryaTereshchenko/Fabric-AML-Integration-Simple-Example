ml_workspace_name  = "<YOUR_EXISTING_ML_WORKSPACE_NAME>"
resource_group_name = "<YOUR_RESOURCE_GROUP_NAME>"
location           = "eastus2"
endpoint_name      = "superstore-forecast-endpoint"

tags = {
  project     = "superstore-forecast"
  environment = "dev"
}

using 'main.bicep'

param mlWorkspaceName = '<YOUR_EXISTING_ML_WORKSPACE_NAME>'
param location = 'eastus2'
param endpointName = 'superstore-forecast-endpoint'
param servicePrincipalObjectId = '<YOUR_SERVICE_PRINCIPAL_OBJECT_ID>'
param mlStorageAccountName = '<YOUR_ML_WORKSPACE_STORAGE_ACCOUNT_NAME>'
param tags = {
  project: 'superstore-forecast'
  environment: 'dev'
}

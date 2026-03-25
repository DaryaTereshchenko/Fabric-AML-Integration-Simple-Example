#!/bin/bash
# Assign Storage Blob Data Contributor role to the service principal
# Run this script once with a principal that has Owner or User Access Administrator privileges

set -e

# Parameters
RESOURCE_GROUP="${1:-}"
ML_WORKSPACE_NAME="${2:-}"
SERVICE_PRINCIPAL_OBJECT_ID="${3:-}"

if [ -z "$RESOURCE_GROUP" ] || [ -z "$ML_WORKSPACE_NAME" ] || [ -z "$SERVICE_PRINCIPAL_OBJECT_ID" ]; then
  echo "Usage: $0 <resource-group> <ml-workspace-name> <service-principal-object-id>"
  echo ""
  echo "Example:"
  echo "  $0 my-rg my-ml-workspace abc123-456-789"
  echo ""
  echo "To get the service principal object ID:"
  echo "  az ad sp show --id <CLIENT_ID> --query id -o tsv"
  exit 1
fi

echo "Fetching ML workspace storage account..."
STORAGE_ACCOUNT_ID=$(az ml workspace show \
  --name "$ML_WORKSPACE_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --query storageAccount -o tsv)

if [ -z "$STORAGE_ACCOUNT_ID" ]; then
  echo "ERROR: Could not retrieve storage account for workspace $ML_WORKSPACE_NAME"
  exit 1
fi

STORAGE_ACCOUNT_NAME=$(basename "$STORAGE_ACCOUNT_ID")
echo "Storage account: $STORAGE_ACCOUNT_NAME"

echo "Assigning Storage Blob Data Contributor role..."
az role assignment create \
  --assignee-object-id "$SERVICE_PRINCIPAL_OBJECT_ID" \
  --assignee-principal-type ServicePrincipal \
  --role "Storage Blob Data Contributor" \
  --scope "$STORAGE_ACCOUNT_ID"

echo "✓ Role assignment complete"

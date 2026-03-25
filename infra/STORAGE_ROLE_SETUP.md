# Storage Role Assignment for MLOps

## Problem
The service principal used for CI/CD needs **Storage Blob Data Contributor** access to the Azure ML workspace's backing storage account to upload model artifacts via MLflow.

## Solution: One-time Setup

Run this command **once** as a user with **Owner** or **User Access Administrator** role on the storage account:

```bash
# Get service principal object ID
SP_OBJECT_ID=$(az ad sp show --id <YOUR_CLIENT_ID> --query id -o tsv)

# Run the role assignment script
bash infra/assign-storage-role.sh \
  <RESOURCE_GROUP> \
  <ML_WORKSPACE_NAME> \
  "$SP_OBJECT_ID"
```

**Example:**
```bash
SP_OBJECT_ID=$(az ad sp show --id abc123-def-456 --query id -o tsv)

bash infra/assign-storage-role.sh \
  my-resource-group \
  my-ml-workspace \
  "$SP_OBJECT_ID"
```

## Alternative: Add to GitHub Actions

If your GitHub Actions service principal has permission to assign roles, add this step to your workflow **before** the `train` job:

```yaml
- name: Assign Storage Role (one-time)
  run: |
    SP_OBJECT_ID=$(az ad sp show --id ${{ secrets.CLIENT_ID }} --query id -o tsv)
    bash infra/assign-storage-role.sh \
      "${{ env.RESOURCE_GROUP }}" \
      "${{ env.ML_WORKSPACE }}" \
      "$SP_OBJECT_ID"
```

⚠️ This will fail if the GitHub Actions principal lacks `Microsoft.Authorization/roleAssignments/write` permissions.

## Verification

After running the script, verify the role assignment:

```bash
az role assignment list \
  --assignee <SERVICE_PRINCIPAL_OBJECT_ID> \
  --scope /subscriptions/<SUB_ID>/resourceGroups/<RG>/providers/Microsoft.Storage/storageAccounts/<STORAGE_ACCOUNT> \
  --query "[?roleDefinitionName=='Storage Blob Data Contributor']" -o table
```

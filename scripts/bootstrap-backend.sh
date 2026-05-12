#!/usr/bin/env bash
set -euo pipefail

LOCATION="${LOCATION:-eastus}"
RESOURCE_GROUP_NAME="${RESOURCE_GROUP_NAME:-rg-tfstate-shared}"
STORAGE_ACCOUNT_NAME="${STORAGE_ACCOUNT_NAME:-sttfstateexample001}"
CONTAINER_NAME="${CONTAINER_NAME:-tfstate}"

az group create \
  --name "${RESOURCE_GROUP_NAME}" \
  --location "${LOCATION}"

az storage account create \
  --name "${STORAGE_ACCOUNT_NAME}" \
  --resource-group "${RESOURCE_GROUP_NAME}" \
  --location "${LOCATION}" \
  --sku Standard_LRS \
  --kind StorageV2 \
  --https-only true \
  --min-tls-version TLS1_2 \
  --allow-blob-public-access false

ACCOUNT_KEY="$(az storage account keys list \
  --resource-group "${RESOURCE_GROUP_NAME}" \
  --account-name "${STORAGE_ACCOUNT_NAME}" \
  --query '[0].value' \
  --output tsv)"

az storage container create \
  --name "${CONTAINER_NAME}" \
  --account-name "${STORAGE_ACCOUNT_NAME}" \
  --account-key "${ACCOUNT_KEY}"

az storage account blob-service-properties update \
  --account-name "${STORAGE_ACCOUNT_NAME}" \
  --resource-group "${RESOURCE_GROUP_NAME}" \
  --enable-versioning true

echo "Backend storage account is ready."
echo "Update environments/*/backend.conf with:"
echo "resource_group_name  = \"${RESOURCE_GROUP_NAME}\""
echo "storage_account_name = \"${STORAGE_ACCOUNT_NAME}\""
echo "container_name       = \"${CONTAINER_NAME}\""

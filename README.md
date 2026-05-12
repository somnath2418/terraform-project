# Azure Windows VM Terraform Project

Production-grade Terraform project for deploying Azure Windows Server 2022 virtual machines into separate `dev` and `prod` environments using reusable modules, Azure Storage remote state, and GitHub Actions CI/CD.

Terraform is pinned to `1.15.2`, the latest stable release reported by the Terraform CLI at generation time. AzureRM is constrained to the current v4 provider line.

## Structure

```text
terraform-project/
├── modules/
│   ├── resource-group/
│   ├── virtual-network/
│   ├── subnet/
│   ├── network-security-group/
│   ├── public-ip/
│   ├── network-interface/
│   └── windows-vm/
├── environments/
│   ├── dev/
│   └── prod/
├── .github/workflows/
├── scripts/
├── README.md
├── .gitignore
└── versions.tf
```

## Resources

Each environment deploys:

- Resource group
- Virtual network
- Subnet
- Network security group with RDP rule
- Dynamic public IP
- Network interface
- Windows Server 2022 Datacenter virtual machine
- Premium SSD OS disk
- Boot diagnostics
- Auto-shutdown schedule

## Environments

| Environment | VM size | Address space | State key |
| --- | --- | --- | --- |
| dev | `Standard_B2s` | `10.10.0.0/16` | `dev/dev.terraform.tfstate` |
| prod | `Standard_D2s_v5` | `10.20.0.0/16` | `prod/prod.terraform.tfstate` |

## Backend Bootstrap

Create the Azure Storage backend before running Terraform:

```bash
az login
az account set --subscription "<subscription-id>"

export LOCATION="eastus"
export RESOURCE_GROUP_NAME="rg-tfstate-shared"
export STORAGE_ACCOUNT_NAME="sttfstateexample001"
export CONTAINER_NAME="tfstate"

./scripts/bootstrap-backend.sh
```

Equivalent Azure CLI commands:

```bash
az group create --name rg-tfstate-shared --location eastus

az storage account create \
  --name sttfstateexample001 \
  --resource-group rg-tfstate-shared \
  --location eastus \
  --sku Standard_LRS \
  --kind StorageV2 \
  --https-only true \
  --min-tls-version TLS1_2 \
  --allow-blob-public-access false

ACCOUNT_KEY="$(az storage account keys list \
  --resource-group rg-tfstate-shared \
  --account-name sttfstateexample001 \
  --query '[0].value' \
  --output tsv)"

az storage container create \
  --name tfstate \
  --account-name sttfstateexample001 \
  --account-key "${ACCOUNT_KEY}"

az storage account blob-service-properties update \
  --account-name sttfstateexample001 \
  --resource-group rg-tfstate-shared \
  --enable-versioning true
```

Update both `environments/dev/backend.conf` and `environments/prod/backend.conf` with your real backend resource names.

## Local Deployment

Authenticate with Azure:

```bash
az login
az account set --subscription "<subscription-id>"
```

Set the VM password securely. Terraform will read this as a sensitive variable:

```bash
export TF_VAR_admin_password="<secure-password>"
```

Run dev:

```bash
cd environments/dev
terraform init -backend-config=backend.conf
terraform fmt -recursive
terraform validate
terraform plan -input=false
terraform apply -input=false
```

Run prod:

```bash
cd environments/prod
terraform init -backend-config=backend.conf
terraform fmt -recursive
terraform validate
terraform plan -input=false
terraform apply -input=false
```

## GitHub Actions

Two workflows are included:

- `.github/workflows/terraform-dev.yml`
- `.github/workflows/terraform-prod.yml`

Pull requests to `main` run:

- Checkout
- Azure login
- Setup Terraform
- Terraform init
- Terraform format check
- Terraform validate
- Terraform plan

Pushes to `main` run the same stages and then apply.

Configure these GitHub repository secrets:

- `ARM_CLIENT_ID`
- `ARM_CLIENT_SECRET`
- `ARM_SUBSCRIPTION_ID`
- `ARM_TENANT_ID`
- `DEV_VM_ADMIN_PASSWORD`
- `PROD_VM_ADMIN_PASSWORD`

For production, protect the `prod` GitHub Environment with required reviewers before allowing apply.

## Service Principal

Create a service principal scoped to the target subscription or, preferably, to dedicated resource groups where possible:

```bash
az ad sp create-for-rbac \
  --name "sp-terraform-github-actions" \
  --role "Contributor" \
  --scopes "/subscriptions/<subscription-id>"
```

For least privilege, use narrower scopes and assign only the roles required for the backend and deployed resource groups. The backend storage account also needs state read/write access.

## Security Notes

- Do not commit real passwords or secrets.
- `admin_password` is marked sensitive.
- Use a trusted IP CIDR for `rdp_source_address_prefix`, especially in prod.
- Prefer GitHub Environment approvals for production applies.
- State files are ignored locally and stored remotely in Azure Storage.
- Commit `.terraform.lock.hcl` after the first successful init to pin provider selections.

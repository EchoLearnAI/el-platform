# el-platform-infra-alz

Azure Landing Zone platform — management group hierarchy, observability, hub-spoke connectivity, and identity. Phase 2 of the two-phase ALZ bootstrap.

See [CLAUDE.md](./CLAUDE.md) for full architecture context and constraints.

## Apply Order

Modules must run in this sequence — each depends on the previous:

```
1. management-groups  →  2. management  →  3. connectivity  →  4. identity
```

## First-Time Apply (manual)

Run once with `az login` before GitHub Actions takes over.

```bash
# Authenticate
az login

# 1. Management groups — import existing alz MG first
cd terraform/management-groups
terraform init
terraform import 'module.alz.azurerm_management_group.level_1["alz"]' \
  /providers/Microsoft.Management/managementGroups/alz
terraform apply -var-file="terraform.tfvars"

# 2. Management resources
cd ../management
terraform init
terraform apply -var-file="terraform.tfvars"

# 3. Connectivity (reads management state for Log Analytics ID)
cd ../connectivity
terraform init
terraform apply -var-file="terraform.tfvars"

# 4. Identity stub
cd ../identity
terraform init
terraform apply -var-file="terraform.tfvars"
```

## GitHub Actions (ongoing)

After the first-time apply, all changes run via GitHub Actions:

- **PR opened** → `plan.yml` runs `terraform plan` for all four modules
- **Merge to main** → `apply.yml` runs `terraform apply` in order, with a manual approval gate

Required secrets (already configured):
- `AZURE_CLIENT_ID`
- `AZURE_TENANT_ID`
- `AZURE_SUBSCRIPTION_ID` (management subscription)
- `AZURE_CONNECTIVITY_SUBSCRIPTION_ID`

## Destroy

Each module is independent. Destroy in reverse order:

```bash
cd terraform/identity    && terraform destroy -var-file="terraform.tfvars"
cd terraform/connectivity && terraform destroy -var-file="terraform.tfvars"
cd terraform/management  && terraform destroy -var-file="terraform.tfvars"
# management-groups last — alz MG has RetainOnDelete; remove from state only
cd terraform/management-groups && terraform state rm 'module.alz.azurerm_management_group.level_1["alz"]'
cd terraform/management-groups && terraform destroy -var-file="terraform.tfvars"
```

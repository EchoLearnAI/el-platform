# CLAUDE.md

This file provides guidance to Claude Code when working in this repository.

## Purpose

**Phase 2** of the two-phase ALZ platform bootstrap. Provisions the Azure Landing Zone using four independent Terraform root modules applied in order. Runs fully automated via GitHub Actions OIDC — no `az login` required.

## Architecture Context

See `el-docs-architecture` for the full design:
- `docs/superpowers/specs/2026-06-01-el-platform-infra-alz-design.md` — full design spec
- `docs/superpowers/specs/2026-05-26-alz-platform-design.md` — platform overview
- `decisions/ADR-001-two-phase-bootstrap.md` — why Phase 1 and Phase 2 are separate

## Subscriptions

| Name | ID | Used by |
|---|---|---|
| `el-platform-management` | `bb77225d-4563-43d4-b547-ec1feee0a21b` | management, identity, corp-prod |
| `el-platform-connectivity` | `dcb7471a-32ca-4589-821c-439b70aaa589` | connectivity |

## Repository Structure

```
terraform/
├── management-groups/    # ALZ MG hierarchy + policies (caf-enterprise-scale)
├── management/           # Log Analytics Workspace, Automation Account
├── connectivity/         # Hub VNet, Azure Firewall, Bastion
└── identity/             # Resource group stub
.github/
└── workflows/
    ├── plan.yml           # On PR — terraform plan all modules
    └── apply.yml          # On merge to main — terraform apply in order
```

## Remote State Backend

All modules share the same storage account (`stbootstrap3efe97de`), each in its own container:

| Module | Container |
|---|---|
| management-groups | `management-groups` |
| management | `management` |
| connectivity | `connectivity` |
| identity | `identity` |

State access uses OIDC (`use_oidc = true`) — no storage account key stored anywhere.

## Apply Order

Modules must be applied in this order — connectivity reads management state:

```
1. management-groups
2. management
3. connectivity
4. identity
```

## First-Time Apply

The `alz` management group was created in Phase 1 and must be imported before the first apply of management-groups:

```bash
cd terraform/management-groups
terraform init
terraform import 'module.alz.azurerm_management_group.level_1["alz"]' \
  /providers/Microsoft.Management/managementGroups/alz
terraform apply -var-file="terraform.tfvars"
```

## Key Constraints

- **Never store a client secret** — OIDC only, federated credentials from Phase 1.
- **Remote state uses OIDC** — `use_oidc = true` in all backend blocks; no storage key anywhere.
- **Apply order is mandatory** — connectivity reads management remote state; applying out of order will fail.
- **Import `alz` MG once** — only needed before the very first apply of management-groups.

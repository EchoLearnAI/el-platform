module "alz" {
  source  = "Azure/caf-enterprise-scale/azurerm"
  version = "~> 6.0"

  providers = {
    azurerm              = azurerm
    azurerm.connectivity = azurerm.connectivity
    azurerm.management   = azurerm.management
  }

  # The alz MG was created in Phase 1 — import it before first apply:
  #   terraform import 'module.alz.azurerm_management_group.level_1["alz"]' \
  #     /providers/Microsoft.Management/managementGroups/alz
  root_parent_id   = var.tenant_id
  root_id          = "alz"
  root_name        = "alz"
  default_location = var.location

  # Subscription placement
  subscription_id_management   = var.management_subscription_id
  subscription_id_connectivity = var.connectivity_subscription_id
  # Identity and corp-prod share the management subscription in this 2-sub setup
  subscription_id_identity = var.management_subscription_id

  # Let the individual modules manage their own resources
  deploy_management_resources   = false
  deploy_connectivity_resources = false
  deploy_identity_resources     = false

  # Deploy the core landing zone MG hierarchy and ALZ policies
  deploy_core_landing_zones = true
}

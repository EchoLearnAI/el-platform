resource "azurerm_resource_group" "management" {
  name     = "rg-management-prod"
  location = var.location
}

resource "azurerm_log_analytics_workspace" "management" {
  name                = "law-management-prod"
  location            = azurerm_resource_group.management.location
  resource_group_name = azurerm_resource_group.management.name
  sku                 = "PerGB2018"
  retention_in_days   = var.log_analytics_retention_days
}

resource "azurerm_automation_account" "management" {
  name                = "aa-management-prod"
  location            = azurerm_resource_group.management.location
  resource_group_name = azurerm_resource_group.management.name
  sku_name            = "Basic"
  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_log_analytics_linked_service" "automation" {
  resource_group_name = azurerm_resource_group.management.name
  workspace_id        = azurerm_log_analytics_workspace.management.id
  read_access_id      = azurerm_automation_account.management.id
}

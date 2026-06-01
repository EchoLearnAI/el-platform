# Reads Log Analytics Workspace ID from management module state
data "terraform_remote_state" "management" {
  backend = "azurerm"
  config = {
    storage_account_name = "stbootstrap3efe97de"
    container_name       = "management"
    key                  = "terraform.tfstate"
    use_oidc             = true
  }
}

resource "azurerm_resource_group" "connectivity" {
  name     = "rg-connectivity-prod"
  location = var.location
}

# ── Hub VNet ───────────────────────────────────────────────────────────────────

resource "azurerm_virtual_network" "hub" {
  name                = "vnet-hub-connectivity"
  location            = azurerm_resource_group.connectivity.location
  resource_group_name = azurerm_resource_group.connectivity.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "firewall" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.connectivity.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.0.1.0/26"]
}

resource "azurerm_subnet" "bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.connectivity.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.0.2.0/27"]
}

resource "azurerm_subnet" "gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.connectivity.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.0.3.0/27"]
}

# ── Azure Firewall ─────────────────────────────────────────────────────────────

resource "azurerm_public_ip" "firewall" {
  name                = "pip-fw-hub"
  location            = azurerm_resource_group.connectivity.location
  resource_group_name = azurerm_resource_group.connectivity.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall_policy" "hub" {
  name                = "fwpol-hub-connectivity"
  location            = azurerm_resource_group.connectivity.location
  resource_group_name = azurerm_resource_group.connectivity.name
  sku                 = "Standard"
}

resource "azurerm_firewall" "hub" {
  name                = "fw-hub-connectivity"
  location            = azurerm_resource_group.connectivity.location
  resource_group_name = azurerm_resource_group.connectivity.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"
  firewall_policy_id  = azurerm_firewall_policy.hub.id

  ip_configuration {
    name                 = "fw-ipconfig"
    subnet_id            = azurerm_subnet.firewall.id
    public_ip_address_id = azurerm_public_ip.firewall.id
  }
}

resource "azurerm_monitor_diagnostic_setting" "firewall" {
  name                       = "diag-fw-hub-to-law"
  target_resource_id         = azurerm_firewall.hub.id
  log_analytics_workspace_id = data.terraform_remote_state.management.outputs.log_analytics_workspace_resource_id

  enabled_log {
    category_group = "allLogs"
  }

  metric {
    category = "AllMetrics"
  }
}

# ── Azure Bastion ──────────────────────────────────────────────────────────────

resource "azurerm_public_ip" "bastion" {
  name                = "pip-bastion-hub"
  location            = azurerm_resource_group.connectivity.location
  resource_group_name = azurerm_resource_group.connectivity.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "hub" {
  name                = "bastion-hub-connectivity"
  location            = azurerm_resource_group.connectivity.location
  resource_group_name = azurerm_resource_group.connectivity.name
  sku                 = "Basic"

  ip_configuration {
    name                 = "bastion-ipconfig"
    subnet_id            = azurerm_subnet.bastion.id
    public_ip_address_id = azurerm_public_ip.bastion.id
  }
}

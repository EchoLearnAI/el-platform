output "hub_vnet_id" {
  description = "Hub VNet resource ID — used by spoke peering configurations"
  value       = azurerm_virtual_network.hub.id
}

output "firewall_private_ip" {
  description = "Azure Firewall private IP — used as UDR next hop in spoke subscriptions"
  value       = azurerm_firewall.hub.ip_configuration[0].private_ip_address
}

output "log_analytics_workspace_id" {
  description = "Log Analytics Workspace GUID — used for diagnostic settings"
  value       = azurerm_log_analytics_workspace.management.workspace_id
}

output "log_analytics_workspace_resource_id" {
  description = "Log Analytics Workspace ARM resource ID — used by Firewall diagnostic settings"
  value       = azurerm_log_analytics_workspace.management.id
}

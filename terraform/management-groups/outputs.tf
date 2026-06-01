output "root_management_group_id" {
  description = "The resource ID of the alz root management group"
  value       = module.alz.azurerm_management_group.level_1["alz"].id
}

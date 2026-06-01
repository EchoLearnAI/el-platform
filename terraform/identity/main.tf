# Stub — represents the identity subscription boundary.
# Domain controller resources would be added here in a production deployment.
resource "azurerm_resource_group" "identity" {
  name     = "rg-identity-prod"
  location = var.location
}

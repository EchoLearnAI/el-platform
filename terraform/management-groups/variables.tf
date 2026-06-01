variable "tenant_id" {
  type        = string
  description = "Azure AD tenant ID — used as root_parent_id for the MG hierarchy"
  sensitive   = true
}

variable "management_subscription_id" {
  type        = string
  description = "el-platform-management subscription ID"
  sensitive   = true
}

variable "connectivity_subscription_id" {
  type        = string
  description = "el-platform-connectivity subscription ID"
  sensitive   = true
}

variable "location" {
  type        = string
  description = "Default Azure region for policy remediation tasks"
  default     = "eastus2"
}

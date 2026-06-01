variable "subscription_id" {
  type        = string
  description = "el-platform-management subscription ID"
  sensitive   = true
}

variable "location" {
  type        = string
  description = "Azure region for management resources"
  default     = "eastus2"
}

variable "log_analytics_retention_days" {
  type        = number
  description = "Log Analytics Workspace retention in days"
  default     = 90
}

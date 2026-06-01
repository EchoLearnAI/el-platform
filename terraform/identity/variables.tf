variable "subscription_id" {
  type        = string
  description = "Subscription ID for identity resources (el-platform-management in 2-sub setup)"
  sensitive   = true
}

variable "location" {
  type        = string
  description = "Azure region for identity resources"
  default     = "eastus2"
}

variable "subscription_id" {
  type        = string
  description = "el-platform-connectivity subscription ID"
  sensitive   = true
}

variable "location" {
  type        = string
  description = "Azure region for connectivity resources"
  default     = "eastus2"
}

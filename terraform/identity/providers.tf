terraform {
  required_version = ">= 1.15.5"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  backend "azurerm" {
    storage_account_name = "stbootstrap3efe97de"
    container_name       = "identity"
    key                  = "terraform.tfstate"
    use_oidc             = true
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id
  features {}
}

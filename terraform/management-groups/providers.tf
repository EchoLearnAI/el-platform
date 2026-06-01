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
    container_name       = "management-groups"
    key                  = "terraform.tfstate"
    use_oidc             = true
  }
}

provider "azurerm" {
  subscription_id = var.management_subscription_id
  features {}
}

# The caf-enterprise-scale module requires these two aliased providers.
# Both point to the same subscription in our 2-subscription setup.
provider "azurerm" {
  alias           = "connectivity"
  subscription_id = var.connectivity_subscription_id
  features {}
}

provider "azurerm" {
  alias           = "management"
  subscription_id = var.management_subscription_id
  features {}
}

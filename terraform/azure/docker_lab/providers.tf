terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.90.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-terraformstatefiles"
    storage_account_name = "azterraformstatefiles"
    container_name       = "docker-lab"
    key                  = "docker-lab.tfstate"
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}


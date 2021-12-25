terraform {
  backend "azurerm" {}
}

provider "azurerm" {}

module "cluster_env" {
  source = "./modules/cluster-env"

  location = var.location
  environment = var.environment
  tags = {
    env = var.environment
    platform = "azure"
    script = "terraform"
  }
  token=var.token
  vnet=var.vnet
  pod_subnet=var.pod_subnet
  kub_subnet=var.kub_subnet
  bastion_subnet=var.bastion_subnet
  redis_subnet=var.redis_subnet
  resource_group=var.resource_group

  mastervm_size=var.mastervm_size
  mastervm_count=var.mastervm_count
  nodevm_size=var.nodevm_size
  nodevm_count=var.nodevm_count
  bastionvm_size=var.bastionvm_size
}
variable "project" {
  default     = "docker_lab"
  description = "Project name"
}

variable "rgname" {
  description = "Resource group name"
}

variable "location" {
  description = "Azure region to create resources"
}

variable "tfstate_storage" {
  description = "Azure storage account for tfstate"
}

variable "tfstate_container" {
  description = "Azure container account for tfstate"
}

variable "enable_docker_vm" {
  description = "If you want to deploy docker vm"
}

variable "docker_vm_count" {
  description = "How many docker vms to create"
  default     = "1"
}

variable "vmsize" {
  description = "VM size"
}

variable "vmsku" {
  description = "VM size"
}

variable "datadisksize" {
  description = "Datadisk ize in GB"
}

variable "username" {
  description = "VM sudo user"
}

variable "password" {
  default     = "T6P/~xCv5VSyTqp"
  description = "VM sudo user password"
  sensitive   = true
}
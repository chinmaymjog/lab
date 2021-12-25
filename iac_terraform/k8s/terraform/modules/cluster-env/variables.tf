variable "location" {
  type = string
  default = ""
}

variable "resource_group" {
  type = string
  default = ""
}

variable "terraform_stats" {
  type = string
  default = ""
}

variable "storage_account" {
  type = string
  default = ""
}

variable "container_name" {
  type = string
  default = ""
}

variable "source_image" {
  type = string
  default = ""
}

variable "environment" {
  type = string
  default = ""
}

variable "tags" {
  type = object({
    env = string
    platform = string
    script = string
  })
  default = {
    env = ""
    platform = ""
    script = ""
  }
}

variable "vnet" {
  type = string
  default = ""
}

variable "bastion_subnet" {
  type = string
  default = ""
}

variable "kub_subnet" {
  type = string
  default = ""
}

variable "redis_subnet" {
  type = string
  default = ""
}

variable "pod_subnet" {
  type = string
  default = ""
}


variable "bastionvm_size" {
  type = string
  default = ""
}

variable "mastervm_size" {
  type = string
  default = ""
}

variable "mastervm_count" {
  type = number
  default = "1"
}

variable "nodevm_size" {
  type = string
  default = ""
}

variable "nodevm_count" {
  type = number
  default = "2"
}

variable "token" {
  type = string
  default = ""
}

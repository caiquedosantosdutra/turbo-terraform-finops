terraform {
  required_providers {
    turbonomic = {
      source  = "IBM/turbonomic"
      version = "1.7.0"  # versão disponível no registry
    }
  }
}

provider "turbonomic" {
  hostname   = var.hostname
  username   = var.username
  password   = var.password
}

variable "hostname" {}
variable "username" {}
variable "password" {
  sensitive = true
}
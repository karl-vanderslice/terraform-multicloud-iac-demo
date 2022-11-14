# Pin versions of providers and Terraform to ensure syntax and feature compatibility.

provider "aws" {
  version = "= 2.54.0"
}

provider "azurerm" {
  version = "= 2.3.0"
  features {}
}

provider "google" {
  credentials = file(var.gcp_credentials)
  project     = var.gcp_project_id
  region      = var.gcp_region
  version     = "= 3.14.0"
}

provider "digitalocean" {
  version = "= 1.15.1"
}


provider "null" {
  version = "= 2.1.2"
}

provider "template" {
  version = "=2.1.2"
}

terraform {
  required_version = "= 0.12.24"
}

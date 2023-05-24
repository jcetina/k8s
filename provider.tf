terraform {
  cloud {
    organization = "jcetina"

    workspaces {
      name = "gh-jcetina-k8s"
    }
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.7.0"
    }
  }
}

provider "azurerm" {
  use_oidc = true
  features {}
}

terraform {
  required_version = ">=1.0"

  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "~>1.5"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.9.1"
    }
    azuredevops = {
      source = "microsoft/azuredevops"
      version = ">=0.1.0"
    }
  }
}

provider "azurerm" {
  features {}
}


module "azure-resources" {
  source              = "./modules/azure-resources"
  providers = {
    azurerm    = azurerm
  }
}

provider "azuredevops" {
  org_service_url       = var.AZDO_ORG_SERVICE_URL
  personal_access_token = var.AZDO_PERSONAL_ACCESS_TOKEN
}

module "devops-pipeline" {
  source              = "./modules/devops-pipeline"
  AZDO_ORG_SERVICE_URL        = var.AZDO_ORG_SERVICE_URL
  AZDO_PERSONAL_ACCESS_TOKEN  = var.AZDO_PERSONAL_ACCESS_TOKEN
  GITHUB_PERSONAL_ACCESS_TOKEN = var.GITHUB_PERSONAL_ACCESS_TOKEN
}

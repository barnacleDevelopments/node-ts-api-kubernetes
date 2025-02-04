terraform {
  cloud {
    organization = "devdeveloper"
    workspaces {
      name = "test-workplace"
    }
  }
}

# module "azure-resources" {
#   source              = "./modules/azure-resources"
#   providers = {
#     azurerm    = azurerm
#   }
# }

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

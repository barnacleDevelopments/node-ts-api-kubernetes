variable "github_pat" {
  type      = string
  sensitive = true
}

variable "devops_pat" {
  type      = string
  sensitive = true
}


module "azure-resources" {
  source              = "./modules/azure-resources"
  providers = {
    azurerm    = azurerm
  }
}

module "devops-pipeline" {
  source              = "./modules/devops-pipeline"
  devops_pat             = var.devops_pat
  github_pat             = var.github_pat
  depends_on = [module.azure-resources]
}

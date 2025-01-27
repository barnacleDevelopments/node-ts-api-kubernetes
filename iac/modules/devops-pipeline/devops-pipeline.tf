# Set variables
# export AZDO_PERSONAL_ACCESS_TOKEN=<Personal Access Token>
# export AZDO_ORG_SERVICE_URL=https://dev.azure.com/dev-developer
# Docs: https://registry.terraform.io/providers/ni/azuredevops/latest/docs
#
terraform {
  required_version = ">=1.0"

  required_providers {
    azuredevops = {
      source = "microsoft/azuredevops"
      version = ">=0.1.0"
    }
  }
}

variable "github_pat" {
  type      = string
  sensitive = true
}

variable "devops_pat" {
  type      = string
  sensitive = true
}

resource "azuredevops_project" "kubernetes_test" {
  name               = "Kubernetes Test"
  visibility         = "public"
  version_control    = "Git"
  work_item_template = "Agile"
}

resource "azuredevops_serviceendpoint_github" "github_connection" {
  project_id            = azuredevops_project.kubernetes_test.id
  service_endpoint_name = "GitHub Connection"
  auth_personal {
    personal_access_token = var.github_pat
  }
}

resource "azuredevops_serviceendpoint_dockerregistry" "docker_registry" {
  project_id            = azuredevops_project.kubernetes_test.id
  service_endpoint_name = "Container Registry"
  docker_registry       = "devdeveloperregistry.azurecr.io"
}

resource "azuredevops_build_definition" "node_ts_api_pipeline" {
  project_id = azuredevops_project.kubernetes_test.id
  name       = "Docker Build and Push"
  path       = "\\DockerPipelines"

  ci_trigger {
    use_yaml = true
  }

  repository {
    repo_type           = "GitHub"
    repo_id             = "barnacleDevelopments/node-ts-api-kubernetes"
    branch_name         = "main"
    service_connection_id = azuredevops_serviceendpoint_github.github_connection.id
    yml_path = "./Dockerfile.dev"
  }

}

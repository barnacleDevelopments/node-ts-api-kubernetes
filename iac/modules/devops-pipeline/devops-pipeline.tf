# Set variables to authenticate with azure devops
# export AZDO_PERSONAL_ACCESS_TOKEN=<Personal Access Token>
# export AZDO_ORG_SERVICE_URL=https://dev.azure.com/dev-developer
# Docs: https://registry.terraform.io/providers/ni/azuredevops/latest/docs
terraform {
  required_version = ">=1.0"

  required_providers {
    azuredevops = {
      source = "microsoft/azuredevops"
      version = ">=0.1.0"
    }
  }
}

provider "azuredevops" {
  org_service_url       = var.AZDO_ORG_SERVICE_URL
  personal_access_token = var.AZDO_PERSONAL_ACCESS_TOKEN
}

resource "azuredevops_project" "kubernetes_test" {
  name               = "KubernetesTraining"
  visibility         = "private"
}

resource "azuredevops_serviceendpoint_github" "github_connection" {
  project_id            = azuredevops_project.kubernetes_test.id
  service_endpoint_name = "GitHub Connection"
  auth_personal {
    personal_access_token = var.GITHUB_PERSONAL_ACCESS_TOKEN
  }
}

resource "azuredevops_serviceendpoint_dockerregistry" "docker_registry" {
  project_id            = azuredevops_project.kubernetes_test.id
  service_endpoint_name = "Container Registry"
  docker_registry       = "devdeveloperregistry.azurecr.io"
}

resource "azuredevops_variable_group" "build_variables" {
  project_id   = azuredevops_project.docker_registry.id
  name         = "Example Pipeline Variables"
  description  = "Managed by Terraform"
  allow_access = true

  variable {
    name  = "imageRepository"
    value = "node-ts-api"
  }

  variable {
    name  = "containerRegistry"
    value = "devdeveloperregistry.azurecr.io"
  }

  variable {
    name  = "dockerfilePath"
    value = "$(Build.SourcesDirectory)/Dockerfile.dev"
  }

  variable {
    name  = "tag"
    value = "$(Build.BuildId)"
  }

  variable {
    name  = "vmImageName"
    value = "Personal Laptop"
  }
}

resource "azuredevops_build_definition" "node_ts_api_pipeline" {
  project_id = azuredevops_project.kubernetes_test.id
  name       = "Docker Build and Push"
  path       = "\\DockerPipelines"

  ci_trigger {
    use_yaml = true
  }

  variable_groups = [
    azuredevops_variable_group.build_variables.id
  ]

  repository {
    repo_type           = "GitHub"
    repo_id             = "barnacleDevelopments/node-ts-api-kubernetes"
    branch_name         = "main"
    service_connection_id = azuredevops_serviceendpoint_github.github_connection.id
    yml_path    = "azure-pipelines.yml"
  }
}

# Docs: https://registry.terraform.io/providers/ni/azuredevops/latest/docs

terraform {
  required_providers {
    azuredevops = {
      source = "microsoft/azuredevops"
      version = ">=0.1.0"
    }
  }
}

variable "github_pat_key" {
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
    personal_access_token = var.github_pat_key
  }
}

resource "azuredevops_variable_group" "variable_group" {
  project_id   = azuredevops_project.kubernetes_test.id
  name         = "Kubernetes Test Environment Variables"
  description  = "Kubernetes test variable group."
  allow_access = true

  variable {
    name  = "FOO"
    value = "BAR"
  }
}

resource "azuredevops_serviceendpoint_dockerregistry" "docker_registry" {
  project_id            = azuredevops_project.kubernetes_test.id
  service_endpoint_name = "Container Registry"
  docker_registry       = "devdeveloperregistry.azurecr.io"
  docker_email          = "email@example.com"
  docker_username       = "your-username"
  docker_password       = "your-password"
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
    repo_id             = "barnacleDevelopments/node-ts-api"
    branch_name         = "main"
    service_connection_id = azuredevops_serviceendpoint_github.github_connection.id
  }

  yaml_path = "../Dockerfile.dev"
}

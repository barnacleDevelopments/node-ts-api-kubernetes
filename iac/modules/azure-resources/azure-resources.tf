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
  }
}

resource "azurerm_resource_group" "rg" {
  name     = "KubernetesTest"
  location = var.location
}

# Container Registry
resource "azurerm_container_registry" "acr" {
  name                = var.container_registry_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = true

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "dev"
  }
}

output "azurerm_container_registry_admin_username" {
  value = azurerm_container_registry.acr.admin_username
}

output "azurerm_container_registry_admin_password" {
  value = azurerm_container_registry.acr.admin_password
}
# Kubernetes Cluster
resource "azurerm_kubernetes_cluster" "k8s" {
  name                = var.azurerm_kubernetes_cluster_dns_name
  location            = "canadacentral"
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = var.azurerm_kubernetes_cluster_dns_prefix

  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name       = "agentpool"
    vm_size    = "Standard_A2_v2"
    node_count = var.node_count
  }

  tags = {
    Environment = "dev"
  }
}

resource "azurerm_storage_account" "sa" {
  name                     = "devdeveloperstorage"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    Environment = "dev"
  }
}

variable "resource_group_location" {
  type        = string
  default     = "eastus"
  description = "Location of the resource group."
}

variable "resource_group_name_prefix" {
  type        = string
  default     = "rg"
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}

variable "node_count" {
  type        = number
  description = "The initial quantity of nodes for the node pool."
  default     = 1
}

variable "msi_id" {
  type        = string
  description = "The Managed Service Identity ID. Set this value if you're running this example using Managed Identity as the authentication method."
  default     = null
}

variable "username" {
  type        = string
  description = "The admin username for the new cluster."
  default     = "azureadmin"
}

variable "location" {
  default     = "canadaeast"
  description = "Azure region where resources will be deployed."
}

variable "container_registry_name" {
  description = "The name of the Azure Container Registry."
  default     = "devdeveloperregistry"
}

variable "ssh_key_name" {
  description = "The name of the ssh_key_name."
  default     = "devdeveloper-ssh-key"
}

variable "azurerm_kubernetes_cluster_dns_name" {
  description = "The name of the cluster_dns_name."
  default     = "devdeveloper-aks-cluster"
}

variable "azurerm_kubernetes_cluster_dns_prefix" {
  description = "The name of the cluster_dns_prefi."
  default     = "cluster"
}

# Reference existing ACR
data "azurerm_container_registry" "acr" {
  name                = "devdeveloperregistry"
  resource_group_name = "devdeveloper-resource-group"  # Specify the correct resource group name
}

# Role assignment for AcrPull
resource "azurerm_role_assignment" "acr_pull" {
  name                 = uuid()
  scope                = data.azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = "0cd66b21-9bd9-47aa-a93a-dcf674dc12dd"  # Service Principal ID
  principal_type       = "ServicePrincipal"
}

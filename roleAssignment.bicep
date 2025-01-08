// Reference existing ACR
resource acr 'Microsoft.ContainerRegistry/registries@2023-01-01' existing = {
  name: 'devdeveloperregistry'
}

// Role assignment for AcrPull
resource roleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(acr.id, 'AcrPull', '0cd66b21-9bd9-47aa-a93a-dcf674dc12dd')
  scope: acr
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7f951dda-4ed3-4680-a7ca-43fe172d538d') // AcrPull role ID
    principalId: '0cd66b21-9bd9-47aa-a93a-dcf674dc12dd'
    principalType: 'ServicePrincipal'
  }
}

@description('The AKS principal ID')
param aksPrincipalId string

// Declare the existing ACR resource
resource acr 'Microsoft.ContainerRegistry/registries@2022-09-01' existing = {
  name: 'devdeveloperregistry'
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(acrId, aksPrincipalId, 'acrpull')
  scope: acr
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7f951dda-4ed3-4680-a7ca-43fe172d538d') // AcrPull role
    principalId: aksPrincipalId
  }
}

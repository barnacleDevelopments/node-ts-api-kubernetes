// General
param location string = resourceGroup().location
param resourceGroupName string = resourceGroup().name
param subscriptionId string = subscription().subscriptionId

// Kubernetes Cluster
param clusterName string = 'devdeveloper-aks-cluster'
param nodeSize string = 'Standard_A2_v2'
param nodeCount int = 1
param k8sVersion string = ''

// SQL SERVER + DB
param sqlServerName string = 'devdeveloper-sql-server'
param sqlDBName string = 'devdeveloper-sql-db'

// Storage Account
param storageAccountName string = 'devdevelopersa'

// Container Registry
param containerRegistryName string = 'devdeveloperregistry'

// Reference: https://learn.microsoft.com/en-us/azure/templates/microsoft.containerregistry/registries?pivots=deployment-language-bicep
resource containerRegistry 'Microsoft.ContainerRegistry/registries@2022-12-01' = {
  name: containerRegistryName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: false
  }
}

// Template Reference: https://learn.microsoft.com/en-us/azure/templates/microsoft.containerservice/managedclusters?pivots=deployment-language-bicep
// Manage Node Pools Reference: https://learn.microsoft.com/en-us/azure/aks/use-system-pools?tabs=azure-cli
resource devDeveloperCluster 'Microsoft.ContainerService/managedClusters@2024-09-01' = {
  location: location
  name: clusterName
  sku: {
    name: 'Base'
    tier: 'Free'
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    agentPoolProfiles: [
      {
        count: nodeCount
        name: 'nodepool1'
        osDiskSizeGB: 30
        osType: 'Linux'
        vmSize: nodeSize
        mode: 'System'
      }
    ]
    dnsPrefix: 'minimalaks'
  }
}

resource aksToAcrRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(devDeveloperCluster.identity.principalId, containerRegistry.id, 'acrpull')
  scope: containerRegistry
  dependsOn: [
    devDeveloperCluster
    containerRegistry
  ]
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7f951dda-4ed3-4680-a7ca-43fe172d538d') // AcrPull role ID
    principalId: devDeveloperCluster.identity.principalId
  }
}

// Reference: https://learn.microsoft.com/en-us/azure/templates/microsoft.sql/servers?pivots=deployment-language-bicep
resource devDeveloperSqlServer 'Microsoft.Sql/servers@2022-05-01-preview' = {
  name: sqlServerName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    minimalTlsVersion: '1.2'
    publicNetworkAccess: 'Disabled'
  }
}

// Reference: https://learn.microsoft.com/en-us/azure/templates/microsoft.sql/servers/databases?pivots=deployment-language-bicep
resource sqlDB 'Microsoft.Sql/servers/databases@2022-05-01-preview' = {
  parent: devDeveloperSqlServer
  name: sqlDBName
  location: location
  sku: {
    name: 'Basic'
    tier: 'Basic'
  }
}

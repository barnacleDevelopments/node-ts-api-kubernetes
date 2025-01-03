// General
param location string = resourceGroup().location

// Kubernetes Cluster
param clusterName string = 'devdeveloper-aks-cluster'
param nodeSize string = 'Standard_A2_v2'
param nodeCount int = 1

// SQL SERVER + DB
param sqlServerName string = 'devdeveloper-sql-server'
param sqlDBName string = 'devdeveloper-sql-db'

// Container Registry
param containerRegistryName string = 'devdeveloperregistry'

// Reference: https://learn.microsoft.com/en-us/azure/templates/microsoft.containerregistry/registries?pivots=deployment-language-bicep
resource devDeveloperContainerRegistry 'Microsoft.ContainerRegistry/registries@2022-12-01' = {
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

output aksPrincipalId string = devDeveloperCluster.identity.principalId

param location string
param subnetId string
param suffix string
param privateDnsZoneGroupIds array

var tag = {
  description: 'AI Foundry'
}

module storage 'br/public:avm/res/storage/storage-account:0.18.2' = {
  name: 'storagefoundry'
  params: {
    name: 'strf${suffix}'
    location: location
    publicNetworkAccess: 'Disabled'
    tags: tag
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow'
    }
    privateEndpoints: [
      {
        service: 'blob'
        subnetResourceId: subnetId
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: privateDnsZoneGroupIds[0]
            }
          ]
        }
      }
      {
        service: 'file'
        subnetResourceId: subnetId
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: privateDnsZoneGroupIds[1]
            }
          ]
        }
      }
    ]
  }
}

module keyvault 'br/public:avm/res/key-vault/vault:0.12.1' = {
  name: 'keyvaultregistry'
  params: {
    name: 'vault-ai-${suffix}'
    location: location
    tags: tag
    publicNetworkAccess: 'Disabled'
    enableRbacAuthorization: true
    enablePurgeProtection: false
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow'
    }
    privateEndpoints: [
      {
        service: 'vault'
        subnetResourceId: subnetId
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: privateDnsZoneGroupIds[2]
            }
          ]
        }
      }
    ]
  }
}

module containerRegistry 'br/public:avm/res/container-registry/registry:0.9.1' = {
  name: 'foundryregistry'
  params: {
    name: 'acrai${suffix}'
    location: location
    tags: tag
    publicNetworkAccess: 'Disabled'
    acrAdminUserEnabled: false
    networkRuleBypassOptions: 'AzureServices'
    zoneRedundancy: 'Disabled'
    privateEndpoints: [
      {
        subnetResourceId: subnetId
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: privateDnsZoneGroupIds[3]
            }
          ]
        }
      }
    ]
  }
}

module loganalytics 'br/public:avm/res/operational-insights/workspace:0.11.1' = {
  name: 'loganalyticsfoundry'
  params: {
    name: 'log-ai-${suffix}'
    location: location
    tags: tag
  }
}

module appinsights 'br/public:avm/res/insights/component:0.6.0' = {
  name: 'appinsightsfoundry'
  params: {
    name: 'app-ai-${suffix}'
    workspaceResourceId: loganalytics.outputs.resourceId
    tags: tag
    location: location
  }
}

output storageResourceId string = storage.outputs.resourceId
output keyvaultResourceId string = keyvault.outputs.resourceId
output containerRegistryResourceId string = containerRegistry.outputs.resourceId
output appInsightResourceId string = appinsights.outputs.resourceId

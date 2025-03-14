param location string
param suffix string
param subnetResourceId string
param privateDnsZoneResourceId string

// The latest version cannot allow ByPass Azure, version 0.7.2 seems to work
module search 'br/public:avm/res/search/search-service:0.7.2' = {
  name: 'searchfoundry'
  params: {
    name: 'search-${suffix}'
    disableLocalAuth: true
    location: location
    managedIdentities: {
      systemAssigned: true
    }
    publicNetworkAccess: 'Disabled'
    partitionCount: 1
    replicaCount: 1
    sku: 'standard'
    networkRuleSet: {
      ipRules: []
      bypass: 'AzureServices'
    }
    privateEndpoints: [
      {
        subnetResourceId: subnetResourceId
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: privateDnsZoneResourceId
            }
          ]
        }
      }
    ]
  }
}

output searchResourceName string = search.outputs.name
output searchResourceId string = search.outputs.resourceId

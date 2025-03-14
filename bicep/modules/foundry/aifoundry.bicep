param location string
param suffix string
param subnetResourceId string
param privateDnsZoneGroupIds array

module dependencies 'dependences.bicep' = {
  name: 'aifoundrydependencies'
  params: {
    location: location
    subnetId: subnetResourceId
    suffix: suffix
    privateDnsZoneGroupIds: privateDnsZoneGroupIds
  }
}

module hub 'br/public:avm/res/machine-learning-services/workspace:0.11.0' = {
  name: 'hub'
  params: {
    name: 'hub-${suffix}'
    description: 'Hub Contoso'
    sku: 'Basic'
    kind: 'Hub'
    managedIdentities: {
      systemAssigned: true
    }
    associatedStorageAccountResourceId: dependencies.outputs.storageResourceId
    associatedKeyVaultResourceId: dependencies.outputs.keyvaultResourceId
    associatedApplicationInsightsResourceId: dependencies.outputs.appInsightResourceId
    associatedContainerRegistryResourceId: dependencies.outputs.containerRegistryResourceId
    publicNetworkAccess: 'Disabled'
    privateEndpoints: [
      {
        subnetResourceId: subnetResourceId
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: privateDnsZoneGroupIds[3]
            }
          ]
        }
      }
    ]
    serverlessComputeSettings: null
    systemDatastoresAuthMode: 'Identity'
    managedNetworkSettings: {
      isolationMode: 'AllowOnlyApprovedOutbound'
    }
  }
}

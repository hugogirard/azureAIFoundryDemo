param location string
param suffix string
param subnetResourceId string
param privateDnsZoneGroupIds array
param openAiResourceId string
param openaiEndpoint string
param aiSearchResourceId string
param aiSearchEndpoint string

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
    connections: [
      {
        name: 'openai'
        target: openaiEndpoint
        category: 'AzureOpenAI'
        connectionProperties: {
          authType: 'AAD'
        }
        isSharedToAll: true
        metadata: {
          ApiType: 'Azure'
          ResourceId: openAiResourceId
        }
      }
      {
        name: 'aisearch'
        target: aiSearchEndpoint
        category: 'CognitiveSearch'
        connectionProperties: {
          authType: 'AAD'
        }
        isSharedToAll: true
        metadata: {
          ApiType: 'Azure'
          ResourceId: aiSearchResourceId
        }
      }
    ]
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

output storageResourceId string = dependencies.outputs.storageResourceId
output storageResourceName string = dependencies.outputs.storageResourceName
output hubResourceId string = hub.outputs.resourceId

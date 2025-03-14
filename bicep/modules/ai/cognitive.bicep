param location string
param resourceName string
@allowed([
  'OpenAI'
  'AIServices'
])
param kind string
param subnetResourceId string
param privateDnsZoneResourceId string

module cognitive 'br/public:avm/res/cognitive-services/account:0.10.1' = {
  name: 'dep${resourceName}'
  params: {
    name: resourceName
    kind: kind
    location: location
    publicNetworkAccess: 'Disabled'
    customSubDomainName: resourceName
    managedIdentities: {
      systemAssigned: true
    }
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow'
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

output cognitiveResourceName string = cognitive.outputs.name
output cognitiveResourceId string = cognitive.outputs.resourceId
output cognitiveEndpoint string = cognitive.outputs.endpoint
// This won't be null be to avoid the GH Action to throw an error
output systemAssignedMIPrincipalId string = cognitive.outputs.?systemAssignedMIPrincipalId ?? ''

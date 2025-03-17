param vnetResourceId string
param virtualMachineResourceName string
param virtualMachineNicResourceName string

var privateDNSZones = [
  'privatelink.file.${environment().suffixes.storage}'
  'privatelink.blob.${environment().suffixes.storage}'
  'privatelink.vaultcore.azure.net'
  'privatelink.azurecr.io'
  'privatelink.api.azureml.ms'
  'privatelink.notebooks.azure.net'
  'privatelink.openai.azure.com'
  'privatelink.search.windows.net'
]

resource networkInterface 'Microsoft.Network/networkInterfaces@2021-02-01' existing = {
  name: virtualMachineNicResourceName
}

var privateIPJumpbox = networkInterface.properties.ipConfigurations[0].properties.privateIPAddress

module privateDnsZones 'br/public:avm/res/network/private-dns-zone:0.7.0' = [
  for dnsZone in privateDNSZones: {
    name: dnsZone
    params: {
      name: dnsZone
      virtualNetworkLinks: [
        {
          virtualNetworkResourceId: vnetResourceId
        }
      ]
      a: [
        {
          name: virtualMachineResourceName
          aRecords: [
            {
              ipv4Address: privateIPJumpbox
            }
          ]
          ttl: 10
        }
      ]
    }
  }
]

output privateDnsZoneResourceIds array = [
  for i in range(0, length(privateDNSZones)): privateDnsZones[i].outputs.resourceId
]

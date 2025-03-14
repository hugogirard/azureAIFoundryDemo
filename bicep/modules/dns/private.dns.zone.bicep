param vnetResourceId string

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
    }
  }
]

// module privateDnsBlob 'br/public:avm/res/network/private-dns-zone:0.7.0' = {
//   name: 'privateDnsBlob'
//   params: {
//     name: 'privatelink.blob.${environment().suffixes.storage}'
//     virtualNetworkLinks: [
//       {
//         virtualNetworkResourceId: vnetResourceId
//       }
//     ]
//   }
// }

// module privateDnsFile 'br/public:avm/res/network/private-dns-zone:0.7.0' = {
//   name: 'privateDnsFile'
//   params: {
//     name: 'privatelink.file.${environment().suffixes.storage}'
//     virtualNetworkLinks: [
//       {
//         virtualNetworkResourceId: vnetResourceId
//       }
//     ]
//   }
// }

output privateDnsZoneResourceIds array = [
  for i in range(0, length(privateDNSZones)): privateDnsZones[i].outputs.resourceId
]

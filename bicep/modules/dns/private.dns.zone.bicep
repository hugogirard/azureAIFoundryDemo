param vnetResourceId string

module privateDnsBlob 'br/public:avm/res/network/private-dns-zone:0.7.0' = {
  name: 'privateDnsBlob'
  params: {
    name: 'privatelink.blob.${environment().suffixes.storage}'
    virtualNetworkLinks: [
      {
        virtualNetworkResourceId: vnetResourceId
      }
    ]
  }
}

module privateDnsFile 'br/public:avm/res/network/private-dns-zone:0.7.0' = {
  name: 'privateDnsFile'
  params: {
    name: 'privatelink.file.${environment().suffixes.storage}'
    virtualNetworkLinks: [
      {
        virtualNetworkResourceId: vnetResourceId
      }
    ]
  }
}

output privateDnsBlobResourceId string = privateDnsBlob.outputs.resourceId
output privateDnsFileResourceId string = privateDnsFile.outputs.resourceId

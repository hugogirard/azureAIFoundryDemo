module privateDnsBlob 'br/public:avm/res/network/private-dns-zone:0.7.0' = {
  name: 'privateDnsBlob'
  params: {
    name: 'privatelink.blob.${environment().suffixes.storage}'
  }
}

module privateDnsFile 'br/public:avm/res/network/private-dns-zone:0.7.0' = {
  name: 'privateDnsFile'
  params: {
    name: 'privatelink.file.${environment().suffixes.storage}'
  }
}

output privateDnsBlobResourceId string = privateDnsBlob.outputs.resourceId
output privateDnsFileResourceId string = privateDnsFile.outputs.resourceId

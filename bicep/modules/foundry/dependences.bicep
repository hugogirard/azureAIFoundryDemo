param location string
param subnetId string
param suffix string

module storage 'br/public:avm/res/storage/storage-account:0.18.2' = {
  name: 'storagefoundry'
  params: {
    name: 'strf${suffix}'
    location: location
    publicNetworkAccess: 'Disabled'
    privateEndpoints: [
      {
        service: 'blob'
        subnetResourceId: subnetId
        // privateDnsZoneGroup: {
        //   privateDnsZoneGroupConfigs: {
        //     privateDnsZoneResourceId: 'tete'
        //   }
        // }
      }
      {
        service: 'file'
        subnetResourceId: subnetId
      }
    ]
  }
}

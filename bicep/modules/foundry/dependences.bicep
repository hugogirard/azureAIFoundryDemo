param location string
param subnetId string
param suffix string
param privateDnsZoneGroupIds array

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

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
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow'
    }
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

module keyvault 'br/public:avm/res/key-vault/vault:0.12.1' = {
  name: 'keyvault'
  params: {
    name: 'vault-ai-${suffix}'
    publicNetworkAccess: 'Disabled'
    enableRbacAuthorization: true
    enablePurgeProtection: false
    enableSoftDelete: false
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow'
    }
    privateEndpoints: [
      {
        service: 'vault'
        subnetResourceId: subnetId
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: privateDnsZoneGroupIds[2]
            }
          ]
        }
      }
    ]
  }
}

param location string

param vnetAddressPrefix string

param subnetPeAddressPrefix string
param subnetJumpboxAddressPrefix string

module nsgpe 'br/public:avm/res/network/network-security-group:0.5.0' = {
  name: 'nsgpe'
  params: {
    name: 'nsg-pe'
  }
}

module nsgjumpbox 'br/public:avm/res/network/network-security-group:0.5.0' = {
  name: 'nsgjumpbox'
  params: {
    name: 'nsg-jumpbox'
  }
}

module vnet 'br/public:avm/res/network/virtual-network:0.5.4' = {
  name: 'vnetfoundry'
  params: {
    name: 'vnetfoundry'
    location: location
    addressPrefixes: [
      vnetAddressPrefix
    ]
    subnets: [
      {
        name: 'snet-pe'
        addressPrefix: subnetPeAddressPrefix
        networkSecurityGroupResourceId: nsgpe.outputs.resourceId
      }
      {
        name: 'snet-jumpbox'
        addressPrefix: subnetJumpboxAddressPrefix
        networkSecurityGroupResourceId: nsgjumpbox.outputs.resourceId
      }
    ]
  }
}

output subnetResourceIds array = vnet.outputs.subnetResourceIds
output resourceId string = vnet.outputs.resourceId

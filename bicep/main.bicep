@description('The location where the resources will be created')
@allowed([
  'canadaeast'
])
param location string

@description('The address prefix of the virtual network')
param vnetAddressPrefix string

@description('The address prefix subnet private endpoint')
param subnetPeAddressPrefix string

@description('The address prefix subnet for the jumpbox')
param subnetJumpboxAddressPrefix string

/*  Variables */
//var suffix = uniqueString(resourceGroup().id)

/* Virtual network */

module vnet 'modules/network/vnet.bicep' = {
  name: 'vnet'
  params: {
    location: location
    subnetJumpboxAddressPrefix: subnetJumpboxAddressPrefix
    subnetPeAddressPrefix: subnetPeAddressPrefix
    vnetAddressPrefix: vnetAddressPrefix
  }
}

/* Private DNS Zones */

module privateDnsZones 'modules/dns/private.dns.zone.bicep' = {
  name: 'privateDnsZones'
}

/* AI Foundry */

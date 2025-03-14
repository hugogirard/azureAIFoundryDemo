targetScope = 'subscription'

@description('The name of the resource group where the resources will be saved')
param resourceGroupName string

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
var suffix = uniqueString(rg.id)

/*  Create resource group */
resource rg 'Microsoft.Resources/resourceGroups@2024-11-01' = {
  name: resourceGroupName
  location: location
}

/* Virtual network */

module vnet 'modules/network/vnet.bicep' = {
  name: 'vnet'
  scope: rg
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
  scope: rg
  params: {
    vnetResourceId: vnet.outputs.resourceId
  }
}

/* AI Foundry */

module aifoundry 'modules/foundry/aifoundry.bicep' = {
  scope: rg
  name: 'aifoundry'
  params: {
    location: location
    subnetResourceId: vnet.outputs.subnetResourceIds[0]
    suffix: suffix
    privateDnsZoneGroupIds: privateDnsZones.outputs.privateDnsZoneResourceId
  }
}

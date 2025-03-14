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

/* AI Services */

module openai 'modules/ai/cognitive.bicep' = {
  scope: rg
  name: 'openai'
  params: {
    location: location
    kind: 'OpenAI'
    privateDnsZoneResourceId: privateDnsZones.outputs.privateDnsZoneResourceIds[6]
    resourceName: 'openai-${suffix}'
    subnetResourceId: vnet.outputs.subnetResourceIds[0]
  }
}

module search 'modules/ai/search.bicep' = {
  scope: rg
  name: 'search'
  params: {
    location: location
    privateDnsZoneResourceId: privateDnsZones.outputs.privateDnsZoneResourceIds[7]
    subnetResourceId: vnet.outputs.subnetResourceIds[0]
    suffix: suffix
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
    privateDnsZoneGroupIds: privateDnsZones.outputs.privateDnsZoneResourceIds
    aiSearchEndpoint: search.outputs.searchResourceId
    aiSearchResourceId: search.outputs.searchApiEndpoint
    openaiEndpoint: openai.outputs.cognitiveEndpoint
    openAiResourceId: openai.outputs.cognitiveResourceId
  }
}

/* RBAC Foundry */

module rbacFoundry 'modules/rbac/foundry.bicep' = {
  scope: rg
  name: 'rbacfoundry'
  params: {
    aiSearchResourceId: search.outputs.searchResourceId
    searchAiSystemAssignedMIPrincipalId: search.outputs.systemAssignedMIPrincipalId
    openAiSystemAssignedMIPrincipalId: openai.outputs.systemAssignedMIPrincipalId
    openaiResourceId: openai.outputs.cognitiveResourceId
    storageResourceId: aifoundry.outputs.storageResourceId
  }
}

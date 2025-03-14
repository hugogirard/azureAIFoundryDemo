param location string
param suffix string
param subnetResourceId string
param privateDnsZoneGroupIds array

module dependencies 'dependences.bicep' = {
  name: 'aifoundrydependencies'
  params: {
    location: location
    subnetId: subnetResourceId
    suffix: suffix
    privateDnsZoneGroupIds: privateDnsZoneGroupIds
  }
}

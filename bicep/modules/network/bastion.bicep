param location string
param suffix string
param virtualNetworkResourceId string

module bastion 'br/public:avm/res/network/bastion-host:0.6.1' = {
  name: 'bastion'
  params: {
    name: 'bastion-${suffix}'
    location: location
    virtualNetworkResourceId: virtualNetworkResourceId
    skuName: 'Basic'
  }
}

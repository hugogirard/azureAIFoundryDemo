param location string
param subnetResourceId string
@secure()
param adminUserName string
@secure()
param adminPassword string

module virtualMachine 'br/public:avm/res/compute/virtual-machine:0.12.2' = {
  name: 'jumpboxDeployment'
  params: {
    adminUsername: adminUserName
    imageReference: {
      offer: 'WindowsServer'
      publisher: 'MicrosoftWindowsServer'
      sku: '2022-datacenter-azure-edition'
      version: 'latest'
    }
    name: 'jumpbox'
    nicConfigurations: [
      {
        ipConfigurations: [
          {
            name: 'ipconfig01'
            pipConfiguration: {
              publicIpNameSuffix: '-pip-01'
              zones: []
            }
            subnetResourceId: subnetResourceId
          }
        ]
        nicSuffix: '-nic-01'
      }
    ]
    encryptionAtHost: false
    osDisk: {
      caching: 'ReadWrite'
      diskSizeGB: 128
      managedDisk: {
        storageAccountType: 'Premium_LRS'
      }
    }
    osType: 'Windows'
    vmSize: 'Standard_D2s_v3'
    zone: 0
    adminPassword: adminPassword
    location: location
    autoShutdownConfig: {
      dailyRecurrenceTime: '23:59'
      notificationStatus: 'Disabled'
      status: 'Enabled'
      timeZone: 'UTC'
    }
  }
}

output resourceName string = virtualMachine.outputs.name
output nicConfigurationName string = '${virtualMachine.outputs.name}-nic-01'

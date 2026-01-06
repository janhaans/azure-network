targetScope = 'resourceGroup'

@description('Name of the virtual network to host the subnet.')
param vnetName string

@description('Name of the subnet.')
param subnetName string

@description('Address prefix for the subnet (/24).')
param subnetPrefix string

resource vnet 'Microsoft.Network/virtualNetworks@2023-11-01' existing = {
  name: vnetName
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2023-11-01' = {
  parent: vnet
  name: subnetName
  properties: {
    addressPrefix: subnetPrefix
  }
}

output name string = subnet.name

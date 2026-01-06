targetScope = 'resourceGroup'

@description('Name of the virtual network.')
param name string

@description('Azure region for the virtual network.')
param location string

@description('Address prefix for the virtual network (/16).')
param addressPrefix string

resource vnet 'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name: name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
  }
}

output name string = vnet.name

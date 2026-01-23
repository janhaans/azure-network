targetScope = 'resourceGroup'

@description('Name of the first virtual network.')
param leftVnetName string

@description('Name of the second virtual network.')
param rightVnetName string

resource leftVnet 'Microsoft.Network/virtualNetworks@2023-11-01' existing = {
  name: leftVnetName
}

resource rightVnet 'Microsoft.Network/virtualNetworks@2023-11-01' existing = {
  name: rightVnetName
}

resource leftToRight 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-11-01' = {
  parent: leftVnet
  name: '${leftVnet.name}-to-${rightVnet.name}'
  properties: {
    remoteVirtualNetwork: {
      id: rightVnet.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
  }
}

resource rightToLeft 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-11-01' = {
  parent: rightVnet
  name: '${rightVnet.name}-to-${leftVnet.name}'
  properties: {
    remoteVirtualNetwork: {
      id: leftVnet.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
  }
}

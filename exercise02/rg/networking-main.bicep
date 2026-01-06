targetScope = 'resourceGroup'

// Reference the existing resource group to get its location
resource existingRg 'Microsoft.Resources/resourceGroups@2024-03-01' existing = {
  scope: subscription()
  name: resourceGroup().name
}

// Use the resource group's location
var location = existingRg.location

@description('Name of the hub virtual network.')
param hubVnetName string

@description('Address prefix for the hub virtual network (/16).')
param hubVnetAddressPrefix string

@description('Name of the hub subnet.')
param hubSubnetName string

@description('Address prefix for the hub subnet (/24).')
param hubSubnetPrefix string

@description('Names of the spoke virtual networks.')
@minLength(3)
@maxLength(3)
param spokeVnetNames array

@description('Address prefixes for the spoke virtual networks (/16).')
@minLength(3)
@maxLength(3)
param spokeVnetAddressPrefixes array

@description('Names of the spoke subnets.')
@minLength(3)
@maxLength(3)
param spokeSubnetNames array

@description('Address prefixes for the spoke subnets (/24).')
@minLength(3)
@maxLength(3)
param spokeSubnetPrefixes array

var spokeCount = length(spokeVnetNames)

module hubVnet '../modules/virtualNetwork.bicep' = {
  name: 'hub-vnet-deployment'
  params: {
    name: hubVnetName
    location: location
    addressPrefix: hubVnetAddressPrefix
  }
}

module hubSubnet '../modules/subnet.bicep' = {
  name: 'hub-subnet-deployment'
  params: {
    vnetName: hubVnet.outputs.name
    subnetName: hubSubnetName
    subnetPrefix: hubSubnetPrefix
  }
}

module spokeVnets '../modules/virtualNetwork.bicep' = [for i in range(0, spokeCount): {
  name: 'spoke-vnet-deployment-${i}'
  params: {
    name: spokeVnetNames[i]
    location: location
    addressPrefix: spokeVnetAddressPrefixes[i]
  }
}]

module spokeSubnets '../modules/subnet.bicep' = [for i in range(0, spokeCount): {
  name: 'spoke-subnet-deployment-${i}'
  dependsOn: [
    spokeVnets[i]
  ]
  params: {
    vnetName: spokeVnets[i].outputs.name
    subnetName: spokeSubnetNames[i]
    subnetPrefix: spokeSubnetPrefixes[i]
  }
}]

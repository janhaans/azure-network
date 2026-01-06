targetScope = 'subscription'

@description('Azure region for all resources.')
param location string = 'westeurope'

@description('Name of the resource group to deploy.')
param resourceGroupName string = 'demo-rg'

@description('Name of the hub virtual network.')
param hubVnetName string = 'VNet1-Hub'

@description('Address prefix for the hub virtual network (/16).')
param hubVnetAddressPrefix string = '10.1.0.0/16'

@description('Name of the hub subnet.')
param hubSubnetName string = 'subnet1A'

@description('Address prefix for the hub subnet (/24).')
param hubSubnetPrefix string = '10.1.1.0/24'

@description('Names of the spoke virtual networks.')
@minLength(3)
@maxLength(3)
param spokeVnetNames array = [
  'VNet2-spoke'
  'VNet3-spoke'
  'VNET4-spoke'
]

@description('Address prefixes for the spoke virtual networks (/16).')
@minLength(3)
@maxLength(3)
param spokeVnetAddressPrefixes array = [
  '10.2.0.0/16'
  '10.3.0.0/16'
  '10.4.0.0/16'
]

@description('Names of the spoke subnets.')
@minLength(3)
@maxLength(3)
param spokeSubnetNames array = [
  'subnet2A'
  'subnet3A'
  'subnet4A'
]

@description('Address prefixes for the spoke subnets (/24).')
@minLength(3)
@maxLength(3)
param spokeSubnetPrefixes array = [
  '10.2.1.0/24'
  '10.3.1.0/24'
  '10.4.1.0/24'
]

var spokeCount = length(spokeVnetNames)

module rgModule 'modules/resourceGroup.bicep' = {
  name: 'rg-deployment'
  params: {
    name: resourceGroupName
    location: location
  }
}

module hubVnet 'modules/virtualNetwork.bicep' = {
  name: 'hub-vnet-deployment'
  scope: resourceGroup(resourceGroupName)
  dependsOn: [
    rgModule
  ]
  params: {
    name: hubVnetName
    location: location
    addressPrefix: hubVnetAddressPrefix
  }
}

module hubSubnet 'modules/subnet.bicep' = {
  name: 'hub-subnet-deployment'
  scope: resourceGroup(resourceGroupName)
  dependsOn: [
    hubVnet
  ]
  params: {
    vnetName: hubVnet.outputs.name
    subnetName: hubSubnetName
    subnetPrefix: hubSubnetPrefix
  }
}

module spokeVnets 'modules/virtualNetwork.bicep' = [for i in range(0, spokeCount): {
  name: 'spoke-vnet-deployment-${i}'
  scope: resourceGroup(resourceGroupName)
  dependsOn: [
    rgModule
  ]
  params: {
    name: spokeVnetNames[i]
    location: location
    addressPrefix: spokeVnetAddressPrefixes[i]
  }
}]

module spokeSubnets 'modules/subnet.bicep' = [for i in range(0, spokeCount): {
  name: 'spoke-subnet-deployment-${i}'
  scope: resourceGroup(resourceGroupName)
  dependsOn: [
    spokeVnets[i]
  ]
  params: {
    vnetName: spokeVnets[i].outputs.name
    subnetName: spokeSubnetNames[i]
    subnetPrefix: spokeSubnetPrefixes[i]
  }
}]

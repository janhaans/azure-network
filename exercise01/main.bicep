// Bicep template to create a Resource Group and multiple VNets

// Set the target scope to subscription for the resource group creation
targetScope = 'subscription'

// --- General Parameters ---
param resourceGroupName string = 'CharisTechRG'
param location string = 'eastus'

// --- CoreServicesVNet Parameters ---
param coreVnetName string = 'CoreServicesVNet'
param coreVnetAddressPrefixes_ipv4 array = [
  '10.10.0.0/16'
]
param coreVnetSubnets array = [
  {
    name: 'SharedServicesSubnet'
    addressPrefix: '10.10.1.0/24'
  }
  {
    name: 'DatabaseSubnet'
    addressPrefix: '10.10.2.0/24'
  }
  {
    name: 'PublicWebServiceSubnet'
    addressPrefix: '10.10.3.0/24'
  }
]

// --- EngineeringVNet Parameters (New) ---
param engineeringVnetName string = 'EngineeringVNet'
param engineeringVnetAddressPrefixes_ipv4 array = [
  '10.20.0.0/16'
]
param engineeringVnetAddressPrefixes_ipv6 array = [
  'fd00:db8:deca::/48'
]
param engineeringVnetSubnets array = [
  {
    name: 'EngSubnet1'
    addressPrefix: '10.20.1.0/24'
    ipv6AddressPrefix: 'fd00:db8:deca:1::/64'
  }
  {
    name: 'EngSubnet2'
    addressPrefix: '10.20.2.0/24'
    ipv6AddressPrefix: 'fd00:db8:deca:2::/64'
  }
]

// Create the resource group
resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

// Create the CoreServicesVNet using the network module
module coreNetwork 'network.bicep' = {
  name: 'coreNetworkDeployment'
  scope: resourceGroup(resourceGroupName)
  params: {
    location: location
    vnetName: coreVnetName
    vnetAddressPrefixes_ipv4: coreVnetAddressPrefixes_ipv4
    subnets: coreVnetSubnets
  }
  // Explicitly depend on the resource group creation
  dependsOn: [
    rg
  ]
}

// Create the EngineeringVNet using the same network module
module engineeringNetwork 'network.bicep' = {
  name: 'engineeringNetworkDeployment'
  scope: resourceGroup(resourceGroupName)
  params: {
    location: location
    vnetName: engineeringVnetName
    vnetAddressPrefixes_ipv4: engineeringVnetAddressPrefixes_ipv4
    vnetAddressPrefixes_ipv6: engineeringVnetAddressPrefixes_ipv6
    subnets: engineeringVnetSubnets
  }
  // Explicitly depend on the resource group creation
  dependsOn: [
    rg
  ]
}

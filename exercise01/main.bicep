// Bicep template to create a Resource Group, VNet, and three Subnets

// Set the target scope to subscription for the resource group creation
targetScope = 'subscription'

// Define a parameter for the resource group name
param resourceGroupName string = 'CharisTechRG'

// Define a parameter for the location
param location string = 'eastus'

// Define a parameter for the VNet name
param vnetName string = 'CoreServicesVNet'

// Define a parameter for the VNet address space
param vnetAddressPrefix string = '10.10.0.0/16'

// Define parameters for the subnet names and address spaces
param sharedServicesSubnetName string = 'SharedServicesSubnet'
param sharedServicesSubnetPrefix string = '10.10.1.0/24'

param databaseSubnetName string = 'DatabaseSubnet'
param databaseSubnetPrefix string = '10.10.2.0/24'

param publicWebServiceSubnetName string = 'PublicWebServiceSubnet'
param publicWebServiceSubnetPrefix string = '10.10.3.0/24'

// Create the resource group
resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

// Create the Virtual Network and Subnets within the resource group
module network 'network.bicep' = {
  name: 'networkDeployment'
  scope: resourceGroup(resourceGroupName)
  params: {
    location: location
    vnetName: vnetName
    vnetAddressPrefix: vnetAddressPrefix
    sharedServicesSubnetName: sharedServicesSubnetName
    sharedServicesSubnetPrefix: sharedServicesSubnetPrefix
    databaseSubnetName: databaseSubnetName
    databaseSubnetPrefix: databaseSubnetPrefix
    publicWebServiceSubnetName: publicWebServiceSubnetName
    publicWebServiceSubnetPrefix: publicWebServiceSubnetPrefix
  }
}

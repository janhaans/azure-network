// Bicep module for creating the Virtual Network and Subnets

// Define parameters passed from the main template
param location string
param vnetName string
param vnetAddressPrefix string
param sharedServicesSubnetName string
param sharedServicesSubnetPrefix string
param databaseSubnetName string
param databaseSubnetPrefix string
param publicWebServiceSubnetName string
param publicWebServiceSubnetPrefix string

// Create the Virtual Network
resource vnet 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
    subnets: [
      {
        name: sharedServicesSubnetName
        properties: {
          addressPrefix: sharedServicesSubnetPrefix
        }
      }
      {
        name: databaseSubnetName
        properties: {
          addressPrefix: databaseSubnetPrefix
        }
      }
      {
        name: publicWebServiceSubnetName
        properties: {
          addressPrefix: publicWebServiceSubnetPrefix
        }
      }
    ]
  }
}

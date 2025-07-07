// Bicep module for creating a Virtual Network and its Subnets
// Now supports dual-stack and a variable number of subnets

// Define parameters passed from the main template
param location string
param vnetName string
param vnetAddressPrefixes_ipv4 array
param vnetAddressPrefixes_ipv6 array = [] // Optional for IPv6

// Define a parameter for subnets as an array of objects
param subnets array

// Create the Virtual Network
resource vnet 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      // Combine IPv4 and IPv6 address spaces
      addressPrefixes: union(vnetAddressPrefixes_ipv4, vnetAddressPrefixes_ipv6)
    }
    // Loop through the subnets array to create each subnet
    subnets: [for subnet in subnets: {
      name: subnet.name
      properties: {
        // Use addressPrefixes array to support both IPv4 and IPv6
        addressPrefixes: contains(subnet, 'ipv6AddressPrefix') ? [ subnet.addressPrefix, subnet.ipv6AddressPrefix ] : [ subnet.addressPrefix ]
      }
    }]
  }
}


// Output the subnet resource IDs for use in other modules
output subnetResourceIds array = [for (subnet, i) in subnets: vnet.properties.subnets[i].id]

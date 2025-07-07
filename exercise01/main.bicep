// Bicep template to create a Resource Group and multiple VNets

// Set the target scope to subscription for the resource group creation
targetScope = 'subscription'

// --- General Parameters ---
param resourceGroupName string = 'CharisTechRG'
param location string = 'eastus'
param vmSize string = 'Standard_B2s'
param adminUsername string = 'azureuser'
// SSH Public Key for the VM
param sshPublicKey string = 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF3g3P9JLE/8cmgUDMGgVKt2YChHl8Ms1pgzXLXqgHrb jan.haans@gmail.com'
// VM Image information
param ubuntuImage object = {
  publisher: 'Canonical'
  offer: '0001-com-ubuntu-server-jammy'
  sku: '22_04-lts-gen2'
  version: 'latest'
}

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

// --- VM01 Parameters ---
param vmName01 string = 'WebVM01'

// --- VM01 Parameters ---
param vmName02 string = 'WebVM02'
// Static IP for the second VM
param vm02StaticIP string = '10.10.3.10'

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

// Create the Virtual Machine using the new vm module
module vm 'vm.bicep' = {
  name: 'vmDeployment'
  scope: resourceGroup(resourceGroupName)
  params: {
    location: location
    vmName: vmName01
    vmSize: vmSize
    adminUsername: adminUsername
    sshPublicKey: sshPublicKey
    vmImage: ubuntuImage
    // Get the subnet ID from the output of the coreNetwork module
    subnetId: coreNetwork.outputs.subnetResourceIds[2]
  }
}

// Create the second Virtual Machine (New)
module vm2 'vm.bicep' = {
  name: 'vm2Deployment'
  scope: resourceGroup(resourceGroupName)
  params: {
    location: location
    vmName: vmName02
    vmSize: vmSize
    adminUsername: adminUsername
    sshPublicKey: sshPublicKey
    vmImage: ubuntuImage
    subnetId: coreNetwork.outputs.subnetResourceIds[2]
    // Pass the static IP address to the module
    staticPrivateIPAddress: vm02StaticIP
  }
}

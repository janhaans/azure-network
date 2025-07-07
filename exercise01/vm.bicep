// Bicep module for creating a Linux Virtual Machine and its Network Interface

// --- Parameters ---
param location string
param vmName string
param vmSize string
param adminUsername string
param sshPublicKey string
param subnetId string
param vmImage object
// Optional parameter for static IP. Defaults to an empty string for dynamic assignment.
param staticPrivateIPAddress string = ''

// --- Variables ---
var nicName = '${vmName}-nic'

// --- Resources ---

// Create the Network Interface Card (NIC)
resource nic 'Microsoft.Network/networkInterfaces@2021-05-01' = {
  name: nicName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          // Conditionally set the allocation method and IP address
          privateIPAllocationMethod: !empty(staticPrivateIPAddress) ? 'Static' : 'Dynamic'
          privateIPAddress: !empty(staticPrivateIPAddress) ? staticPrivateIPAddress : null
          subnet: {
            id: subnetId
          }
        }
      }
    ]
  }
}

// Create the Virtual Machine
resource vm 'Microsoft.Compute/virtualMachines@2021-11-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      // Configure for Linux with SSH key authentication
      linuxConfiguration: {
        disablePasswordAuthentication: true
        ssh: {
          publicKeys: [
            {
              path: '/home/${adminUsername}/.ssh/authorized_keys'
              keyData: sshPublicKey
            }
          ]
        }
      }
    }
    storageProfile: {
      // Use the image information passed in from the parameter
      imageReference: {
        publisher: vmImage.publisher
        offer: vmImage.offer
        sku: vmImage.sku
        version: vmImage.version
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
  }
}

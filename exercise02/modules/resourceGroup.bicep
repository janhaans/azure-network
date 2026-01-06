targetScope = 'subscription'

@description('Name of the resource group to create.')
param name string

@description('Azure region for the resource group.')
param location string

resource rg 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: name
  location: location
}

output name string = rg.name
output location string = rg.location

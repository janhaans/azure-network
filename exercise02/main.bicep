targetScope = 'subscription'

@description('Azure region for all resources.')
param location string

@description('Name of the resource group to deploy.')
param resourceGroupName string

module rgModule 'modules/resourceGroup.bicep' = {
  name: 'rg-deployment'
  params: {
    name: resourceGroupName
    location: location
  }
}


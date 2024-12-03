targetScope = 'subscription'

param location string
param resourceGroupName string

resource myResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName 
  location: location
}

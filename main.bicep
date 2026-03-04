targetScope = 'subscription'

/*** PARAMETERS ***/
param resourceGroupName string = 'rg-dataengine-test'
param location string = 'eastus'


/*** RESOURCE GROUP ***/
resource resourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: location
}

/**** Virtual Network Security Group ***/
module nsg 'modules/nsg.bicep' = {
  name: 'test-nsg'
  scope: resourceGroup
  params: {
    location: location
  }
}

/**** Virtual Network ***/
module vnet 'modules/network.bicep' = {
  name: 'test-vnet'
  scope: resourceGroup
  params: {
    location: location
    nsgId: nsg.outputs.nsgId
  }
}

/**** Storage Account ***/
module sa 'modules/storage.bicep' = {
  name: 'test-sa'
  scope: resourceGroup
  params: {
    vnetId: vnet.outputs.vnetId
    location: location

  }
}


output saName string = sa.outputs.storageAccountName
output saId string = sa.outputs.storageAccountId
output subnetId string = '${vnet.outputs.vnetId}/subnets/defaultSubnet'
output nsgId string = nsg.outputs.nsgId

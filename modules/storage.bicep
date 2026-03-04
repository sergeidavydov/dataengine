param location string
param vnetId string

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: 'teststorageaccount'
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    supportsHttpsTrafficOnly: true
    accessTier: 'Hot'
    networkAcls: {
      defaultAction: 'Deny'
      virtualNetworkRules: [
        {
          id: '${vnetId}/subnets/defaultSubnet'
          action: 'Allow'
        }
      ]
    }
  }
}

output storageAccountName string = storageAccount.name
output storageAccountId string = storageAccount.id

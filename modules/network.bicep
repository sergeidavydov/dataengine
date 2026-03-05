param location string
param nsgId string
param namePrefix string
param addressPrefix string

resource vnet 'Microsoft.Network/virtualNetworks@2022-01-01' = {
  name: '${namePrefix}-vnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: [
      {
        name: 'defaultSubnet'
        properties: {
          networkSecurityGroup: {
            id: nsgId
          }
          addressPrefix: addressPrefix
        }
      }
    ]
  }
}

output vnetId string = vnet.id

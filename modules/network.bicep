param location string
param nsgId string

resource testvnet 'Microsoft.Network/virtualNetworks@2022-01-01' = {
  name: 'test-vnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/24'
      ]
    }
    subnets: [
      {
        name: 'defaultSubnet'
        properties: {
          networkSecurityGroup: {
            id: nsgId
          }
          addressPrefix: '10.0.0.0/24'
        }
      }
    ]
  }
}

output vnetId string = testvnet.id

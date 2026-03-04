param location string

resource nsg 'Microsoft.Network/networkSecurityGroups@2022-07-01' = {
  name: 'test-nsg'
  location: location
  properties: {
    securityRules: [
      {
        name: 'AllowSubnetInBound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          sourceAddressPrefix: '10.0.0.0/24'
          destinationPortRange: '*'
          destinationAddressPrefix: '10.0.0.0/24'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
        }
      }
      {
        name: 'DenyAllInBound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationPortRange: '*'
          destinationAddressPrefix: '*'
          access: 'Deny'
          priority: 1000
          direction: 'Inbound'
        }
      }
      {
        name: 'AllowSubnetOutBound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          sourceAddressPrefix: '10.0.0.0/24'
          destinationPortRange: '*'
          destinationAddressPrefix: '10.0.0.0/24'
          access: 'Allow'
          priority: 100
          direction: 'Outbound'
        }
      }
      {
        name: 'DenyAllOutBound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Deny'
          priority: 1000
          direction: 'Outbound'
        }
      }
    ]
  }
}

output nsgId string = nsg.id

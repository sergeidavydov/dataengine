param location string = 'eastus'
param addressPrefix string = '10.0.0.0/24'
param namePrefix string = 'assessment'

// NSG
resource nsg 'Microsoft.Network/networkSecurityGroups@2022-07-01' = {
  name: '${namePrefix}-nsg'
  location: location
  properties: {
    securityRules: [
      {
        name: 'AllowSubnetInBound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          sourceAddressPrefix: addressPrefix
          destinationPortRange: '*'
          destinationAddressPrefix: addressPrefix
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
          sourceAddressPrefix: addressPrefix
          destinationPortRange: '*'
          destinationAddressPrefix: addressPrefix
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

// VNet
module vnet 'modules/network.bicep' = {
  name: '${namePrefix}-vnet'
  params: {
    location: location
    nsgId: nsg.id
    namePrefix: namePrefix
    addressPrefix: addressPrefix
  }
}

// Storage
resource storageAccount 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: '${namePrefix}sa42'
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    supportsHttpsTrafficOnly: true
    networkAcls: {
      defaultAction: 'Deny'
      virtualNetworkRules: [
        {
          id: '${vnet.outputs.vnetId}/subnets/defaultSubnet'
          action: 'Allow'
        }
      ]
    }
  }
}

output saName string = storageAccount.name
output saId string = storageAccount.id
output subnetId string = '${vnet.outputs.vnetId}/subnets/defaultSubnet'
output nsgId string = nsg.id

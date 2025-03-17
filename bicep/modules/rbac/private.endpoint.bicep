param storagePrivateEndpoints array
param projectSystemAssignedMIPrincipalId string

@description('Built-in Role: [Reader]')
resource reader 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: 'acdd72a7-3385-48ef-bd42-f606fba81ae7'
  scope: subscription()
}

module reader_project_private_endpoint 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = [
  for privateEndpoint in storagePrivateEndpoints: {
    name: 'reader_${privateEndpoint.name}'
    params: {
      principalId: projectSystemAssignedMIPrincipalId
      resourceId: privateEndpoint.resourceId
      roleDefinitionId: reader.id
    }
  }
]

targetScope = 'subscription'

@description('The user ID in Microsoft Entra ID')
param userObjectID string

@description('The name of the resource group')
param resourceGroupName string

@description('The name of the OpenAI resource')
param openAiResourceName string

@description('The name of the storage associated to the AI Hub')
param storageName string

@description('The AI Search Resource Name')
param aiSearchName string

@description('Project resource Id')
param projectResourceId string

resource rg 'Microsoft.Resources/resourceGroups@2024-11-01' existing = {
  name: resourceGroupName
}

resource storage 'Microsoft.Storage/storageAccounts@2023-05-01' existing = {
  name: storageName
  scope: rg
}

resource aisearch 'Microsoft.Search/searchServices@2024-06-01-preview' existing = {
  name: aiSearchName
  scope: rg
}

resource openai 'Microsoft.CognitiveServices/accounts@2024-10-01' existing = {
  name: openAiResourceName
  scope: rg
}

module rbac 'modules/rbac/user.project.bicep' = {
  scope: rg
  name: 'rbacproject'
  params: {
    aiSearchResourceId: aisearch.id
    openaiResourceId: openai.id
    storageResourceId: storage.id
    userObjectId: userObjectID
    projectResourceId: projectResourceId
  }
}

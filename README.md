# DataEngine Assessment

## Steps

Note

> The deployment assumes an existent resource group which can be created using az group create --name 'AssessmentRG' --location 'East US'

1. az bicep lint -f main.bicep

   > empty output

2. az deployment group create --resource-group 'AssessmentRG' --template-file https://github.com/sergeidavydov/dataengine/blob/main/main.bicep --what-if
   > output

## RBAC design

- Which identites (human groups, CI/CD principal, managed identity) exist in your design?

  > The assessment scenarion does not include/assume any identites. However, if to theorise on the assessment scenario "a small drop zone for internal platform artifacts" the following identities are possible:
  >
  > 1. Development and/or Infrastructure team group(s) accessing the artifact storage for verification or manual deployments/tests
  > 2. CI/CD principal(s) storing new artifacts/logs
  > 3. Managed identity(ies) assigned to other Azure resources consuming stored artifacts

- What role(s) would each identity receive, and at what scope?

  > 1. User groups might have resource management and/or data plane permissions depending on their roles and requirements, e.g. an infrastructure team could have a contributor/owner role over the whole RG for resource management purposes, whereas a development team might have only a "Storage Blob Data Reader" role over the storage account only, enabling them reading stored artifacts, but not changing them.
  > 2. CI/CD principals could have "Storage Blob Data Contributor" over the storage account to be able to write new artifacts and potentially deleteng the old versions depending on the requirements.
  > 3. MIs are likely to have "Storage Blob Data Reader" role over the strage account since they only read data (consume artifacts).

- Which permissions relate to management plane vs data plane (if applicable) and why?

  > Some Azure services/resources allow separation of resource management and data mangement permissions. In the scope of the assessment scenario the storage account is an example of such resource. Whilst, contributor and owner roles allow full access to stored data via access keys, the storage plane roles such as "Storage Blob Data Reader" or "Storage Blob Data Contributor" only allow operations with data without ability to change or even see a resource itself in Azure portal.

- What is the smallest scope you can use without breaking the workflow?
  > It is possible to scope down permissions to a single blob or set of blobs in a storage account if needed, for instance, if the storage account is shared and there is a requirement to isolate teams/systems from each other.

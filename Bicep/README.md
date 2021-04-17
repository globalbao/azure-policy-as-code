# Azure Policy As Code with Bicep

## Bicep

* **Level 1**
    * Uses built-in policies
    * Uses an initiative and assignment
    * 1x main.bicep
    * Manual CLI deployment

* **Level 2**
    * Uses built-in policies and custom policies
    * Uses multiple initiatives and assignments
    * 1x main.bicep
    * Manual CLI deployment
    * Targeting multiple Azure environments
    * Uses parameter files for environment-specfic values passed during deployment

* **Level 3**
    * Uses built-in policies and custom policies
    * Uses multiple initiatives and assignments
    * Custom policyDefinitionReferenceId for initiatives
    * Custom non-compliance msgs for assignments targeted to the policyDefinitionReferenceId
    * Advanced modules organised per resource type
    * CI/CD workflow automation with GitHub Actions YAML
    * Targeting multiple Azure environments with authentication via GitHub secrets
    * Uses parameter files for environment-specfic values passed during deployment

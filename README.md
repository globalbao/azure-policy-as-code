# Azure Policy As Code

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
    * Advanced modules organised per resource type
    * CI/CD workflow automation with GitHub Actions YAML
    * Targeting multiple Azure environments with authentication via GitHub secrets
    * Uses parameter files for environment-specfic values passed during deployment

## Get in touch :octocat:

* Twitter: [@coder_au](https://twitter.com/coder_au)
* LinkedIn: [@JesseLoudon](https://www.linkedin.com/in/jesseloudon/)
* Web: [jloudon.com](https://jloudon.com)
* GitHub: [@JesseLoudon](https://github.com/jesseloudon)

## Learning resources :books:
* [GitHub - Bicep](https://github.com/Azure/bicep)
* [Docs - Policy](https://docs.microsoft.com/en-us/azure/governance/policy/overview)
* [Learn - Bicep](https://docs.microsoft.com/en-us/learn/modules/deploy-azure-resources-by-using-bicep-templates/)

## Blogs that might interest you :pencil:

* [Azure Spring Clean: DINE to Automate your Monitoring Governance with Azure Monitor Metric Alerts](https://jloudon.com/cloud/Azure-Spring-Clean-DINE-to-Automate-your-Monitoring-Governance-with-Azure-Monitor-Metric-Alerts/)

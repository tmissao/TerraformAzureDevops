# AzureDevops Project Setup

This project intends to fully automitaze a project setup at Azure Devops. Configuring pipelines, build policies, branches policies, required reviewers and giving the necessary permission to pipelines use the agent pools.

## Setup
---

To execute this project it is necessary configuring the following items:

- [Create an Azure Devops Account](https://docs.microsoft.com/en-us/azure/devops/user-guide/sign-up-invite-teammates?view=azure-devops)

- [Create an Azure Devops Token - PAT](https://docs.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate?view=azure-devops&tabs=preview-page)

- [Base Git Repository](https://github.com/tmissao/NodeExpressTemplate)

- [Install TF_ENV](https://github.com/tfutils/tfenv)

## How it Works ?
---

This project create an Azure Devops project importing a previous created git repository like [NodeExpressTemplate](https://github.com/tmissao/NodeExpressTemplate). There is nothing special itself at the git repository, except the folder `.azuredevops` which contains the pipelines definitions (`pipeline-*.yml`) and pipelienes templates (`/templates`), as well as the pull request template `pull_request_template.txt`.

Also, it configures the branch policies like:

- `Build Validations Policies`
- `Merge Policies`
- `Comment Resolution Policy`
- `Work Items Policies`
- `Minimum Reviewers Policy`
- `Automatic Required Reviewer Policy` 

And can create pipelines and environments pipelines, configuring them to use a specific agent pool.

## Usage
---

```bash
module "azuredevops" {
  source = "../terraform-modules/azuredevops/"
  azuredevops_personal_token = "XXXX-XXXX-XXXX"
  organization_name = "MyOrganization"
  project_name = "MyProject"
  repository_name = "MyRepository"
  repository_init_source_url = "https://github.com/tmissao/NodeExpressTemplate.git"
}
```

### See the [demo](./src/example) for full usage and [azuredevops-module](./src/terraform-modules/azuredevops) to module documentation.

## Results
---

![](./artifacts/azure-devops-result.gif)

## References
---

- [Azure Devops Provider](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs)
- [Azure Pipelines YAML](https://docs.microsoft.com/en-us/azure/devops/pipelines/yaml-schema?view=azure-devops&tabs=schema%2Cparameter-schema)
- [Azure Environments Approvals](https://faun.pub/adding-approvals-to-azure-devops-yaml-pipeline-21f41578677b) 
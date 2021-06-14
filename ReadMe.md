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
- `Pipeline Release Approvals `

And can create pipelines and environments pipelines, configuring them to use a specific agent pool.

## Usage
---

```bash
module "project" {
  source                            = "../terraform-modules/azuredevops-project"
  project_name = var.project_name
  authorized_agent_queues_name = var.azuredevops_agentpoll_name
  project_administrators = var.project_administrators
  project_contributors = var.project_contributors
  project_readers = var.project_readers
}

module "repository" {
  source                            = "../terraform-modules/azuredevops-repository"
  azuredevops_personal_token        = var.azuredevops_personal_token
  organization_name                 = var.organization_name
  project_id                        = module.project.id
  repository_name                   = var.repository_name
  repository_init_source_url        = var.repository_init_source_url
  pipelines                         = var.pipelines
  required_merge_requests_reviewers = var.required_merge_requests_reviewers
  release_environments_reviewers    = var.release_environments_reviewers
}
```

### See the [demo](./src/example) for full usage and [azuredevops-module](./src/terraform-modules/azuredevops-repository) to module documentation.

## Results
---

![](./artifacts/azure-devops-result.gif)

## References
---

- [Azure Devops Provider](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs)
- [Azure Pipelines YAML](https://docs.microsoft.com/en-us/azure/devops/pipelines/yaml-schema?view=azure-devops&tabs=schema%2Cparameter-schema)
- [Azure Environments Approvals](https://faun.pub/adding-approvals-to-azure-devops-yaml-pipeline-21f41578677b) 
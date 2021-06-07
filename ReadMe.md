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

Thus, at terraform [vars.tf](./src/vars.tf) everything is configurable:

- `organization_name` - Azure Devops Organization

- `project_name` - Azure Project Name

- `project_scope` - Project Policies Scope to be applied

    - `repository_id` - repository id to apply the policy. Defaults `null`, meaning that all repositories
    - `repository_ref` - repository's branch which policy will be applied. Defaults `refs/heads/master`
    - `match_type` - match type used to apply the policy. Defaults `Exact` 

- `repository_init_source_url` - Base Git repository Url to be imported.

- `pipelines` - A dictionary of pipelines to be create, which the dictionary key is the name of the pipeline.

    - `yml_path` - Yml path of the pipeline definition at the imported repository
    - `build_validation` - Boolean indicating if the pipeline will be used to validate a build (Build Validation)

- `pipeline_environments` - A dictionary of Azure Devops environments that will be associated with the created pipelines, which the dictionary key is the name of the pipeline environment

    - `required_approval` - Boolean indicating if is necessary a manual approval to run the pipeline at the associated environment

- `merge_policy` - Defines the allowed merge operations in the azure devops project. By default just allow the `squash` merge operation.

- `comment_resolution_policy` - Just allow a pull request to be performed if all comments are marked as `resolved`.

- `work_item_policy` - Enforces all pull requests operation to be associated with a work item (Azure Board Tasks).

- `build_validation_policy` - Just allow a pull request to be performed if a `build pipeline` ends with success. See the `pipelines` argument.

- `minimum_reviewers_policy` -  Just allow a pull request if a specific number of reviwers approved it.

- `project_reviewers` - Creates a reviewer group with the entities passed as value, and all pull request and release pipelines (when necesary) will need at least one approval of a member to be executed. 

- `azuredevops_agentpoll_name` - Give the necessary permission to pipelines use the defined agentpoll

## Execution
---

This project is executed by [Terraform](https://www.terraform.io/) tool. And can be archieved by performing the following steps:
```bash
tfenv install   # Install the correct Terraform`s version used by the project. The Terraform`s version is defined in the [.terraform-version](./src/.terraform-version) file
tfenv use       # Configures the runtime to use the correct terraform`s version
terraform plan  # Creates an execution plan, showing all the modifications that will be applied
terraform apply # Applies all the modifications
```

## Results
---



## References
---

- [Azure Devops Provider](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs)
- [Azure Pipelines YAML](https://docs.microsoft.com/en-us/azure/devops/pipelines/yaml-schema?view=azure-devops&tabs=schema%2Cparameter-schema)
- [Azure Environments Approvals](https://faun.pub/adding-approvals-to-azure-devops-yaml-pipeline-21f41578677b) 
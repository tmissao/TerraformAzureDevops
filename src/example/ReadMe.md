# Demo

This project intends to ilustrate how to use the module `azuredevops`.

## Setup
---

To execute this project it is necessary configuring the following items:

- [Create an Azure Devops Account](https://docs.microsoft.com/en-us/azure/devops/user-guide/sign-up-invite-teammates?view=azure-devops)

- [Create an Azure Devops Token - PAT](https://docs.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate?view=azure-devops&tabs=preview-page)

- [Base Git Repository](https://github.com/tmissao/NodeExpressTemplate)

- [Install TF_ENV](https://github.com/tfutils/tfenv)

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

![](../..//artifacts/azure-devops-result.gif)


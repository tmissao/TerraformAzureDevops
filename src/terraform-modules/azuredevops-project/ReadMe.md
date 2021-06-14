# AzureDevops Project Setup Terraform Module

This project intends to fully automitize a project setup at Azure Devops. Creating and configuring the project itself, allowing pipeline queues to be used and allowing users to access. 


## Arguments
---



- `project_name` - (Required) Azure Project Name to be created.

- `project_features` - (Optional) An object containing the Azure Devops Project Features to be enabled.
   
    Defaults

    ```
        {
          "boards"       = "enabled"
          "repositories" = "enabled"
          "pipelines"    = "enabled"
          "artifacts"    = "enabled"
        }
    ```

- `authorized_agent_queues_name` - (Optional) List of name representing the pipeline agents'queue which the project is allowed to use. Defaults `[]`.

- `project_administrators` - (Optional) List of emails representing the project administrators. Defaults `[]`.

- `project_contributors` - (Optional) List of emails representing the project contributors. Defaults `[]`.

- `project_readers` - (Optional) List of emails representing the project readers. Defaults `[]`.

## Output

- `id` - Project`s ID.
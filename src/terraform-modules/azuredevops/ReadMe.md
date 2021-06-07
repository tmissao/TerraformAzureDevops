# AzureDevops Project Setup Terraform Module

This project intends to fully automitaze a project setup at Azure Devops. Configuring pipelines, build policies, branches policies, required reviewers and giving the necessary permission to pipelines use the agent pools.


## Arguments
---

- `azuredevops_personal_token` - (Required) Azure Devops Token (PAT), used to authenticate with the provider.

- `organization_name` - (Required) Azure Devops Organization.

- `project_name` - (Required) Azure Project Name.

- `project_scope` - (Optional) Project Policies Scope to be applied

    - `repository_id` - (Required) repository id to apply the policy. Defaults `null`, meaning that all repositories.
    - `repository_ref` - (Required) repository's branch which policy will be applied. Defaults `refs/heads/master`.
    - `match_type` - (Required) match type used to apply the policy. Defaults `Exact`. 
    
    Defaults

    ```
        [
            {
            repository_id  = null
            repository_ref = "refs/heads/master"
            match_type     = "Exact"
            }
        ]
    ```

- `repository_name` - (Required) Repository`s Name to be created.

- `repository_init_source_url` - (Required) Base Git repository Url to be imported.

- `pipelines` - (Optional) A dictionary of pipelines to be create, which the dictionary key is the name of the pipeline. Defaults `[]`.

    - `yml_path` - (Required) Yml path of the pipeline definition at the imported repository
    - `build_validation` - (Required) Boolean indicating if the pipeline will be used to validate a build (Build Validation)

- `pipeline_environments` - (Optional) A dictionary of Azure Devops environments that will be associated with the created pipelines, which the dictionary key is the name of the pipeline environment. Defaults `[]`.

    - `required_approval` - (Required) Boolean indicating if is necessary a manual approval to run the pipeline at the associated environment

- `merge_policy` - (Optional) Defines the allowed merge operations in the azure devops project.
    - `enabled` - (Required) Boolean indicating if policy is enabled. Defaults `true`.
    - `blocking` - (Required) Boolean indicating if policy will prevent (block) a pull request operation. Defaults `true`.
    - `allow_squash` - (Required) Allows merge type `Squash`. Defaults `true`.
    - `allow_rebase_and_fast_forward` - (Required) Allows merge type `Rebase with Fast Forward`. Defaults `false`.
    - `allow_basic_no_fast_forward` - (Required)  Allows merge type `Basic without Fast Forward`. Defaults `false`.
    - `allow_rebase_with_merge` - (Required) Allows merge type `Rebase with Merge`. Defaults `false`.

    Defaults

    ```
    {
      "enabled" : true
      "blocking" : true
      "allow_squash" : true
      "allow_rebase_and_fast_forward" : false
      "allow_basic_no_fast_forward" : false
      "allow_rebase_with_merge" : false
    }
    ```

- `comment_resolution_policy` - Just allow a pull request to be performed if all comments are marked as `resolved`.
    - `enabled` - (Required) Boolean indicating if policy is enabled. Defaults `true`.
    - `blocking` - (Required) Boolean indicating if policy will prevent (block) a pull request operation. Defaults `true`.

    Defaults

    ```
    {
      "enabled" : true
      "blocking" : true
    }
    ```

- `work_item_policy` - Enforces all pull requests operation to be associated with a work item (Azure Board Tasks).
    - `enabled` - (Required) Boolean indicating if policy is enabled. Defaults `true`.
    - `blocking` - (Required) Boolean indicating if policy will prevent (block) a pull request operation. Defaults `true`.

    Defaults

    ```
    {
      "enabled" : true
      "blocking" : true
    }
    ```

- `build_validation_policy` - Just allow a pull request to be performed if a `build pipeline` ends with success. See the `pipelines` argument.
    - `enabled` - (Required) Boolean indicating if policy is enabled. Defaults `true`.
    - `blocking` - (Required) Boolean indicating if policy will prevent (block) a pull request operation. Defaults `true`.

    Defaults

    ```
    {
      "enabled" : true
      "blocking" : true
    }
    ```

- `minimum_reviewers_policy` -  Just allow a pull request if a specific number of reviwers approved it.
    - `enabled` - (Required) Boolean indicating if policy is enabled. Defaults `true`.
    - `blocking` - (Required) Boolean indicating if policy will prevent (block) a pull request operation. Defaults `true`.
    - `minimum_number_of_reviewer` - (Required) Number of required Reviewers.
    - `author_can_vote` - (Required) Boolean indicating if the pull request`s author is allowed to approve.

    Defaults

    ```
    {
      "enabled" : true
      "blocking" : true
      "minimum_number_of_reviewer" : 1
      "author_can_vote": false
    }
    ```

- `project_reviewers` - Creates a reviewer group with the entities passed as value, and all pull request and release pipelines (when necesary) will need at least one approval of a member to be executed. Defaults `[]`.

- `azuredevops_agentpoll_name` - Give the necessary permission to pipelines use the defined agentpoll. Defaults `Default` 

## Output

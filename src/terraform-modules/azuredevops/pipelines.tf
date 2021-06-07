resource "azuredevops_build_definition" "pipelines" {
  for_each   = var.pipelines
  project_id = azuredevops_project.project.id
  name       = each.key

  ci_trigger {
    use_yaml = true
  }

  repository {
    repo_type   = "TfsGit"
    repo_id     = azuredevops_git_repository.repository.id
    branch_name = azuredevops_git_repository.repository.default_branch
    yml_path    = each.value.yml_path
  }
}

resource "null_resource" "environments" {
  for_each = var.pipeline_environments
  provisioner "local-exec" {
    command = "/bin/bash ./scripts/setup-pipeline-environment.sh"
    environment = {
      TOKEN            = var.azuredevops_personal_token
      ORGANIZATION     = var.organization_name
      PROJECT          = var.project_name
      ENV_NAME         = each.key
      REQUIRE_APPROVAL = each.value.required_approval ? 1 : 0
      REVIEWER_GROUP   = azuredevops_group.reviewers.origin_id
    }
  }
}
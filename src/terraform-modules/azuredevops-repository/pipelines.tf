resource "null_resource" "waiting_git_project_import" {
  provisioner "local-exec" {
    command = "/bin/bash ${path.module}/scripts/wait.sh"
    environment = {
      WAIT_TIME = var.repository_import_waiting_time
    }
  }
}

resource "azuredevops_build_definition" "pipelines" {
  for_each   = var.pipelines
  project_id = data.azuredevops_project.project.id
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
  depends_on = [null_resource.waiting_git_project_import]
}

resource "null_resource" "environments" {
  for_each = local.pipeline_release_environments
  provisioner "local-exec" {
    command = "/bin/bash ${path.module}/scripts/setup-pipeline-environment.sh"
    environment = {
      TOKEN            = var.azuredevops_personal_token
      ORGANIZATION     = var.organization_name
      PROJECT          = data.azuredevops_project.project.name
      ENV_NAME         = lower("${var.repository_name}-${each.key}")
      REQUIRE_APPROVAL = length(each.value) > 0 ? 1 : 0
      REVIEWER_GROUPS  = join(",", each.value)
    }
  }
}
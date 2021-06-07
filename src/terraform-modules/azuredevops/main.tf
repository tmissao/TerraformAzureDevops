terraform {
  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = "0.1.4"
    }
  }
}

locals {
  reviewers = [
    for k, v in data.azuredevops_users.reviewers : join(",", v.users[*].descriptor)
  ]
  pipeline_build_validations = [
    for k, v in var.pipelines : k
    if v.build_validation
  ]
}

data "azuredevops_users" "reviewers" {
  for_each       = toset(var.project_reviewers)
  principal_name = each.value
}

resource "azuredevops_project" "project" {
  name = var.project_name
  features = {
    "boards"       = "enabled"
    "repositories" = "enabled"
    "pipelines"    = "enabled"
    "artifacts"    = "enabled"
  }
}

resource "azuredevops_git_repository" "repository" {
  project_id = azuredevops_project.project.id
  name       = var.repository_name
  initialization {
    init_type   = "Import"
    source_type = "Git"
    source_url  = var.repository_init_source_url
  }
}

resource "azuredevops_group" "reviewers" {
  scope        = azuredevops_project.project.id
  display_name = "Reviewers"
  description  = "Allowed to perform pull requests"
  members      = local.reviewers
}

data "azuredevops_agent_queue" "queue" {
  project_id = azuredevops_project.project.id
  name       = var.azuredevops_agentpoll_name
}

resource "azuredevops_resource_authorization" "auth" {
  project_id  = azuredevops_project.project.id
  resource_id = data.azuredevops_agent_queue.queue.id
  type        = "queue"
  authorized  = true
}
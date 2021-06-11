resource "azuredevops_project" "project" {
  name = var.project_name
  features = {
    "boards"       = "enabled"
    "repositories" = "enabled"
    "pipelines"    = "enabled"
    "artifacts"    = "enabled"
  }
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

module "demo" {
  source                            = "../terraform-modules/azuredevops-repository"
  azuredevops_personal_token        = var.azuredevops_personal_token
  organization_name                 = var.organization_name
  project_id                        = azuredevops_project.project.id
  repository_name                   = var.repository_name
  repository_init_source_url        = var.repository_init_source_url
  pipelines                         = var.pipelines
  required_merge_requests_reviewers = var.required_merge_requests_reviewers
  release_environments_reviewers    = var.release_environments_reviewers
}

output "azuredevops" {
  value = module.demo
}
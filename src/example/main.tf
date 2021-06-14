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

output "azuredevops-project" {
  value = module.project
}

output "azuredevops-repository" {
  value = module.repository
}
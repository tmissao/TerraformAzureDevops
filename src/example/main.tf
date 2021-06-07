module "azuredevops" {
  source = "../terraform-modules/azuredevops/"
  azuredevops_personal_token = var.azuredevops_personal_token
  organization_name = var.organization_name
  project_name = var.project_name
  repository_name = var.repository_name
  repository_init_source_url = var.repository_init_source_url
  pipelines = var.pipelines
  pipeline_environments = var.pipeline_environments
  project_reviewers = var.project_reviewers
}

output "azuredevops" {
  value = module.azuredevops
}
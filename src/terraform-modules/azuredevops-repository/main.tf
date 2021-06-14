terraform {
  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = "0.1.4"
    }
  }
}

locals {
  // Builds an unique array with all reviewers independent of the reviewer group 
  all_reviewers = distinct(flatten([
    for k, v in var.required_merge_requests_reviewers : v.reviewers
  ]))
  // Rebuilds the `required_merge_requests_reviewers` substituting the reviewers` values with Azure Identity Descriptor
  project_reviewers = {
    for k, v in var.required_merge_requests_reviewers : k => {
      "reviewers" : flatten([for i in v.reviewers : data.azuredevops_users.all_reviewers[i].users[*].descriptor]),
      "path" : v.path
    }
  }
  // Selects just the build validations pipelines
  pipeline_build_validations = [
    for k, v in var.pipelines : k
    if v.build_validation
  ]
  // Builds an unique array with all reviewers independent of the environment and release group 
  all_release_reviewers = flatten([
    for k, v in var.release_environments_reviewers : [
      for x, z in v : z
    ]
  ])
  // Rebuilds the `release_environments_reviewers` substituting the reviewers` values with Azure Identity Descriptor
  release_reviewers = {
    for k, v in var.release_environments_reviewers : k => {
      for x, z in v : x => flatten([for i in z : data.azuredevops_users.all_release_reviewers[i].users[*].descriptor])
    }
  }
  // Builds an array with all release groups independent of the environment
  release_groups = flatten([
    for k, v in var.release_environments_reviewers : [
      for z in keys(v) : "${k} ${z}"
      if length(v[z]) > 0
    ]
  ])
  // Builds a map with the environment as key and a list containing all release approver groups as value
  pipeline_release_environments = {
    for k, v in var.release_environments_reviewers : k =>
    flatten([for z in keys(v) : azuredevops_group.release_reviewers["${k} ${z}"].origin_id])
  }
}

data "azuredevops_users" "all_reviewers" {
  for_each       = toset(local.all_reviewers)
  principal_name = each.value
}

data "azuredevops_users" "all_release_reviewers" {
  for_each       = toset(local.all_release_reviewers)
  principal_name = each.value
}

data "azuredevops_project" "project" {
  project_id = var.project_id
}

resource "azuredevops_git_repository" "repository" {
  project_id = data.azuredevops_project.project.id
  name       = var.repository_name
  initialization {
    init_type   = "Import"
    source_type = "Git"
    source_url  = var.repository_init_source_url
  }
}

resource "azuredevops_group" "reviewers" {
  for_each     = local.project_reviewers
  scope        = data.azuredevops_project.project.id
  display_name = each.key
  members      = each.value.reviewers
}

resource "azuredevops_group" "release_reviewers" {
  for_each     = toset(local.release_groups)
  scope        = data.azuredevops_project.project.id
  display_name = "${var.repository_name} ${each.key} Release Reviewers"
  members      = local.release_reviewers[split(" ", each.key)[0]][split(" ", each.key)[1]]
}
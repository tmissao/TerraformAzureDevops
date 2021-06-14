terraform {
  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = "0.1.4"
    }
  }
}

resource "azuredevops_project" "project" {
  name     = var.project_name
  features = var.project_features
}

data "azuredevops_agent_queue" "queue" {
  for_each   = toset(var.authorized_agent_queues_name)
  project_id = azuredevops_project.project.id
  name       = each.value
}

resource "azuredevops_resource_authorization" "auth" {
  for_each    = toset(var.authorized_agent_queues_name)
  project_id  = azuredevops_project.project.id
  resource_id = data.azuredevops_agent_queue.queue[each.key].id
  type        = "queue"
  authorized  = true
}

data "azuredevops_group" "project_administrators" {
  project_id = azuredevops_project.project.id
  name       = "Project Administrators"
}

data "azuredevops_group" "contributors" {
  project_id = azuredevops_project.project.id
  name       = "Contributors"
}

data "azuredevops_group" "readers" {
  project_id = azuredevops_project.project.id
  name       = "Readers"
}

data "azuredevops_users" "project_administrators" {
  for_each       = toset(var.project_administrators)
  principal_name = each.key
}

data "azuredevops_users" "contributors" {
  for_each       = toset(var.project_contributors)
  principal_name = each.key
}

data "azuredevops_users" "readers" {
  for_each       = toset(var.project_readers)
  principal_name = each.key
}

resource "azuredevops_group_membership" "project_administrators" {
  group   = data.azuredevops_group.project_administrators.descriptor
  members = flatten([for k, v in data.azuredevops_users.project_administrators : v.users.*.descriptor])
}

resource "azuredevops_group_membership" "contributors" {
  group   = data.azuredevops_group.contributors.descriptor
  members = flatten([for k, v in data.azuredevops_users.contributors : v.users.*.descriptor])
}

resource "azuredevops_group_membership" "readers" {
  group   = data.azuredevops_group.readers.descriptor
  members = flatten([for k, v in data.azuredevops_users.readers : v.users.*.descriptor])
}
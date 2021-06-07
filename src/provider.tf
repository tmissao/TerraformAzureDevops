terraform {
  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = "0.1.4"
    }
  }
}

provider "azuredevops" {
  org_service_url       = "https://dev.azure.com/${var.organization_name}"
  personal_access_token = var.azuredevops_personal_token
}

data "azuredevops_users" "reviewers" {
  for_each       = toset(var.project_reviewers)
  principal_name = each.value
}
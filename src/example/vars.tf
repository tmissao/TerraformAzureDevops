variable "azuredevops_personal_token" {
  type    = string
}

variable "organization_name" {
  type    = string
}

variable "project_name" {
  type    = string
}

variable "repository_name" {
  type    = string
}

variable "repository_init_source_url" {
  type    = string
}

variable "pipelines" {
  type = map(object({ yml_path = string, build_validation = bool }))
  default = {}
}

variable "pipeline_environments" {
  type = map(object({ required_approval = bool }))
  default = {}
}

variable "project_reviewers" {
  type = list(string)
  default = []
}
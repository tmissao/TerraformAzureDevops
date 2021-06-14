variable "azuredevops_personal_token" {
  type = string
}

variable "azuredevops_agentpoll_name" {
  type    = list(string)
  default = []
}

variable "organization_name" {
  type = string
}

variable "project_name" {
  type = string
}

variable "project_administrators" {
  type = list(string)
  default = []
}

variable "project_contributors" {
  type = list(string)
  default = []
}

variable "project_readers" {
  type = list(string)
  default = []
}

variable "repository_name" {
  type = string
}

variable "repository_init_source_url" {
  type = string
}

variable "pipelines" {
  type    = map(object({ yml_path = string, build_validation = bool }))
  default = {}
}

variable "pipeline_environments" {
  type    = map(object({ required_approval = bool }))
  default = {}
}

variable "required_merge_requests_reviewers" {
  type    = map(object({ reviewers = list(string), path = list(string) }))
  default = {}
}

variable "release_environments_reviewers" {
  type    = map(map(list(string)))
  default = {}
}
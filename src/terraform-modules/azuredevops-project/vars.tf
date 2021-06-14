variable "project_name" {
  type = string
}

variable "project_features" {
  type = object({ boards = string, repositories = string, pipelines = string, artifacts = string })
  default = {
    "boards"       = "enabled"
    "repositories" = "enabled"
    "pipelines"    = "enabled"
    "artifacts"    = "enabled"
  }
}

variable "authorized_agent_queues_name" {
  type    = list(string)
  default = []
}

variable "project_administrators" {
  type    = list(string)
  default = []
}

variable "project_contributors" {
  type    = list(string)
  default = []
}

variable "project_readers" {
  type    = list(string)
  default = []
}
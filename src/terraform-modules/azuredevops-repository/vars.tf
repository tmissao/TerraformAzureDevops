variable "azuredevops_personal_token" {
  type    = string
}

variable "organization_name" {
  type    = string
}

variable "project_id" {
  type = string
}

variable "project_scope" {
  default = [
    {
      repository_ref = "refs/heads/master"
      match_type     = "Exact"
    }
  ]
}

variable "repository_name" {
  type    = string
}

variable "repository_init_source_url" {
  type    = string
}

variable "repository_import_waiting_time" {
  type = string
  default = "60s"
}

variable "pipelines" {
  type = map(object({ yml_path = string, build_validation = bool }))
  default = {}
}

variable "release_environments_reviewers" {
  type = map(map(list(string)))
  default = {}
}

variable "merge_policy" {
  type = object(
    {
      enabled                     = bool, blocking = bool, allow_squash = bool, allow_rebase_and_fast_forward = bool,
      allow_basic_no_fast_forward = bool, allow_rebase_with_merge = bool
    }
  )
  default = {
    "enabled" : true
    "blocking" : true
    "allow_squash" : true
    "allow_rebase_and_fast_forward" : false
    "allow_basic_no_fast_forward" : false
    "allow_rebase_with_merge" : false
  }
}

variable "comment_resolution_policy" {
  type = object({enabled = bool, blocking = bool})
  default = {
    "enabled" : true
    "blocking" : true
  }
}

variable "work_item_policy" {
  type = object({enabled = bool, blocking = bool})
  default = {
    "enabled" : true
    "blocking" : true
  }
}

variable "build_validation_policy" {
  type = object({enabled = bool, blocking = bool})
  default = {
    "enabled" : true
    "blocking" : true
  }
}

variable "minimum_reviewers_policy" {
  type = object({enabled = bool, blocking = bool, minimum_number_of_reviewer = number, author_can_vote = bool})
  default = {
    "enabled" : true
    "blocking" : true
    "minimum_number_of_reviewer" : 1
    "author_can_vote": false
  }
}

variable "required_merge_requests_reviewers" {
  type = map(object({reviewers = list(string), path = list(string)}))
  default = {}
}
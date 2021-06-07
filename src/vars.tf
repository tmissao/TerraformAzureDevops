variable "azuredevops_personal_token" {
  type    = string
}

variable "azuredevops_agentpoll_name" {
  type    = string
  default = "Default"
}

variable "organization_name" {
  type    = string
  default = "Acqio"
}

variable "project_name" {
  type    = string
  default = "Terraform"
}

variable "project_scope" {
  default = [
    {
      repository_id  = null
      repository_ref = "refs/heads/master"
      match_type     = "Exact"
    }
  ]
}

variable "repository_name" {
  type    = string
  default = "Demo Repository"
}

variable "repository_init_source_url" {
  type    = string
  default = "https://github.com/tmissao/NodeExpressTemplate.git"
}

variable "pipelines" {
  type = map(object({ yml_path = string, build_validation = bool }))
  default = {
    "ensure-quality" : {
      "yml_path" : ".azuredevops/pipeline-pr-builder.yml"
      "build_validation" : true
    },
    "merge" : {
      "yml_path" : ".azuredevops/pipeline-merge.yml"
      "build_validation" : false
    },
    "deploy-dev" : {
      "yml_path" : ".azuredevops/pipeline-deploy-dev.yml"
      "build_validation" : false
    },
    "deploy-prod" : {
      "yml_path" : ".azuredevops/pipeline-deploy-prod.yml"
      "build_validation" : false
    },
  }
}

variable "pipeline_environments" {
  type = map(object({ required_approval = bool }))
  default = {
    "development" : {
      "required_approval" : false
    },
    "production" : {
      "required_approval" : true
    },
  }
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

variable "project_reviewers" {
  type = list(string)
  default = [
    "tiago.missao@acqio.com.br",
    "paulo.barros@acqio.com.br",
    "eduardo.rocha@acqio.com.br"
  ]
}
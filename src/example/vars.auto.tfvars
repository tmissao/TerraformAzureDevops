organization_name          = "Acqio"
project_name               = "demo-project"
repository_name            = "demo"
repository_init_source_url = "https://github.com/tmissao/NodeExpressTemplate.git"
pipelines = {
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

required_merge_requests_reviewers = {
  "Devops Reviewers" : {
    "reviewers" : ["tiago.missao@xpto.com.br", "antonio.barros@xpto.com.br"],
    "path" : ["/config/*", "/.azuredevops/*", "/.buildkite/*"]
  },
  "Global Reviewers" : {
    "reviewers" : ["antonio.barros@xpto.com.br"]
    "path" : ["*"]
  },
}

release_environments_reviewers = {
  "Development" : {
    "G1" : ["tiago.missao@xpto.com.br"]
  }
  "Production" : {
    "G2" : ["tiago.missao@xpto.com.br", "antonio.barros@xpto.com.br"]
    "G3" : ["eduardo.moura@xpto.com.br", "irineu.pedroso@xpto.com.br"]
  }
}
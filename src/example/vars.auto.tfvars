organization_name="Xpto"
project_name="Automitizer"
repository_name="demo"
repository_init_source_url="https://github.com/tmissao/NodeExpressTemplate.git"
pipelines={
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
    "Devops Reviewers": {
      "reviewers": ["tiago.missao@xpto.com.br", "paulo.barros@xpto.com.br"],
      "path": ["/config/*","/.azuredevops/*", "/.buildkite/*"]
    },
    "Global Reviewers": {
      "reviewers": ["paulo.barros@xpto.com.br", "eduardo.rocha@xpto.com.br"]
      "path": ["*"]
    },
  }

release_environments_reviewers = {
    "Development": {}
    "Production": {
      "G2": ["tiago.missao@xpto.com.br", "paulo.barros@xpto.com.br"]
      "G3": ["eduardo.rocha@xpto.com.br", "irineu.moura@xpto.com.br"]
    }
  }

azuredevops_agentpoll_name = ["Default"]

project_administrators = ["tiago.missao@xpto.com.br", "paulo.barros@xpto.com.br"]

project_contributors = ["rodrigo.santos@xpto.com.br"]

project_readers = ["eduardo.rocha@xpto.com.br", "myllena.cardoso@xpto.com.br", "vandson.araujo@xpto.com.br"]
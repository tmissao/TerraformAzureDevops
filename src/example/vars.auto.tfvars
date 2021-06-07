organization_name="Acqio"
project_name="Terraform"
repository_name="Demo-Repository"
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
pipeline_environments={
  "development" : {
    "required_approval" : false
  },
  "production" : {
    "required_approval" : true
  },
}
project_reviewers=[
  "tiago.missao@acqio.com.br"
]
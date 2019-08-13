module "front" {
  source           = "../../../../modules/aws/frontend"
  acm              = data.terraform_remote_state.acm.outputs.acm
  iam              = data.terraform_remote_state.iam.outputs.iam
  main_domain_name = var.main_domain_name
}

module "front" {
  source           = "../../../../modules/aws/frontend"
  acm              = data.terraform_remote_state.acm.outputs.acm
  main_domain_name = var.main_domain_name
}

module "fargate" {
  source           = "../../../../modules/aws/fargate"
  vpc              = "${data.terraform_remote_state.network.vpc}"
  ecr              = "${data.terraform_remote_state.ecr.ecr}"
  rds              = "${data.terraform_remote_state.rds.rds}"
  main_domain_name = "${var.main_domain_name}"
}

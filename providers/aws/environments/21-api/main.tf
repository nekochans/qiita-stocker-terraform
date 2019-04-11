module "api" {
  source           = "../../../../modules/aws/api"
  vpc              = "${data.terraform_remote_state.network.vpc}"
  bastion          = "${data.terraform_remote_state.bastion.bastion}"
  main_domain_name = "${var.main_domain_name}"
  ecr              = "${data.terraform_remote_state.ecr.ecr}"
  rds              = "${data.terraform_remote_state.rds.rds}"
}

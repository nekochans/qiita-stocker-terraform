module "ecs" {
  source           = "../../../../modules/aws/ecs"
  vpc              = "${data.terraform_remote_state.network.vpc}"
  bastion          = "${data.terraform_remote_state.bastion.bastion}"
  ecr              = "${data.terraform_remote_state.ecr.ecr}"
  rds              = "${data.terraform_remote_state.rds.rds}"
  main_domain_name = "${var.main_domain_name}"
}

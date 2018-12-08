module "rds" {
  source                       = "../../../../modules/aws/rds"
  vpc                          = "${data.terraform_remote_state.network.vpc}"
  api                          = "${data.terraform_remote_state.api.api}"
  rds_master_username          = "${var.rds_master_username}"
  rds_master_password          = "${var.rds_master_password}"
  rds_local_master_domain_name = "${var.rds_local_master_domain_name}"
}

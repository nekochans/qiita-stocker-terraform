module "bastion" {
  source              = "../../../../modules/aws/api"
  vpc                 = "${data.terraform_remote_state.network.vpc}"
  bastion_security_id = "${data.terraform_remote_state.bastion.bastion_security_id}"
}

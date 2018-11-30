module "bastion" {
  source = "../../../../modules/aws/bastion"
  vpc    = "${data.terraform_remote_state.network.vpc}"
}

module "api" {
  source  = "../../../../modules/aws/api"
  vpc     = "${data.terraform_remote_state.network.vpc}"
  bastion = "${data.terraform_remote_state.bastion.bastion}"
}

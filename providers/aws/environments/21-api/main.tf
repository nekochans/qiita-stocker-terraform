module "bastion" {
  source  = "../../../../modules/aws/api"
  vpc     = "${data.terraform_remote_state.network.vpc}"
  bastion = "${data.terraform_remote_state.backend.bastion}"
}

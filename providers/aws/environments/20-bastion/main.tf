module "bastion" {
  source              = "../../../../modules/aws/bastion"
  vpc                 = data.terraform_remote_state.network.outputs.vpc
  ssh_public_key_path = var.ssh_public_key_path
}

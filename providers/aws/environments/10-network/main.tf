module "vpc" {
  source              = "../../../../modules/aws/vpc"
  ssh_public_key_path = var.ssh_public_key_path
}

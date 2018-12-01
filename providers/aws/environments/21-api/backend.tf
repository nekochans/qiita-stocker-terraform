terraform {
  required_version = "=0.11.10"

  backend "s3" {
    bucket  = "dev-qiita-stocker-tfstate"
    key     = "api/terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "qiita-stocker-dev"
  }
}

data "terraform_remote_state" "network" {
  backend = "s3"

  config {
    bucket  = "dev-qiita-stocker-tfstate"
    key     = "env:/${terraform.env}/network/terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "qiita-stocker-dev"
  }
}

data "terraform_remote_state" "bastion" {
  backend = "s3"

  config {
    bucket  = "dev-qiita-stocker-tfstate"
    key     = "env:/${terraform.env}/bastion/terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "qiita-stocker-dev"
  }
}

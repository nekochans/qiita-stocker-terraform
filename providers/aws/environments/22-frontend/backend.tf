terraform {
  required_version = "=0.11.10"

  backend "s3" {
    bucket  = "dev-qiita-stocker-tfstate"
    key     = "frontend/terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "qiita-stocker-dev"
  }
}

data "terraform_remote_state" "acm" {
  backend = "s3"

  config {
    bucket  = "dev-qiita-stocker-tfstate"
    key     = "env:/${terraform.env}/acm/terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "qiita-stocker-dev"
  }
}

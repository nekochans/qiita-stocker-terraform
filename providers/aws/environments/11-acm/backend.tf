terraform {
  required_version = "=0.11.10"

  backend "s3" {
    bucket  = "dev-qiita-stocker-tfstate"
    key     = "acm/terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "qiita-stocker-dev"
  }
}

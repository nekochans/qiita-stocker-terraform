resource "aws_s3_bucket" "web" {
  bucket        = "${terraform.workspace}-${var.frontend["default.bucket"]}"
  force_destroy = true
}

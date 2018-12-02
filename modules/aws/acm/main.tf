data "aws_acm_certificate" "main" {
  domain = "*.${var.main_domain_name}"
}

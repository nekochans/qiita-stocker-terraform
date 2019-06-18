output "acm" {
  value = {
    "main_arn" = data.aws_acm_certificate.main.arn
  }
}

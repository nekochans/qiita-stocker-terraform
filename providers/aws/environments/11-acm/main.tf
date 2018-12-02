module "acm" {
  source           = "../../../../modules/aws/acm"
  main_domain_name = "${var.main_domain_name}"
}

data "aws_route53_zone" "api" {
  name = var.main_domain_name
}

resource "aws_route53_record" "api" {
  zone_id = data.aws_route53_zone.api.zone_id
  name = lookup(
    var.sub_domain_name,
    "${terraform.workspace}.name",
    var.sub_domain_name["default.name"]
  )
  type = "A"

  alias {
    name                   = aws_alb.fargate_alb.dns_name
    zone_id                = aws_alb.fargate_alb.zone_id
    evaluate_target_health = false
  }
}

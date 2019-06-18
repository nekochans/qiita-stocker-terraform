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

resource "aws_route53_record" "ecs_api" {
  count   = terraform.workspace != "prod" ? 1 : 0
  zone_id = data.aws_route53_zone.api.zone_id
  name = lookup(
    var.sub_domain_name,
    "${terraform.workspace}.ecs_name",
    var.sub_domain_name["default.ecs_name"]
  )
  type = "A"

  alias {
    name                   = aws_alb.ecs_alb[0].dns_name
    zone_id                = aws_alb.ecs_alb[0].zone_id
    evaluate_target_health = false
  }
}

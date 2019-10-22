resource "aws_route53_record" "nuxt" {
  zone_id = data.aws_route53_zone.web.zone_id
  name = lookup(
    var.sub_domain_name,
    "${terraform.workspace}.name",
    var.sub_domain_name["default.name"]
  )
  type = "A"

  alias {
    name                   = aws_cloudfront_distribution.nuxt.domain_name
    zone_id                = aws_cloudfront_distribution.nuxt.hosted_zone_id
    evaluate_target_health = false
  }
}
data "aws_region" "current" {}

data "aws_api_gateway_rest_api" "nuxt" {
  name = "${terraform.workspace}-${var.api_gateway}"
}

resource "aws_cloudfront_distribution" "nuxt" {
  origin {
    domain_name = aws_s3_bucket.nuxt.bucket_regional_domain_name
    origin_id   = "S3-${terraform.workspace}-${var.bucket_nuxt}"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.nuxt_origin_access_identity.cloudfront_access_identity_path
    }
  }

  origin {
    domain_name = "${data.aws_api_gateway_rest_api.nuxt.id}.execute-api.${data.aws_region.current.name}.amazonaws.com"
    origin_id   = "APIGateway-${terraform.workspace}-${var.api_gateway}"
    origin_path = "/${terraform.workspace}"

    custom_origin_config {
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]

      http_port                = 80
      https_port               = 443
      origin_keepalive_timeout = 5
      origin_read_timeout      = 30
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  enabled         = true
  is_ipv6_enabled = true

  aliases = ["${lookup(
    var.sub_domain_name,
    "${terraform.workspace}.name",
    var.sub_domain_name["default.name"]
  )}.${var.main_domain_name}"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    compress         = false
    target_origin_id = "APIGateway-${terraform.workspace}-${var.api_gateway}"

    forwarded_values {
      query_string = true

      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "https-only"

    min_ttl     = 0
    default_ttl = 86400
    max_ttl     = 31536000
  }

  ordered_cache_behavior {
    path_pattern     = "_nuxt/*"
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    compress         = true
    target_origin_id = "S3-${terraform.workspace}-${var.bucket_nuxt}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"

    min_ttl     = 0
    default_ttl = 86400
    max_ttl     = 31536000
  }

  ordered_cache_behavior {
    path_pattern     = "assets/*"
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    compress         = true
    target_origin_id = "S3-${terraform.workspace}-${var.bucket_nuxt}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"

    min_ttl     = 0
    default_ttl = 86400
    max_ttl     = 31536000
  }

  price_class = "PriceClass_All"

  custom_error_response {
    error_caching_min_ttl = 300
    error_code            = 403
    response_code         = 200
    response_page_path    = "/index.html"
  }

  custom_error_response {
    error_caching_min_ttl = 300
    error_code            = 404
    response_code         = 404
    response_page_path    = "/index.html"
  }

  viewer_certificate {
    cloudfront_default_certificate = false
    acm_certificate_arn            = var.acm["main_arn"]
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.1_2016"
  }

  logging_config {
    include_cookies = true
    bucket          = aws_s3_bucket.nuxt_access_logs.bucket_domain_name
    prefix          = "raw/"
  }
}

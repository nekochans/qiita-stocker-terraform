resource "aws_s3_bucket" "web" {
  bucket        = "${terraform.workspace}-${var.bucket}"
  force_destroy = true
}

resource "aws_s3_bucket" "web_access_logs" {
  bucket        = "${terraform.workspace}-${var.bucket}-logs"
  force_destroy = true
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.web.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "web" {
  bucket = aws_s3_bucket.web.id
  policy = data.aws_iam_policy_document.s3_policy.json
}

data "aws_iam_policy_document" "web_access_logs" {
  statement {
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.web_access_logs.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "web_access_logs" {
  bucket = aws_s3_bucket.web_access_logs.id
  policy = data.aws_iam_policy_document.web_access_logs.json
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "access-identity-S3-${terraform.workspace}-${var.bucket}"
}

data "aws_route53_zone" "web" {
  name = var.main_domain_name
}

resource "aws_route53_record" "web" {
  zone_id = data.aws_route53_zone.web.zone_id
  name = lookup(
    var.sub_domain_name,
    "${terraform.workspace}.name",
    var.sub_domain_name["default.name"]
  )
  type = "A"

  alias {
    name                   = aws_cloudfront_distribution.web.domain_name
    zone_id                = aws_cloudfront_distribution.web.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_cloudfront_distribution" "web" {
  origin {
    domain_name = aws_s3_bucket.web.bucket_regional_domain_name
    origin_id   = "S3-${terraform.workspace}-${var.bucket}"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  aliases = ["${lookup(
    var.sub_domain_name,
    "${terraform.workspace}.name",
    var.sub_domain_name["default.name"]
  )}.${var.main_domain_name}"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    compress         = false
    target_origin_id = "S3-${terraform.workspace}-${var.bucket}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "https-only"

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
    bucket          = aws_s3_bucket.web_access_logs.bucket_domain_name
    prefix          = "raw/"
  }
}

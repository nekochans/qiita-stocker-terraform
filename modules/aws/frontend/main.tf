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

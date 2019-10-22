resource "aws_s3_bucket" "nuxt" {
  bucket        = "${terraform.workspace}-${var.bucket_nuxt}"
  force_destroy = true
}

resource "aws_s3_bucket" "nuxt_access_logs" {
  bucket        = "${terraform.workspace}-${var.bucket_nuxt}-logs"
  force_destroy = true
}

data "aws_iam_policy_document" "nust_s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.nuxt.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.nuxt_origin_access_identity.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "nuxt" {
  bucket = aws_s3_bucket.nuxt.id
  policy = data.aws_iam_policy_document.nust_s3_policy.json
}

data "aws_iam_policy_document" "nuxt_access_logs" {
  statement {
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.nuxt_access_logs.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.nuxt_origin_access_identity.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "nuxt_access_logs" {
  bucket = aws_s3_bucket.nuxt_access_logs.id
  policy = data.aws_iam_policy_document.nuxt_access_logs.json
}

resource "aws_cloudfront_origin_access_identity" "nuxt_origin_access_identity" {
  comment = "access-identity-S3-${terraform.workspace}-${var.bucket_nuxt}"
}

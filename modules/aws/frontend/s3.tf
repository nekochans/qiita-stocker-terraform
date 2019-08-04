resource "aws_s3_bucket" "nuxt" {
  count = terraform.workspace == "stg" ? 1 : 0

  bucket        = "${terraform.workspace}-${var.bucket_nuxt}"
  force_destroy = true
}

resource "aws_s3_bucket" "nuxt_access_logs" {
  count = terraform.workspace == "stg" ? 1 : 0

  bucket        = "${terraform.workspace}-${var.bucket_nuxt}-logs"
  force_destroy = true
}

data "aws_iam_policy_document" "nust_s3_policy" {
  count = terraform.workspace == "stg" ? 1 : 0

  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.nuxt[count.index].arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.nuxt_origin_access_identity[count.index].iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "nuxt" {
  count = terraform.workspace == "stg" ? 1 : 0

  bucket = aws_s3_bucket.nuxt[count.index].id
  policy = data.aws_iam_policy_document.nust_s3_policy[count.index].json
}

data "aws_iam_policy_document" "nuxt_access_logs" {
  count = terraform.workspace == "stg" ? 1 : 0

  statement {
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.nuxt_access_logs[count.index].arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.nuxt_origin_access_identity[count.index].iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "nuxt_access_logs" {
  count = terraform.workspace == "stg" ? 1 : 0

  bucket = aws_s3_bucket.nuxt_access_logs[count.index].id
  policy = data.aws_iam_policy_document.nuxt_access_logs[count.index].json
}

resource "aws_cloudfront_origin_access_identity" "nuxt_origin_access_identity" {
  count = terraform.workspace == "stg" ? 1 : 0

  comment = "access-identity-S3-${terraform.workspace}-${var.bucket_nuxt}"
}

output "iam" {
  value = {
    "codebuild_role_arn" = aws_iam_role.codebuild_role.arn
  }
}

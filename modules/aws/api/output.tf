output "api" {
  value = {
    "api_security_id"           = aws_security_group.fargate_api.id
    "api_codebuild_security_id" = aws_security_group.api_codebuild.id
  }
}

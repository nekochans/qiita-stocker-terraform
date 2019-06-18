output "api" {
  value = {
    "api_security_id"           = aws_security_group.fargate_api.id
    "api_codebuild_security_id" = aws_security_group.api_codebuild.id
  }
}

output "ecs_api" {
  value = {
    "ecs_api_security_id" = aws_security_group.ecs_api[0].id
  }
}

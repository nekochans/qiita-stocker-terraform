output "ecr" {
  value = {
    "php_image_url"   = aws_ecr_repository.php.repository_url
    "nginx_image_url" = aws_ecr_repository.nginx.repository_url
  }
}

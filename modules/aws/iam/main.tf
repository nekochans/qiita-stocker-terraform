data "aws_iam_policy_document" "codebuild_trust_relationship" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"

      identifiers = [
        "codebuild.amazonaws.com",
        "codedeploy.amazonaws.com",
        "secretsmanager.amazonaws.com",
        "s3.amazonaws.com",
      ]
    }
  }
}

resource "aws_iam_role" "codebuild_role" {
  name               = "${terraform.workspace}-common-codebuild-role"
  assume_role_policy = data.aws_iam_policy_document.codebuild_trust_relationship.json
}

resource "aws_iam_role_policy_attachment" "attach_admin_access_to_codebuild_role" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

data "aws_iam_policy_document" "rds_monitoring" {
  "statement" {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "rds_monitoring" {
  name               = "${terraform.workspace}-rds-monitoring"
  assume_role_policy = "${data.aws_iam_policy_document.rds_monitoring.json}"
}

resource "aws_iam_role_policy_attachment" "rds_monitoring" {
  role       = "${aws_iam_role.rds_monitoring.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

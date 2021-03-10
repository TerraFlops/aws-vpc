data "aws_iam_policy_document" "flow_log_iam_assume_role_policy_document" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "flow_log_iam_role_policy_document" {
  version = "2012-10-17"
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams"
    ]
    effect = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_policy" "flow_log_iam_role_policy" {
  name = "${var.log_group_name}FlowLogPolicy"
  policy = data.aws_iam_policy_document.flow_log_iam_role_policy_document.json
}

resource "aws_iam_role" "flow_log_iam_role" {
  name = var.log_group_name
  description = "${var.log_group_name} Flow Log Role"
  assume_role_policy = data.aws_iam_policy_document.flow_log_iam_assume_role_policy_document.json
}

resource "aws_iam_role_policy_attachment" "flow_log_iam_role_policy_attachment" {
  policy_arn = aws_iam_policy.flow_log_iam_role_policy.arn
  role = aws_iam_role.flow_log_iam_role.name
}

resource "aws_cloudwatch_log_group" "flow_log_cloudwatch_log_group" {
  name = var.log_group_name
  retention_in_days = 0
}

resource "aws_flow_log" "flow_log" {
  vpc_id = var.vpc_id
  traffic_type = "ALL"
  iam_role_arn = aws_iam_role.flow_log_iam_role.arn
  log_destination = aws_cloudwatch_log_group.flow_log_cloudwatch_log_group.arn
}

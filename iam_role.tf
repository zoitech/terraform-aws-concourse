resource "aws_iam_role" "ec2_role" {
  name = "${var.prefix}-concourse"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ec2_role_admin" {
  role       = "${aws_iam_role.ec2_role.name}"
  policy_arn = "${element(var.role_policies, count.index)}"
  count      = "${length(var.role_policies)}"
}

resource "aws_iam_instance_profile" "ec2_role_profile" {
  name = "${aws_iam_role.ec2_role.name}"
  role = "${aws_iam_role.ec2_role.name}"
}

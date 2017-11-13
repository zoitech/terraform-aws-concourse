resource "aws_security_group" "RuleGroupLBHttpIn" {
  name        = "Rule-${var.prefix}.GroupLB-in-HTTP"
  description = "Allow all http(s) traffic"
  vpc_id      = "${var.vpc_id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    security_groups = ["${aws_security_group.GroupLB.id}"]
  }
}

resource "aws_security_group" "GroupLB" {
  name        = "Group-${var.prefix}.LB"
  description = "Allow all inbound traffic"
  vpc_id      = "${var.vpc_id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

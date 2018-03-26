resource "aws_security_group" "RuleGroupLBHttpIn" {
  name        = "Rule-${var.prefix}.coucourse.LB-in-HTTP"
  description = "Allow all http(s) traffic"
  vpc_id      = "${var.vpc_id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"

    security_groups = ["${aws_security_group.GroupLB.id}"]
  }
}

resource "aws_security_group" "GroupLB" {
  name        = "Group-${var.prefix}.coucourse.LB"
  description = "Attach security group with loadbalancer name to loadbalancer with only outbound rules"
  vpc_id      = "${var.vpc_id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

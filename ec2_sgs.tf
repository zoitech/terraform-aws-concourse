# Groups
resource "aws_security_group" "GroupLB" {
  name        = "Group-${var.prefix}.coucourse.LB"
  description = "Allow all outbound traffic"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "GroupWS" {
  name        = "Group-${var.prefix}.coucourse.WebServer"
  description = "Allow all outbound traffic"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Rules
resource "aws_security_group" "RuleGroupLBHttpIn" {
  name        = "Rule-${var.prefix}.coucourse.LB-in-HTTP"
  description = "Allow all http(s) traffic"
  vpc_id      = var.vpc_id

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

    security_groups = [aws_security_group.GroupLB.id]
  }
}

resource "aws_security_group" "RuleGroupWsIn" {
  name        = "Rule-${var.prefix}.coucourse.WS-in-5432"
  description = "Allow all http(s) traffic"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"

    security_groups = [aws_security_group.GroupWS.id]
  }
}


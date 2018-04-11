resource "aws_lb_target_group" "concourse" {
  name     = "${var.prefix}-concourse-backend"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"
}

resource "aws_lb_target_group_attachment" "concourse" {
  target_group_arn = "${aws_lb_target_group.concourse.arn}"
  target_id        = "${aws_instance.ec2_docker_instance.id}"
  port             = 8080
}

resource "aws_lb" "concourse" {
  name            = "${var.prefix}-concourse-alb"
  internal        = false
  security_groups = ["${aws_security_group.GroupLB.id}", "${var.alb_sg_id}"]
  subnets         = ["${var.public_sn}"]

  access_logs {
   enabled = "${var.enable_alb_access_logs}" #default = false
   bucket  = "${var.s3_log_bucket_name}"
   prefix  = "${var.s3_log_bucket_Key_name}"
 }

  enable_deletion_protection = false
}

resource "aws_lb_listener" "concource_http" {
  load_balancer_arn = "${aws_lb.concourse.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_lb_target_group.concourse.arn}"
    type             = "forward"
  }

  count = "${var.certificate_arn == "" ? 1 : 0}"
}

resource "aws_lb_listener" "concource_https" {
  load_balancer_arn = "${aws_lb.concourse.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2015-05"
  certificate_arn   = "${var.certificate_arn}"

  default_action {
    target_group_arn = "${aws_lb_target_group.concourse.arn}"
    type             = "forward"
  }

  count = "${var.certificate_arn == "" ? 0 : 1}"
}

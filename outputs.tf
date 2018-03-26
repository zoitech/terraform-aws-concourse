output "url" {
  value = "${local.external_name}"
}
output "alb_dns_name" {
  value = "${aws_lb.concourse.dns_name}"
}
output "public_ip" {
  value = "${aws_instance.ec2_linux_instance.public_ip}"
}
output "instance_id" {
  value = "${aws_instance.ec2_linux_instance.id}"
}
output "alb_name" {
  value = "${aws_lb.concourse.name}"
}

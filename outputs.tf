output "url" {
  value = "${local.external_name}"
}
output "alb_dns_name" {
  value = "${aws_lb.concourse.dns_name}"
}
output "public_ip" {
  value = "${aws_instance.ec2_docker_instance.public_ip}"
}
output "instance_id" {
  value = "${aws_instance.ec2_linux_instance.id}"
}
output "postgres_password" {
  value = "${local.postgres_password}"
}
output "concourse_password" {
  value = "${local.concourse_password}"
}

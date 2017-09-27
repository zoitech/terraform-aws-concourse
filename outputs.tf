output "url" {
  value = "http://${aws_instance.ec2_linux_instance.public_ip}:8080/teams/main/login"
}
output "public_ip" {
  value = "${aws_instance.ec2_linux_instance.public_ip}"
}
output "instance_id" {
  value = "${aws_instance.ec2_linux_instance.id}"
}

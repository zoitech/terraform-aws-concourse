data "aws_caller_identity" "current" {}

# Account
provider "aws" {
  region = "${var.aws_region}"
}

variable "aws_region" {
  description = "The AWS region to run in."
  default     = "eu-west-1"
}

variable "prefix" {
  description = "A prefix which is added to each ressource."
  default     = "prod"
}

variable "certificate_arn" {
  description = "ARN of the certificate."
  default     = ""
}

# network
variable "public_sn" {
  type        = "list"
  description = "The Public Subnets in which the LB should be created."
}

variable "private_sn" {
  type        = "list"
  description = "The Public Subnets in which the EC2 Instance should be created."
}

variable "vpc_id" {
  description = "The VPC Id in which the EC2 Instance should be created."
}

# Instance
variable "coreos_version" {
  description = "The CoreOS version to launch."
  default     = "stable-"
}

variable "instance_key_name" {
  description = "The SSH key to use for connecting to the instance."
}

variable "instance_name" {
  description = "The name of the Instance."
  default     = "concourse"
}


variable "instance_volume_size" {
  description = "Custom volume size for concourse"
  default     = "60"
}

variable "instance_sg_id" {
  type        = "list"
  description = "The Security Group ID/s which should be attached to the Instance."
}

variable "instance_size" {
  description = "The size of the Instance's disk."
  default     = "t2.medium"
}

# Loadbalancer
variable "alb_sg_id" {
  type        = "list"
  description = "The Security Group ID/s which should be attached to the Loadbalancer."
}
variable "enable_alb_access_logs" {
  description = "Turn alb access logs on or off."
  default     = false
}
variable "s3_log_bucket_name" {
  description = "Name of the logs bucket."
  default     = ""
}
variable "s3_log_bucket_Key_name" {
  description = "Name of the folder to store logs in the bucket."
  default     = ""
}
variable "lifecycle_rule_id" {
  description = "Name of the lifecyle rule id."
  default     = ""
}
variable "lifecycle_rule_enabled" {
  description = "To enable the lifecycle rule"
  default     = false
}
variable "lifecycle_rule_prefix" {
  description = "Lifecycle rule prefix."
  default     = ""
}
variable "lifecycle_rule_expiration" {
  description = "Delete log files X days after creation"
  default     = 90
}
variable "principle_account_id" {
  description = "Set principle account ID for the region"
  default     = "156460612806"
}


# Role
variable "role_policies" {
  description = "The policies which would be attached to the EC2 Role."
  type        = "list"
  default     = ["arn:aws:iam::aws:policy/AdministratorAccess"]
}

# Postgres
variable "postgres_version" {
  description = "The Postgres Version to use."
  default     = "9.5.10"
}

variable "postgres_username" {
  description = "The Username for the Postgres database."
  default     = "dbadmin"
}

variable "postgres_password" {
  description = "The Password for the Postgres database."
  default     = ""
}

variable "postgres_multiaz" {
  default = "0"
}

# Concourse
variable "concourse_version" {
  description = "The Concourse version to launch."
  default     = "3.4.1"
}

variable "concourse_username" {
  description = "The Username for the default user on the Concourse Server."
  default     = "concourse"
}

variable "concourse_password" {
  description = "The Password for the default user on the Concourse Server."
  default     = ""
}

variable "concourse_external_url" {
  description = "The external URL (including http://) of the Concourse server."
  default     = ""
}

variable "concourse_db_storage" {
  description = "Size of the DB Disk."
  default     = "100"
}

variable "concourse_db_size" {
  description = "Size of the DB Instance."
  default     = "db.t2.micro"
}

data "aws_caller_identity" "current" { }

# Account
provider "aws" {
    region = "${var.aws_region}"
}

variable "aws_region" {
  description = "The AWS region to run in."
  default     = "eu-west-1"
}

# Instance
variable "coreos_version" {
  description = "The CoreOS version to launch."
  default     = "stable-"
}
variable "instance_key_name" {
  description = "The SSH key to use for connecting to the instance."
}
variable "instance_key" {
  description = "The Private Key to connect to the Instance for configuring it."
}
variable "instance_name" {
  description = "The name of the Instance."
}
variable "instance_sg_id" {
  description = "The Security Group ID which should be attached to the Instance."
}
variable "instance_subnet_id" {
  description = "The Subnet in which the EC2 Instance should be created."
}
variable "instance_size" {
  description = "The size of the Instance's disk."
  default     = "t2.medium"
}

# Role
variable "role_name" {
  description = "The name of the EC2 Role to attach to the EC2 Instance."
  default     = "ssvc.concourse"
}
variable "role_policies" {
  description = "The policies which would be attached to the EC2 Role."
  type        = "list"
  default     = ["arn:aws:iam::aws:policy/AdministratorAccess"]
}


# Postgres
variable "postgres_version" {
  description = "The Postgres Version to use."
  default     = "9.5"
}
variable "postgres_username" {
  description = "The Username for the Postgres database."
  default     = "dbadmin"
}
variable "postgres_password" {
  description = "The Password for the Postgres database."
  default     = "replaceme!"
}


# Concourse
variable "concourse_version" {
  description = "The Concourse version to launch."
  default     = "3.4.1"
}
variable "concourse_username" {
  description = "The Username for the default user on the Concourse Server."
     default  = "concourse"
}
variable "concourse_password" {
  description = "The Password for the default user on the Concourse Server."
  default     = "concourse"
}
variable "concourse_pipeline_create" {
  description = "Defines if an initial pipeline should be created."
  default     = false
}
variable "concourse_pipeline_name" {
  description = "The Name of the initial pipeline."
  default     = "selfupdate"
}
variable "concourse_pipeline_path" {
  description = "The Path where the pipeline is defined in."
  default     = "update_pipeline"
}
variable "concourse_pipeline_yml" {
  description = "The Name of the pipeline definition."
  default     = "pipeline.yml"
}
variable "concourse_pipeline_config" {
  description = "The Name of the config file which should be used."
  default     = "config.yml"
}
variable "concourse_external_url" {
  description = "The external URL of the Concourse server."
  default     = ""
}

# Trigger for Concourse
variable "trigger" {
  description = "A trigger to use, if resources must be created before."
  default     = "none"
}

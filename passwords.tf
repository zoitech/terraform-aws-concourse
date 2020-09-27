resource "random_string" "postgres_password" {
  length  = 16
  special = false
}

resource "random_string" "concourse_password" {
  length  = 16
  special = false
}

locals {
  postgres_password  = length(var.postgres_password) == 0 ? random_string.postgres_password.result : var.postgres_password
  concourse_password = length(var.concourse_password) == 0 ? random_string.concourse_password.result : var.concourse_password
}


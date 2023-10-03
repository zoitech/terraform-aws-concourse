resource "aws_db_subnet_group" "postgres" {
  name       = "${lower(var.prefix)}-private"
  subnet_ids = var.private_sn
}

resource "aws_db_parameter_group" "concourse" {
  name   = "${var.prefix}-concourse-${var.postgres_family}"
  family = var.postgres_family
}

resource "aws_db_instance" "postgres" {
  identifier        = "${lower(var.prefix)}-concourse-db"
  allocated_storage = var.concourse_db_storage
  storage_type      = "gp2"
  engine            = "postgres"
  engine_version    = var.postgres_version
  instance_class    = var.concourse_db_size

  name                      = "concourse"
  username                  = var.postgres_username
  password                  = local.postgres_password
  db_subnet_group_name      = aws_db_subnet_group.postgres.id
  parameter_group_name      = aws_db_parameter_group.concourse.id
  multi_az                  = var.postgres_multiaz
  backup_retention_period   = 35
  maintenance_window        = "Sat:21:00-Sun:00:00"
  backup_window             = "00:00-02:00"
  vpc_security_group_ids    = [aws_security_group.RuleGroupWsIn.id]
  copy_tags_to_snapshot     = true
  snapshot_identifier       = ""
  skip_final_snapshot       = false
  final_snapshot_identifier = "LastSnap"

  #monitoring_role_arn = "${aws_iam_role.rds_monitoring.arn}"
  #monitoring_interval = "${var.db_monitor_interval}"
  apply_immediately = true

  lifecycle {
    prevent_destroy = true
  }
}

# Monitoring of DB events
resource "aws_sns_topic" "postgres" {
  name = "${lower(var.prefix)}-rds-topic"
}

resource "aws_db_event_subscription" "postgres" {
  name      = "${lower(var.prefix)}-rds-sub"
  sns_topic = aws_sns_topic.postgres.arn

  source_type = "db-instance"
  source_ids  = [aws_db_instance.postgres.id]

  # see here for further event categories
  event_categories = [
    "low storage",
  ]
}


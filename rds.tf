resource "aws_db_subnet_group" "postgres" {
  name       = "${lower(var.prefix)}-private"
  subnet_ids = var.private_sn

  tags = var.rds_tags
}

resource "aws_db_parameter_group" "concourse" {
  name   = "${var.prefix}-concourse-${var.postgres_family}"
  family = var.postgres_family

  tags = var.rds_tags
}

resource "aws_db_instance" "postgres" {
  identifier                = "${lower(var.prefix)}-concourse-db"
  allocated_storage         = var.concourse_db_storage
  storage_type              = "gp2"
  engine                    = "postgres"
  engine_version            = var.postgres_version
  instance_class            = var.concourse_db_size
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
  skip_final_snapshot       = true
  final_snapshot_identifier = "LastSnap"
  apply_immediately         = true

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [engine_version]
  }

  tags = merge({ Name = "${lower(var.prefix)}-concourse-db"}, var.rds_tags)
}

# Monitoring of DB events
resource "aws_sns_topic" "postgres" {
  name = "${lower(var.prefix)}-rds-topic"

  tags = merge({ Name = "${lower(var.prefix)}-rds-topic"}, var.sns_tags)
}

resource "aws_db_event_subscription" "postgres" {
  name      = "${lower(var.prefix)}-rds-sub"
  sns_topic = aws_sns_topic.postgres.arn

  source_type = "db-instance"
  source_ids  = [aws_db_instance.postgres.identifier]

  # see here for further event categories
  event_categories = [
    "low storage",
  ]
}


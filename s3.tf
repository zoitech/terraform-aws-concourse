data "aws_iam_policy_document" "allow_alb_loggin_access" {
  count = var.enable_alb_access_logs ? 1 : 0

  statement {
    sid    = "1"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.principle_account_id}:root"]
    }
    actions = [
      "s3:PutObject",
    ]

    resources = [
      "arn:aws:s3:::${var.s3_log_bucket_name}/${var.s3_log_bucket_Key_name}/*",
    ]
  }
}

resource "aws_s3_bucket" "log_bucket" {
  count = var.enable_alb_access_logs ? 1 : 0

  bucket = var.s3_log_bucket_name

  # lifecycle_rule {
  #   id      = var.lifecycle_rule_id      #required #default = ""
  #   enabled = var.lifecycle_rule_enabled #default = false

  #   prefix = var.lifecycle_rule_prefix #default = whole bucket

  #   expiration {
  #     days = var.lifecycle_rule_expiration #default = 90
  #   }
  # }

  tags = merge({ Name = var.s3_log_bucket_name, role = "storage" }, var.tags)
}

resource "aws_s3_bucket_lifecycle_configuration" "log_bucket" {
  count  = var.enable_alb_access_logs ? 1 : 0
  bucket = aws_s3_bucket.log_bucket[0].id

  rule {
    id     = var.lifecycle_rule_id                               #required #default = ""
    status = var.lifecycle_rule_enabled ? "Enabled" : "Disabled" #default = false
    filter {
      prefix = var.lifecycle_rule_prefix #default = whole bucket
    }
    expiration {
      days = var.lifecycle_rule_expiration #default = 90
    }
  }
}

resource "aws_s3_bucket_acl" "log_bucket" {
  count  = var.enable_alb_access_logs ? 1 : 0
  bucket = aws_s3_bucket.log_bucket[0].id
  acl    = "private"
}

resource "aws_s3_bucket_object" "concourse_alb_access_logs" {
  count   = var.enable_alb_access_logs ? 1 : 0
  bucket  = aws_s3_bucket.log_bucket[0].id
  acl     = "private"
  key     = "${var.s3_log_bucket_Key_name}/"
  content = " "
}

resource "aws_s3_bucket_policy" "log_bucket" {
  count  = var.enable_alb_access_logs ? 1 : 0
  bucket = aws_s3_bucket.log_bucket[0].id
  policy = data.aws_iam_policy_document.allow_alb_loggin_access[0].json
}


# AWS config 
provider "aws" {
  region     = "${var.aws_region}"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}" 
}

# SES
resource "aws_ses_receipt_rule_set" "base" {
  rule_set_name = "${var.ses_rule_set_name}"
}

resource "aws_ses_active_receipt_rule_set" "base" {
  rule_set_name = "${aws_ses_receipt_rule_set.base.rule_set_name}"
}

resource "aws_ses_receipt_rule" "base" {
  name          = "${var.ses_rule_name}"
  rule_set_name = "${aws_ses_receipt_rule_set.base.rule_set_name}"
  recipients    = ["${var.ses_recipient}"]
  enabled       = true
  scan_enabled  = true

  s3_action {
    position = 1
    bucket_name = "${var.s3_mail_bucket}"
  }
}

# SNS
resource "aws_sns_topic" "base" {
  name = "${var.sns_topic_name}"
}

resource "aws_sns_topic_subscription" "base" {
  topic_arn = "${aws_sns_topic.base.arn}"
  protocol  = "http"
  endpoint  = "${var.sns_topic_endpoint}"
  endpoint_auto_confirms = true
}

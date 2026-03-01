resource "aws_sns_topic" "alerts" {
  name = "wordpress-alerts"
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

resource "aws_cloudwatch_metric_alarm" "cloudwatch_alarm_application" {
  alarm_name                = "alarm_metric_application"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = 2
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 120
  statistic                 = "Average"
  threshold                 = 80
  alarm_description         = "Alarms when CPU is greater than 80$ of consumption"
  insufficient_data_actions = []
  alarm_actions             = [aws_sns_topic.alerts.arn]

  dimensions = {
    AutoScalingGroupName = var.asg_name
  }
}

resource "aws_cloudwatch_metric_alarm" "cloudwatch_alarm_jenkins" {
  alarm_name                = "alarm_metric_jenkins"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = 2
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 120
  statistic                 = "Average"
  threshold                 = 80
  alarm_description         = "Alarms when CPU is greater than 80$ of consumption"
  insufficient_data_actions = []
  alarm_actions             = [aws_sns_topic.alerts.arn]

  dimensions = {
    InstanceId = var.jenkins_id
  }
}
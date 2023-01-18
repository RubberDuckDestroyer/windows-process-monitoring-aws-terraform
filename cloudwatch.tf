resource "aws_cloudwatch_metric_alarm" "db_os_server_process" {

  alarm_name          = "process-db-os-server-dispatcher"
  alarm_description   = "Alarm is activated when the DB process ID is not found in the OS."
  namespace           = var.namespace
  metric_name         = "procstat pid"
  statistic           = "Average"
  datapoints_to_alarm = 3
  period              = 60
  evaluation_periods  = 5
  comparison_operator = "LessThanOrEqualToThreshold"
  threshold           = 0
  alarm_actions       = [module.sns_topic.topic_arn]
  ok_actions          = [module.sns_topic.topic_arn]
  dimensions = {
    InstanceId = module.aws_ec2_instance.id
    exe   = "sqlservr"
    process_name = "sqlservr.exe"
  }
  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "db_os_server_agent" {

  alarm_name          = "process-db-os-server-agent"
  alarm_description   = "Alarm is activated when the DB Agent process ID is not found in the OS."
  namespace           = var.namespace
  metric_name         = "procstat pid" 
  statistic           = "Average"
  datapoints_to_alarm = 3
  period              = 60
  evaluation_periods  = 5
  comparison_operator = "LessThanOrEqualToThreshold"
  threshold           = 0
  alarm_actions       = [module.sns_topic.topic_arn]
  ok_actions          = [module.sns_topic.topic_arn]
  dimensions = {
    InstanceId = module.aws_ec2_instance.id
    exe   = "SQLAGENT"
    process_name = "SQLAGENT.EXE"
  }
  treat_missing_data = "breaching"
}

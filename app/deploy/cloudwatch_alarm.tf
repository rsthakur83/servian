#### CloudWatch CPU Alarm 

### High CPU usage metrics Alarm
resource "aws_cloudwatch_metric_alarm" "cpu-high" {
  alarm_name          = "cpu-util-high"
  alarm_description   = "This metric monitor ec2 high cpu utilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "80"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.APP-ASG.name
  }
  alarm_actions = [aws_autoscaling_policy.agents-scale-up-cpu.arn]
  tags = {
    key   = "Name"
    value = "App ASG High CPU Usage Alarm"
  }
}

### Low CPU usage metrics Alarm
resource "aws_cloudwatch_metric_alarm" "cpu-low" {
  alarm_name          = "cpu-util-low"
  alarm_description   = "This metric monitor ec2 low cpu utilization"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "60"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.APP-ASG.name
  }
  alarm_actions = [aws_autoscaling_policy.agents-scale-down-cpu.arn]
  tags = {
    key   = "Name"
    value = "APP ASG Low CPU Usage Alarm"

  }
}

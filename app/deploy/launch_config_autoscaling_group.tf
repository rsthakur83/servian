############ LAUCH Config & Auto Scaling Group ########
resource "aws_launch_configuration" "APP-LC" {
  name                 = "APP-LC"
  depends_on           = ["aws_iam_role_policy_attachment.cw_db_policy_attach"] // "aws_security_group.APP-SG-Web"]  addressed required */
  image_id             = var.image_id
  instance_type        = var.instance-type
  iam_instance_profile = "cwdb_iam_profile"
  security_groups      = [aws_security_group.app_asg.id]
  user_data            = file("/root/project/app/deploy/userdata-asg.sh")
  lifecycle { create_before_destroy = true }
}

resource "aws_autoscaling_group" "APP-ASG" {
  name                      = "APP-ASG"
  depends_on                = ["aws_launch_configuration.APP-LC", "aws_db_instance.app_db"]
  vpc_zone_identifier       = [aws_subnet.app_subnet_1.id, aws_subnet.app_subnet_2.id]
  max_size                  = 3
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "EC2"
  desired_capacity          = 2
  force_delete              = true
  launch_configuration      = aws_launch_configuration.APP-LC.id
  lifecycle { create_before_destroy = true }

  tag {
    key                 = "Name"
    value               = "WebApp"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = aws_autoscaling_group.APP-ASG.id
  alb_target_group_arn   = aws_lb_target_group.APP-TargetGroup.arn
}

##Auto scaling Policy for APP-ASG

resource "aws_autoscaling_policy" "agents-scale-up-cpu" {
  name                   = "agents-scale-up-cpu"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.APP-ASG.name
}

resource "aws_autoscaling_policy" "agents-scale-down-cpu" {
  name                   = "agents-scale-down-cpu"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.APP-ASG.name
}

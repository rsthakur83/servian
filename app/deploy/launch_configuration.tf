##### Launch Configuration
resource "aws_launch_configuration" "APP-LC" {
  name                 = "APP-LC"
  depends_on           = ["aws_iam_role_policy_attachment.cw_db_policy_attach"]
  image_id             = var.image_id
  instance_type        = var.instance-type
  iam_instance_profile = "cwdb_iam_profile"
  security_groups      = [aws_security_group.app_asg.id]
  user_data            = file("/root/project/app/deploy/userdata-asg.sh")
  lifecycle { create_before_destroy = true }
}

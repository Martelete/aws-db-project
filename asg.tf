#########################
## AWS Launch Template ##
#########################
resource "aws_launch_template" "ec2_asg" {
  name_prefix            = "cint_lt"
  image_id               = var.ami_image_id
  instance_type          = var.instance_type
  user_data              = filebase64("${path.module}/script/user_data.sh")
  vpc_security_group_ids = [aws_security_group.instance_sg.id]

  iam_instance_profile {
    name = "instanceProfileSSM"
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      delete_on_termination = true
      encrypted             = true
      volume_type           = "gp3"
      volume_size           = 20
    }
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "cint_demo_instances"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

###########################
## AWS Autoscaling Group ##
###########################

resource "aws_autoscaling_group" "asg" {

  name                      = "cint_asg"
  min_size                  = 2
  max_size                  = 2
  desired_capacity          = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  target_group_arns         = [aws_lb_target_group.asg_tg.arn]

  launch_template {
    id      = aws_launch_template.ec2_asg.id
    version = "$Latest"
  }

  vpc_zone_identifier = aws_subnet.public.id

  depends_on = [
    aws_lb_listener.asg_listener
  ]
}

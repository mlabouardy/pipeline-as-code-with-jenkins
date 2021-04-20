// Swarm workers resource template
data "template_file" "swarm_worker_user_data" {
  template = file("scripts/join-swarm.tpl")

  vars = {
    swarm_discovery_bucket = var.swarm_discovery_bucket
    swarm_name             = var.environment
    swarm_role             = "worker"
  }
}

// Swarm workers launch configuration
resource "aws_launch_configuration" "workers_launch_conf" {
  name                 = "workers_config_${var.environment}"
  image_id             = data.aws_ami.docker.id
  instance_type        = var.worker_instance_type
  key_name             = var.key_name
  security_groups      = [aws_security_group.swarm_sg.id]
  user_data            = data.template_file.swarm_worker_user_data.rendered
  iam_instance_profile = aws_iam_instance_profile.swarm_profile.id

  root_block_device {
    volume_type = "gp2"
    volume_size = 20
  }

  lifecycle {
    create_before_destroy = true
  }
}

// ASG Swarm workers
resource "aws_autoscaling_group" "swarm_workers" {
  name                 = "workers_asg_${var.environment}"
  launch_configuration = aws_launch_configuration.workers_launch_conf.name
  vpc_zone_identifier  = [for subnet in aws_subnet.private_subnets: subnet.id]
  min_size             = 2
  max_size             = 5

  depends_on = [aws_autoscaling_group.swarm_workers]

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "worker_${var.environment}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Author"
    value               = var.author
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }
}

// Workers scale out
resource "aws_cloudwatch_metric_alarm" "high_cpu_swarm_workers_alarm" {
  alarm_name          = "high-cpu-swarm-workers-alarm-${var.environment}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.swarm_workers.name
  }

  alarm_description = "This metric monitors workers cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.scale_out_swarm_workers.arn]
}

resource "aws_autoscaling_policy" "scale_out_swarm_workers" {
  name                   = "scale-out-swarm-workers-${var.environment}"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.swarm_workers.name
}

// Workers scale In
resource "aws_cloudwatch_metric_alarm" "low_cpu_swarm_workers" {
  alarm_name          = "low-cpu-swarm-workers-alarm-${var.environment}"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "20"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.swarm_workers.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.scale_in_swarm_workers.arn]
}

resource "aws_autoscaling_policy" "scale_in_swarm_workers" {
  name                   = "scale-in-swarm-workers-cpu-${var.environment}"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.swarm_workers.name
}
output "asg_name" {
  value = aws_autoscaling_group.asg.name
}

output "lb_endpoint" {
  value = aws_lb.asg_lb.dns_name
}

output "db_endpoint" {
  value = aws_db_instance.db_instance.address
}

output "passwords" {
  value     = random_password.password.result
  sensitive = true
}
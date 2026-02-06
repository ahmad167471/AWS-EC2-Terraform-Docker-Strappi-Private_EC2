output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}

output "private_ec2_id" {
  value = aws_instance.private_ec2.id
}

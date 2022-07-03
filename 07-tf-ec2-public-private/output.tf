output "aws_security_group_id" {
  value = aws_security_group.security_group.id
}

output "aws_public_instance_public_ip" {
  value = aws_instance.public_instance[0].public_ip
}
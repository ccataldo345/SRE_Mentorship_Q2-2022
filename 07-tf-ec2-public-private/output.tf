output "aws_public_instance_public_ip" {
  value = aws_instance.public_instance[0].public_ip
}

output "aws_private_instance_private_ip" {
  value = aws_instance.private_instance[0].private_ip
}

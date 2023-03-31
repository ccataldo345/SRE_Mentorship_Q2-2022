# output "aws_ami_id" {
#     value = data.aws_ami.latest-amazon-linux-image.id
# }

output "ec2_public_ip" {
  value = module.myapp-server.instance.public_ip
}

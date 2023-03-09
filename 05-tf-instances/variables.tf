# variable "aws_key_pair" {
#   default = "~/aws/aws_keys/default-ec2.pem"
# }

variable "aws_key_pair" {
  default = "./tf-key-pair.pem"
}


# ERROR:
# Error: creating EC2 Instance: InvalidKeyPair.NotFound: The key pair 'default-ec2' does not exist
# │      status code: 400, request id ...
# START:
# - comment out: 
#   key_name = "default-ec2" (main.tf)
#   variable "aws_key_pair" {
#       default = "~/aws/aws_keys/default-ec2.pem"
#     } (variables.tf)
# - AWS > EC2 > Key pairs > Create Key Pair > "default-ec2".pem
# - cd Downloads > mv default-ec2.pem ~/aws/aws_keys/default-ec2.pem
# - uncomment and terraform apply 
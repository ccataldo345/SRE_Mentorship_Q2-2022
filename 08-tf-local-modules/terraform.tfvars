AWS_REGION           = "us-east-1"
vpc_cidr_block       = "10.0.0.0/16"
subnet_cidr_block    = "10.0.10.0/24"
avail_zone           = "us-east-1b"
env_prefix           = "dev"
my_ip                = "165.225.207.46/32" # curl -s ipinfo.io | grep "ip\""
instance_type        = "t2.micro"
public_key_location  = "~/.ssh/id_rsa.pub"
private_key_location = "~/.ssh/id_rsa"
image_name           = "amzn2-ami-hvm-*-x86_64-gp2"

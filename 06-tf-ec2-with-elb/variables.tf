variable "aws_key_pair" {
  default = "./tf-key-pair.pem"
}

# SSH into EC2s:
# terraform show | grep " public_ip"
# curl http://<public_ip>
# ssh -i ./tf-key-pair.pem ec2-user@<public_ip>

# Check Load Balancer:
# AWS > EC2 > Load Balancers: "DNS name"
# ts | grep " dns_name" (e.g. >>> dns_name = "elb-173210405.us-east-1.elb.amazonaws.com")
# curl <dns_name>
# curl <dns_name>
# curl <dns_name>
# curl <dns_name>
# curl <dns_name>
# >>> should give different public hostnames, e.g.: 
  # Virtual Server link: ec2-3-219-218-255.compute-1.amazonaws.com
  # Virtual Server link: ec2-52-72-30-33.compute-1.amazonaws.com

environment   = "dev"
instance_type = "t3.micro"
monitoring_instance_type = "t3.small"

vpc_cidr_block = "10.0.0.0/16"
public_subnets = ["10.0.1.0/24"]

owner            = "gtopaloglu"
ssh_allowed_cidr = "176.236.67.138/32" # curl -s https://checkip.amazonaws.com
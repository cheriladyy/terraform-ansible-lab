environment   = "prod"
instance_type = "t3.small"

vpc_cidr_block = "10.1.0.0/16"
public_subnets = ["10.1.1.0/24"]

owner            = "gtopaloglu"
ssh_allowed_cidr = "88.241.82.28/32" # curl -s https://checkip.amazonaws.com

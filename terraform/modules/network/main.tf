data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  availability_zones = length(var.availability_zones) > 0 ? var.availability_zones : data.aws_availability_zones.available.names
}

resource "aws_internet_gateway" "main" {
  vpc_id = var.vpc_id

  tags = {
    Name = "igw-${var.project}"
  }
}

resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)
  vpc_id                  = var.vpc_id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = local.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-${var.project}-${count.index + 1}"
  }
}

# Route Tables
resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  tags = {
    Name = "public-route-table-${var.project}"
  }
}

resource "aws_route" "ig_route" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table" "private" {
  count  = length(var.private_subnets)
  vpc_id = var.vpc_id

  tags = {
    Name = "private-route-table-${var.environment}-${count.index + 1}"
  }
}

# Associate the public subnets with the public route table
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

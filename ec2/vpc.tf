resource "aws_vpc" "prod-vpc" {
  cidr_block           = var.vpc_cidr[0]
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
}

resource "aws_subnet" "prod-subnet-public-1" {
  vpc_id                  = aws_vpc.prod-vpc.id
  cidr_block              = var.public_subnet_cidr[0]
  map_public_ip_on_launch = true # This is what makes it a public subnet
}

resource "aws_subnet" "prod-subnet-private-1" {
  vpc_id                  = aws_vpc.prod-vpc.id
  cidr_block              = var.private_subnet_cidr[0]
  map_public_ip_on_launch = false
}

resource "aws_vpc" "dev-vpc" {
  cidr_block           = var.vpc_cidr[1]
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
}

resource "aws_subnet" "dev-subnet-public-1" {
  vpc_id                  = aws_vpc.dev-vpc.id
  cidr_block              = var.public_subnet_cidr[1]
  map_public_ip_on_launch = true # This is what makes it a public subnet
}

resource "aws_subnet" "dev-subnet-private-1" {
  vpc_id                  = aws_vpc.dev-vpc.id
  cidr_block              = var.private_subnet_cidr[1]
  map_public_ip_on_launch = false
}

# Create VPC peering connection from dev vpc to prod vpc

resource "aws_vpc_peering_connection" "vpc_peering" {
  peer_vpc_id = aws_vpc.prod-vpc.id
  vpc_id      = aws_vpc.dev-vpc.id
  auto_accept = true
}

# Accept VPC peering connection in prod vpc
resource "aws_vpc_peering_connection_accepter" "accepter" {
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
  auto_accept               = true
}

# Create vpc peering routes in RT
 resource "aws_route" "route_to_prod_private_crt" {
   route_table_id         = aws_route_table.prod-private-crt.id
   destination_cidr_block = aws_vpc.dev-vpc.cidr_block
   vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
}

 resource "aws_route" "route_to_dev_private_crt" {
   route_table_id         = aws_route_table.dev-private-crt.id
  destination_cidr_block = aws_vpc.prod-vpc.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
}



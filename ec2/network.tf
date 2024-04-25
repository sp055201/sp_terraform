# prod

# Add internet gateway
resource "aws_internet_gateway" "prod-igw" {
  vpc_id = aws_vpc.prod-vpc.id
}

# Public routes
resource "aws_route_table" "prod-public-crt" {
  vpc_id = aws_vpc.prod-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.prod-igw.id
  }
}
resource "aws_route_table_association" "prod-crta-public-subnet-1" {
  subnet_id      = aws_subnet.prod-subnet-public-1.id
  route_table_id = aws_route_table.prod-public-crt.id
}

# Private routes
resource "aws_route_table" "prod-private-crt" {
  vpc_id = aws_vpc.prod-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.prod-nat-gateway.id
  }
}
resource "aws_route_table_association" "prod-crta-private-subnet-1" {
  subnet_id      = aws_subnet.prod-subnet-private-1.id
  route_table_id = aws_route_table.prod-private-crt.id
}

# NAT Gateway to allow private subnet to connect out the way
resource "aws_eip" "prod_nat_gateway" {
  domain = "vpc"
}
resource "aws_nat_gateway" "prod-nat-gateway" {
  allocation_id = aws_eip.prod_nat_gateway.id
  subnet_id     = aws_subnet.prod-subnet-public-1.id

  # To ensure proper ordering, add Internet Gateway as dependency
  depends_on = [aws_internet_gateway.prod-igw]
}

# Security Group
resource "aws_security_group" "ssh-allowed-prod" {
  vpc_id = aws_vpc.prod-vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# dev

# Add internet gateway
resource "aws_internet_gateway" "dev-igw" {
  vpc_id = aws_vpc.dev-vpc.id
}

# Public routes
resource "aws_route_table" "dev-public-crt" {
  vpc_id = aws_vpc.dev-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev-igw.id
  }
}
resource "aws_route_table_association" "dev-crta-public-subnet-1" {
  subnet_id      = aws_subnet.dev-subnet-public-1.id
  route_table_id = aws_route_table.dev-public-crt.id
}

# Private routes
resource "aws_route_table" "dev-private-crt" {
  vpc_id = aws_vpc.dev-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.dev-nat-gateway.id
  }
}
resource "aws_route_table_association" "dev-crta-private-subnet-1" {
  subnet_id      = aws_subnet.dev-subnet-private-1.id
  route_table_id = aws_route_table.dev-private-crt.id
}

# NAT Gateway to allow private subnet to connect out the way
resource "aws_eip" "dev_nat_gateway" {
  domain = "vpc"
}
resource "aws_nat_gateway" "dev-nat-gateway" {
  allocation_id = aws_eip.dev_nat_gateway.id
  subnet_id     = aws_subnet.dev-subnet-public-1.id

  # To ensure proper ordering, add Internet Gateway as dependency
  depends_on = [aws_internet_gateway.dev-igw]
}

# Security Group
resource "aws_security_group" "ssh-allowed-dev" {
  vpc_id = aws_vpc.dev-vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"	
  tags = {
    Name = "EKS VPC"
    Environment = var.environment
    "kubernetes.io/cluster/mainCluster" = "shared"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_subnet" "public_subnet1" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-west-1a"
  tags = {
    Name = "EKS VPC Public Subnet 1"
    Environment = var.environment
  }
}

resource "aws_subnet" "public_subnet2" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-west-1c"
  tags = {
    Name = "EKS VPC Public Subnet 1"
    Environment = var.environment
  }
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.main.id
  subnet_id     = aws_subnet.public_subnet1.id
  depends_on    = [aws_internet_gateway.main]
}

resource "aws_eip" "main" {
   depends_on    = [aws_internet_gateway.main]
}

resource "aws_subnet" "private_subnet1" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-west-1a"
  tags = {
    Name = "EKS VPC Private Subnet 1"
    Environment = var.environment
    "kubernetes.io/cluster/mainCluster" = "shared"
    "kubernetes.io/role/internal-elb" = 1
    
  }
}

resource "aws_subnet" "private_subnet2" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-west-1c"
  tags = {
    Name = "EKS VPC Private Subnet 2"
    Environment = var.environment
    "kubernetes.io/cluster/mainCluster" = "shared"
    "kubernetes.io/role/internal-elb" = 1
  }
}

resource "aws_route_table" "default" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.main.id
  }

}

resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.private_subnet1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.private_subnet1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "public1" {
  subnet_id = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.default.id
}

resource "aws_route_table_association" "public2" {
  subnet_id = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.default.id
}

resource "aws_security_group" "main" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

    ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
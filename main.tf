provider "aws" {
  region = "ap-south-1"
}


resource "aws_instance" "terraform-instance-1" {
  ami           = "ami-0cc9838aa7ab1dce7"
  instance_type = "t2.micro"
  key_name      = "docker-pipeline"
  tags = {
    Name  = "myvpc-terraform"
  }
  availability_zone = "ap-south-1a"
}


resource "aws_vpc" "terraform-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "my-vpc"
  }
}

resource "aws_subnet" "terraform-subnet" {
  vpc_id     = aws_vpc.terraform-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "My-public-subnet-1a"
  }
}

resource "aws_subnet" "terraform-subnet-1" {
  vpc_id     = aws_vpc.terraform-vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-south-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "My-public-subnet-1b"
  }
}

resource "aws_internet_gateway" "terraform-igw" {
  vpc_id = aws_vpc.terraform-vpc.id
  tags = {
    Name = "my-igw"
  }
}

resource "aws_route_table" "terraform-pub-rt" {
  vpc_id = aws_vpc.terraform-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform-igw.id
  }

  tags = {
    Name = "my-public-rt"
  }
}

resource "aws_route_table_association" "terraform-subnet-association" {
  subnet_id      = aws_subnet.terraform-subnet.id
  route_table_id = aws_route_table.terraform-pub-rt.id
}

resource "aws_route_table_association" "terraform-subnet-association-1" {
  subnet_id      = aws_subnet.terraform-subnet-1.id
  route_table_id = aws_route_table.terraform-pub-rt.id
}

resource "aws_security_group" "terraform-sg" {
  vpc_id      = aws_vpc.terraform-vpc.id

  tags = {
    Name = "my-sg-traffic"
  }
}

resource "aws_vpc_security_group_ingress_rule" "terraform-ingress-rule" {
  security_group_id = aws_security_group.terraform-sg.id
  cidr_ipv4         = aws_vpc.terraform-vpc.cidr_block
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "terraform-ingress-rule-1" {
  security_group_id = aws_security_group.terraform-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all portsip_protocol       = "
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.terraform-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}


resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.terraform-sg.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_instance" "terraform-instance-2" {
  ami           = "ami-001843b876406202a"
  instance_type = "t2.micro"
  key_name      = "linuxnew"
  subnet_id = aws_subnet.terraform-subnet.id
  vpc_security_group_ids = [ aws_security_group.terraform-sg.id ]
  tags = {
    Name  = "dinu-vpcinstance-1"
  }
}

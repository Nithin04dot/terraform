resource "aws_instance" "Ec2_instance" {
  subnet_id = aws_subnet.subnet.id
  vpc_security_group_ids = [ aws_security_group.Security_group.id ]
  ami           = "ami-037774efca2da0726"
  instance_type = "t2.micro"
  associate_public_ip_address = true

  tags = {
    Name = "Ec2_instance"
  }
}

resource "aws_vpc" "vpc" {
  cidr_block  = "10.0.0.0/16"
  
  tags = {
    Name = "vpc"
}
}

resource "aws_subnet" "subnet" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "igw"
  }
}

resource "aws_route_table" "route" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "route"
  }
}


resource "aws_route_table_association" "Subnet_association" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.route.id
}


resource "aws_security_group" "Security_group" {
  vpc_id = aws_vpc.vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
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
}



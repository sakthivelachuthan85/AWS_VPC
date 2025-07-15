#1.create vpc
resource "aws_vpc" "vpc_1" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "${var.client_name}-vpc_01"
    Environment = "${var.environment}"
    ManagedBy = "${var.managed_by}"
  }
}

#2.create internet gateway
resource "aws_internet_gateway" "igw_1" {
  vpc_id = aws_vpc.vpc_1.id

    tags = {
    Name = "${var.client_name}-igw_1"
    Environment = "${var.environment}"
    ManagedBy = "${var.managed_by}"
  }
}

#3.create public subnets
resource "aws_subnet" "pub_subnet_1" {
  vpc_id     = aws_vpc.vpc_1.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "${var.client_name}-pub_subnet_1"
    Environment = "${var.environment}"
    ManagedBy = "${var.managed_by}"
  }
}

#4.create private subnets
resource "aws_subnet" "pri_subnet_1" {
  vpc_id     = aws_vpc.vpc_1.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "${var.client_name}-pri_subnet_1"
    Environment = "${var.environment}"
    ManagedBy = "${var.managed_by}"
  }
}
#5.create public route table
resource "aws_route_table" "pub_rt1" {
  vpc_id = aws_vpc.vpc_1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_1.id
  }
  tags = {
    Name = "${var.client_name}-pub_rt1"
    Environment = "${var.environment}"    
    ManagedBy = "${var.managed_by}"
  }
}

#6.create private route table
resource "aws_route_table" "pri_rt1" {
  vpc_id = aws_vpc.vpc_1.id

  tags = {
    Name = "${var.client_name}-pri_rt1"
    Environment = "${var.environment}"
    ManagedBy = "${var.managed_by}" 
  }
}

#7.create public subnet association
resource "aws_route_table_association" "pub_subnet_assoc_1" {
  subnet_id      = aws_subnet.pub_subnet_1.id
  route_table_id = aws_route_table.pub_rt1.id
}
#8.create private subnet association
resource "aws_route_table_association" "pri_subnet_assoc_1" {
  subnet_id      = aws_subnet.pri_subnet_1.id
  route_table_id = aws_route_table.pri_rt1.id
}

#9.create security group

resource "aws_security_group" "sec_group1" {
  name        = "${var.client_name}-sec_group1"
  description = "Security group for web and db servers"
  vpc_id      = aws_vpc.vpc_1.id

# ingress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["aws_vpc.vpc_1.cidr_block"]

#   }

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.client_name}-sec_group1"
    Environment = "${var.environment}"
    ManagedBy = "${var.managed_by}" 
  }
}

#10.create ec2 web
resource "aws_instance" "web_server" {
  ami           = "ami-020cba7c55df1f615" # Example AMI, replace with a valid one
  instance_type = var.my_instance_type
  subnet_id     = aws_subnet.pub_subnet_1.id
  security_groups = [aws_security_group.sec_group1.id]

  tags = {
    Name        = "${var.client_name}-web-server"
    Environment = var.environment
    ManagedBy   = var.managed_by
  }
}

#11.create ec2 -DB
resource "aws_instance" "db_server" {
  ami           = "ami-020cba7c55df1f615" # Example AMI, replace with a valid one
  instance_type = var.my_instance_type
  subnet_id     = aws_subnet.pri_subnet_1.id
  security_groups = [aws_security_group.sec_group1.id]

  tags = {
    Name        = "${var.client_name}-db-server"
    Environment = var.environment
    ManagedBy   = var.managed_by  
  }
}

      

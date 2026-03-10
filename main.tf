# step 1: configure a provider   
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}
#step 2 : configure vpc
resource "aws_vpc" "myvpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "my_vpc_bootcamp"
  }
}
# step 3 : create public subnet
resource "aws_subnet" "mypub" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "pubsub_bootcamp"
  } 
}
  # step 4 : create internet gateway
  resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "igw_bootcamp"
  }
}
# Step 5 : create route table   
resource "aws_route_table" "pubRT" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "pubRT_bootcamp"
  }
}
# Step 6 : associate route table with public subnet
resource "aws_route_table_association" "sub" {
  subnet_id      = aws_subnet.mypub.id
  route_table_id = aws_route_table.pubRT.id
}
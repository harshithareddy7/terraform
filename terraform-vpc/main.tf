provider "aws" {
  region = "us-east-2"
}

resource "aws_vpc" "main"{
    cidr_block=var.vpc_cidr
    tags={
        Name="tf-main"
    }
}

resource "aws_subnet" "publicsubnetA" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.publicsubnetA_cidr
  availability_zone="us-east-2a"

  tags = {
    Name = "tf-publicsubnetAsubnetA"
  }
}

resource "aws_subnet" "publicsubnetB"{
    vpc_id=aws_vpc.main.id
    cidr_block=var.publicsubnetB_cidr
    availability_zone="us-east-2b"

    tags={
        Name="tf-publicsubnetBsubnetB"
    }
}

resource "aws_internet_gateway" "igw"{

    vpc_id=aws_vpc.main.id

    tags={
        Name="tf-igw"
    }
}

resource "aws_route_table" "publicroutetable"{
    vpc_id=aws_vpc.main.id

    route{
        cidr_block="0.0.0.0/0"
        gateway_id=aws_internet_gateway.igw.id
            }
    tags={
        Name="tf-routetable"
    }
}

resource "aws_route_table_association" "publicassocation"{
    subnet_id=aws_subnet.publicsubnetA.id
    route_table_id=aws_route_table.publicroutetable.id
}

# lets create a VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr
  instance_tenancy = var.instance_tenancy

  tags = var.tag_overlay
}

# lets create the Internet Gateway
resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "${var.tag_overlay.Name}-igw"
  }
  
}

# lets create the public subnet
resource "aws_subnet" "main_public_subnet" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = var.public_subnet_cidr
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  
  tags = {
    Name = "${var.tag_overlay.Name}-public-subnet"
  }
}

# lets create the private subnet
resource "aws_subnet" "main_private_subnet" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = var.private_subnet_cidr
  availability_zone = "us-east-1b"

  tags = {
    Name = "${var.tag_overlay.Name}-private-subnet"
  }
}

# lets create Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = var.tag_overlay
}

# lets create NAT Gateway
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id = aws_subnet.main_public_subnet.id

  depends_on = [aws_internet_gateway.main_igw, aws_eip.nat_eip]

  tags = {
    Name = "${var.tag_overlay["Name"]}-nat"
  }
}

# lets create the public route table
resource "aws_route_table" "publicRT" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "${var.tag_overlay["Name"]}-public-rt"
  }
}

# Add route to IGW in Public Route Table
resource "aws_route" "public_internet_gateway" {
  route_table_id = aws_route_table.publicRT.id
  destination_cidr_block = var.pubrt_cidrblock
  gateway_id = aws_internet_gateway.main_igw.id
}

# Associate Public Route Table with Public Subnet
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.main_public_subnet.id
  route_table_id = aws_route_table.publicRT.id
}

# Create Private Route Table
resource "aws_route_table" "privateRT" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "${var.tag_overlay["Name"]}-private-rt"
  }
}

# Add route to NAT Gateway in Private Route Table
resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.privateRT.id
  destination_cidr_block = var.privrt_cidrblock
  nat_gateway_id         = aws_nat_gateway.nat_gw.id
}

# Associate Private Route Table with Private Subnet
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.main_private_subnet.id
  route_table_id = aws_route_table.privateRT.id
}


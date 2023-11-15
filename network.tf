######### 01 vpc subnet ########
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = "${var.prefix}-vpc"
  }  
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "pub_sbn_a" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.pub_a_cidr
  availability_zone = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.prefix}-pubsbn-a"
  }
}

resource "aws_subnet" "pub_sbn_c" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.pub_c_cidr
  availability_zone = data.aws_availability_zones.available.names[2]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.prefix}-pubsbn-c"
  }
}

resource "aws_subnet" "pri_sbn_a" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.pri_a_cidr
  availability_zone = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.prefix}-prisbn-a"
  }
}

resource "aws_subnet" "pri_sbn_c" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.pri_c_cidr
  availability_zone = data.aws_availability_zones.available.names[2]
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.prefix}-prisbn-c"
  }
}

resource "aws_subnet" "dbpri_sbn_a" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.dbpri_a_cidr
  availability_zone = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.prefix}-db-prisbn-a"
  }
}

resource "aws_subnet" "dbpri_sbn_c" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.dbpri_c_cidr
  availability_zone = data.aws_availability_zones.available.names[2]
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.prefix}-db-prisbn-c"
  }
}

######## 02 igw , nat gw , eip #########
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.prefix}-igw"
  }
}

resource "aws_nat_gateway" "example" {
  allocation_id = aws_eip.example.id
  subnet_id     = aws_subnet.pub_sbn_a.id
  
  tags = {
    Name = "${var.prefix}-natgw"
  }
}

resource "aws_eip" "example" {
  domain   = "vpc"
}

######## 03 public route table ########
resource "aws_route_table" "pub_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.prefix}-pub-rt"
  }
}

resource "aws_route_table_association" "pub_a" {
  subnet_id      = aws_subnet.pub_sbn_a.id
  route_table_id = aws_route_table.pub_rt.id
}

resource "aws_route_table_association" "pub_c" {
  subnet_id      = aws_subnet.pub_sbn_c.id
  route_table_id = aws_route_table.pub_rt.id
}

######## 04 private web route table ########
resource "aws_route_table" "pri_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.example.id
  }

  tags = {
    Name = "${var.prefix}-pri-rt"
  }
}

resource "aws_route_table_association" "pri_a" {
  subnet_id      = aws_subnet.pri_sbn_a.id
  route_table_id = aws_route_table.pri_rt.id
}

resource "aws_route_table_association" "pri_c" {
  subnet_id      = aws_subnet.pri_sbn_c.id
  route_table_id = aws_route_table.pri_rt.id
}

######## 03 private db route table ########
resource "aws_route_table" "pri_db_rt" {
  vpc_id = aws_vpc.vpc.id

#DB subnet은 아웃바운드 인터넷 연결 안함
  route {
    cidr_block = var.vpc_cidr
    gateway_id = "local"
  }

  tags = {
    Name = "${var.prefix}-pridb-rt"
  }
}

resource "aws_route_table_association" "dbpri_a" {
  subnet_id      = aws_subnet.dbpri_sbn_a.id
  route_table_id = aws_route_table.pri_db_rt.id
}

resource "aws_route_table_association" "dbpri_c" {
  subnet_id      = aws_subnet.dbpri_sbn_c.id
  route_table_id = aws_route_table.pri_db_rt.id
}
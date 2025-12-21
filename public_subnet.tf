resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.vpc-main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_gw.id
  }
  tags = {
    Name = "cloud-ctf-public-route"
    Project = "cloud-ctf"
  }
}
resource "aws_route_table_association" "public_route_link"{
  subnet_id = aws_subnet.public.id
  route_table_id = aws_route_table.public_route.id
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.vpc-main.id
  cidr_block = "10.0.0.0/28"
  map_public_ip_on_launch = true
  tags = {
    Name    = "cloud-ctf-subnet-public"
    Project = "cloud-ctf"
  }
}
resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.vpc-main.id
  tags = {
    Name    = "cloud-ctf-private-route"
    Project = "cloud-ctf"
  }
}
resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.vpc-main.id
  cidr_block = "10.0.0.128/28"
  tags = {
    Name    = "cloud-ctf-subnet-private"
    Project = "cloud-ctf"
  }
}
resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.lab.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name    = "cloud-ctf-private-rt"
    Project = "cloud-ctf"
  }
}

resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private_route.id
}
resource "aws_eip" "nat_eip" {

}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name    = "cloud-ctf-nat-gateway"
    Project = "cloud-ctf"
  }
}

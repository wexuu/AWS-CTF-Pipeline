resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.vpc-main.id
  tags = {
    Name    = "cloud-ctf-private-route"
    Project = "cloud-ctf"
  }
}
resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.vpc-main.id
  cidr_block              = "10.0.0.128/28"
  map_public_ip_on_launch = true
  tags = {
    Name    = "cloud-ctf-subnet-private"
    Project = "cloud-ctf"
  }
}
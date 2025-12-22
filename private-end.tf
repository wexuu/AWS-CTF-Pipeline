data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_instance" "web-private" {
  ami                         = data.aws_ami.al2023.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.private.id
  vpc_security_group_ids      = [aws_security_group.private_web_sg.id]
  key_name                    = "cloud-ctf-key"
  user_data_replace_on_change = true
  user_data                   = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y nginx
    yum install -y docker
    service docker start
    docker pull bkimminich/juice-shop
    docker run -d -p 80:3000 bkimminich/juice-shop
    EOF

  tags = {
    Name    = "cloud-ctf-web-private"
    Project = "cloud-ctf"
  }
}

resource "aws_security_group" "private_web_sg" {
  vpc_id = aws_vpc.vpc-main.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.my_ip_cidr]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip_cidr]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
output "web_private_ip" {
  value = aws_instance.web_private.public_ip
}

output "web_private_url" {
  value = "http://${aws_instance.web_private.public_ip}"
}

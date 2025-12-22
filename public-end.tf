data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_instance" "web_public" {
  ami                         = data.aws_ami.al2023.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.public_web_sg.id]
  key_name                    = "cloud-ctf-key"
  user_data_replace_on_change = true
  user_data                   = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y nginx
    systemctl enable nginx
    systemctl start nginx
              cat > /usr/share/nginx/html/index.html << 'HTML'
              <html>
                <head><title>Cloud CTF Lab</title></head>
                <body>
                  <h1>Cloud CTF - test</h1>
                </body>
              </html>
              HTML
              EOF

  tags = {
    Name    = "cloud-ctf-web"
    Project = "cloud-ctf"
  }
}

resource "aws_security_group" "public_web_sg" {
  vpc_id = aws_vpc.vpc-main.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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
output "web_public_ip" {
  value = aws_instance.web_public.public_ip
}

output "web_public_url" {
  value = "http://${aws_instance.web_public.public_ip}"
}

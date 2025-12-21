data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_instance" "web" {
  ami                    = data.aws_ami.al2023.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  #associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y nginx
    systemctl enable nginx
    systemctl start nginx

              cat > /usr/share/nginx/html/index.html << 'HTML'
              <html>
                <head><title>Cloud CTF Lab</title></head>
                <body>
                  <h1>Cloud CTF Lab - public web</h1>
                </body>
              </html>
              HTML
              EOF

  tags = {
    Name    = "cloud-ctf-web"
    Project = "cloud-ctf"
  }
}

output "web_public_ip" {
  value = aws_instance.web.public_ip
}

output "web_public_url" {
  value = "http://${aws_instance.web.public_ip}"
}

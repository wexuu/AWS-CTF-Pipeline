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
                  <h1>Cloud CTF - test1</h1>
                </body>
              </html>
HTML

            cat > /etc/nginx/conf.d/juice-shop.conf << 'NGINX'
              server {
                  listen 80;
                  server_name _;

                  location / {
                      root   /usr/share/nginx/html;
                      index  index.html;
                  }

                  location /juice-shop/ {
                      proxy_pass         http://${aws_instance.web_private.private_ip}:3000/;
                      proxy_http_version 1.1;
                      proxy_set_header   Host $host;
                      proxy_set_header   X-Real-IP $remote_addr;
                      proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
                      proxy_set_header   X-Forwarded-Proto $scheme;
                  }
              }
NGINX
            systemctl restart nginx
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

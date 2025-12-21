variable "my_ip_cidr" {
  type    = string
  default = "0.0.0.0/32"
}

variable "cloud-ctf-ec2-kuba-ssh-public-path" {
  type    = string
  default = "${path.module}/keys/cloud-ctf-ec2-kuba.pub"
}

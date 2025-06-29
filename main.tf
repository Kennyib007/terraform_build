resource "aws_vpc" "kennytf" {
  cidr_block           = "10.123.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "dev"
  }
}

resource "aws_subnet" "kennytf_public_subnet" {
  vpc_id                  = aws_vpc.kennytf.id
  cidr_block              = "10.123.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name = "dev_pub_sub"
  }
}

resource "aws_internet_gateway" "kennytf_igw" {
  vpc_id = aws_vpc.kennytf.id

  tags = {
    Name = "dev_igw"
  }
}

resource "aws_route_table" "kennytf_pubrt" {
  vpc_id = aws_vpc.kennytf.id

  tags = {
    Name = "dev_pub_rt"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.kennytf_pubrt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.kennytf_igw.id


}
resource "aws_route_table_association" "kennytf_pubrt_assoc" {
  subnet_id      = aws_subnet.kennytf_public_subnet.id
  route_table_id = aws_route_table.kennytf_pubrt.id
}

resource "aws_security_group" "kennytf_sg" {
  name        = "dev_sg"
  description = "dev security group"
  vpc_id      = aws_vpc.kennytf.id

  tags = {
    Name = "dev_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow" {
  security_group_id = aws_security_group.kennytf_sg.id
  cidr_ipv4         = "<trustedip/allowed ip>"
  from_port         = 0
  ip_protocol       = "-1"
  to_port           = 0
}


resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.kennytf_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_key_pair" "kennytf_auth" {
  key_name   = "kennytf-key"
  public_key = file("~/.ssh/kennytfkey.pub")
}

resource "aws_instance" "social_instance" {
  ami                    = data.aws_ami.aws_linux_server.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.kennytf_auth.id
  vpc_security_group_ids = [aws_security_group.kennytf_sg.id]
  subnet_id              = aws_subnet.kennytf_public_subnet.id
  user_data              = file("userdata.tpl")

  root_block_device {
    volume_size = 10
  }

  tags = {
    Name = "Dev001"
  }

  # Provisioners are typically last options, configurations should rather be done with ansible and other config tools
  provisioner "local-exec" {
    command = templatefile("${var.host_os}-ssh-config.tpl", {
      hostname     = self.public_ip,
      user         = "ec2-user",
      identityfile = "~/.ssh/kennytfkey"
    })
    interpreter = var.host_os == "windows" ? ["Powershell", "-Command"] : ["bash", "-c"] 
  }
}



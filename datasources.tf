#used to pull down existing resouces in AWS
# Declare the data source
data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "aws_linux_server" {
  most_recent = true
  owners      = ["137112412989"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-kernel-6.1-x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
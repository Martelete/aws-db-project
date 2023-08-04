data "aws_availability_zones" "current" {}
data "aws_region" "current" {}

### In case you want to update the AMI to the latest
data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["Ubuntu"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}
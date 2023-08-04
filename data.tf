data "aws_availability_zones" "current" {}
data "aws_region" "current" {}

### In case you want to update the AMI to the latest
data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*-x86_64-gp*"]
  }

  owners = ["amazon"] # Canonical
}
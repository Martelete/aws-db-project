data "aws_availability_zones" "current" {}
data "aws_region" "current" {}

### In case you want to update the AMI to the latest
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners = ["amazon"]
  
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}
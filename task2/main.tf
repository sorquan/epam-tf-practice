variable "aws_region" {
    default = "" # Put here some region
}
variable "aws_access_key" {
    default = "" # Put here some access key
}
variable "aws_secret_key" {
    default = "" # Put here some secret key
}
variable "aws_rds_password" {
    default = "" # Put here some database password
}

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_key_pair" "rsa_key" {
  key_name   = "rsa-key"
  public_key = file("rsa_key.pub")
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  key_name      = aws_key_pair.rsa_key.key_name
  user_data     = file("user-data-nginx.sh")

  tags = {
    Name = "nginx-instance"
  }
}

resource "aws_db_instance" "hw2-rds-instance" {
  allocated_storage      = 10
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t2.micro"
  identifier             = "dbtest"
  db_name                = "db_test"
  username               = "user"
  password               = var.aws_rds_password
  skip_final_snapshot    = true
}
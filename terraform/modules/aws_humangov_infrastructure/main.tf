resource "aws_security_group" "state_ec2_sg" {
  name        = "humangov-${var.state_name}-ec2-sg"
  description = "Allow trafic on ports 22 and 80"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "humangov-${var.state_name}"
  }
}

# data "aws_ami" "latest_amazon_image" {
#   owners = [ "amazon" ]

#   #filtros para selecionar a ami correta
#   filter {
#     name = "name"
#     values = [ "amazon/ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20230325" ] # Nome do padrão da AMI do Amazon Linux 2
#   }

#   filter {
#     name = "root-device-type"
#     values = [ "ebs" ]
#   }

#   filter {
#     name = "virtualization-type"
#     values = [ "hvm" ]
#   }
# }

resource "aws_instance" "state_ec2" {
  ami                    = "ami-007855ac798b5175e" #data.aws_ami.latest_amazon_image.id
  instance_type          = "t2.micro"
  key_name               = "ssh-aws-bootcamp"
  vpc_security_group_ids = [aws_security_group.state_ec2_sg.id]

  tags = {
    Name = "humangov-${var.state_name}"
  }
}

resource "aws_dynamodb_table" "state_dynamodb" {
  name         = "humangov-${var.state_name}-dynamodb"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Name = "humangov-${var.state_name}"
  }
}

resource "random_string" "bucket_sufix" {
  length  = 4
  special = false
  upper   = false
}

resource "aws_s3_bucket" "state_s3" {
  bucket = "humangov-${var.state_name}-s3-${random_string.bucket_sufix.result}"

  tags = {
    Name = "humangov-${var.state_name}"
  }
}
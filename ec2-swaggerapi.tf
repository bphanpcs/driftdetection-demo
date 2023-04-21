provider "aws" {
  region = "us-west-1"
}

resource "aws_security_group" "example" {
  name_prefix = "example"
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_subnet" "example" {
  vpc_id = data.aws_vpc.default.id
  tags = {
    "Name" = "Public Subnet"
  }
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_instance" "example" {
  ami           = "ami-081a3b9eded47f0f3"
  instance_type = "t2.micro"
  key_name      = "bphan-aws-key123"
  subnet_id     = data.aws_subnet.example.id
  vpc_security_group_ids = [aws_security_group.example.id]
  tags = {
    Name = "example-instance"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y docker.io
              sudo systemctl start docker
              sudo systemctl enable docker
              sudo docker run -d -p 8080:8080 swaggerapi/petstore
              EOF
}

output "public_ip" {
  value = aws_instance.example.public_ip
}
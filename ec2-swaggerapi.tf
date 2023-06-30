provider "aws" {
  region = "us-west-1"
}

resource "aws_security_group" "example" {
  name_prefix = "example"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["68.251.60.220/32"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["68.251.60.220/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    git_commit           = "6d7c2c268906fca73e0a951e37bc0de065b300cc"
    git_file             = "ec2-swaggerapi.tf"
    git_last_modified_at = "2023-04-21 01:54:33"
    git_last_modified_by = "bphan@paloaltonetworks.com"
    git_modifiers        = "bphan"
    git_org              = "bphanpcs"
    git_repo             = "driftdetection-demo"
    yor_trace            = "518ec5a6-c623-4572-9b26-bec1a1ed5a75"
    user                 = "pchandaliya"
  }
}

resource "aws_instance" "example" {
  ami                    = "ami-081a3b9eded47f0f3"
  instance_type          = "t2.micro"
  key_name               = "bphan-aws-key123"
  vpc_security_group_ids = [aws_security_group.example.id]
  tags = {
    Name                 = "example-instance"
    git_commit           = "6d7c2c268906fca73e0a951e37bc0de065b300cc"
    git_file             = "ec2-swaggerapi.tf"
    git_last_modified_at = "2023-04-21 01:54:33"
    git_last_modified_by = "bphan@paloaltonetworks.com"
    git_modifiers        = "bphan"
    git_org              = "bphanpcs"
    git_repo             = "driftdetection-demo"
    yor_trace            = "55af62c8-d9c5-4731-be46-a398012970c3"
    user                 = "pchandaliya"
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

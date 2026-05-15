
    provider "aws" {
      region = "eu-west-3"
    }

    variable "docker_image" {
      type = string
      default = "nginx:latest"
    }

    resource "aws_security_group" "nextgen-sg" {
      name = "nextgen-sg"
      description = "Security group for nextgen app"

      ingress {
        from_port   = 80
        to_port     = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }

      egress {
        from_port   = 0
        to_port     = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }

      tags = {
        Project = "PFS-2026"
      }
    }

    resource "aws_instance" "nextgen-ec2" {
      ami = "ami-011fc4a229f0661be"
      instance_type = "t3.micro"
      vpc_security_group_ids = [aws_security_group.nextgen-sg.id]
      user_data = <<-EOF
        #!/bin/bash
        sudo yum update -y
        sudo yum install -y docker
        sudo systemctl start docker
        sudo systemctl enable docker
        sudo docker pull ${var.docker_image}
        sudo docker run -d -p 80:80 ${var.docker_image}
      EOF

      tags = {
        Project = "PFS-2026"
      }
    }
  
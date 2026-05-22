provider "aws" {
      region = "eu-west-3"
    }

    variable "docker_image" {
      type = string
      default = "nginx:latest"
    }

    resource "aws_security_group" "nextgen-sg" {
      name_prefix = "nextgen-sg-"
      description = "Allow inbound traffic on port 22 and 80"
      lifecycle {
        create_before_destroy = true
      }

      ingress {
        from_port = 22
        to_port   = 22
        protocol  = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }

      ingress {
        from_port = 80
        to_port   = 80
        protocol  = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }

      egress {
        from_port = 0
        to_port   = 0
        protocol  = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }

      tags = {
        Project = "PFS-2026"
      }
    }

    resource "aws_instance" "nextgen-ec2" {
      ami           = "ami-011fc4a229f0661be"
      instance_type = "t3.micro"
      key_name               = "nextgen-key"
      vpc_security_group_ids = [aws_security_group.nextgen-sg.id]
      monitoring = true

      user_data = <<-EOF
        #!/bin/bash
        yum update -y
        yum install -y docker
        systemctl start docker
        systemctl enable docker
        docker pull ${var.docker_image}
        docker run -d -p 80:80 --user root --restart always ${var.docker_image}
      EOF

      tags = {
        Project = "PFS-2026"
      }
    }
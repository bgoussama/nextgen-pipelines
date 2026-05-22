provider "aws" {
    region = var.aws_region
}

variable "aws_region" {
    type = string
    default = "eu-west-3"
}

variable "docker_image" {
    type = string
    default = "bgoussama/nextgen-app:latest"
}

resource "aws_security_group" "nextgen-sg" {
    name_prefix = "nextgen-sg-"
    description = "Security group for nextgen app"
    lifecycle {
        create_before_destroy = true
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "nextgen-ec2" {
    ami = "ami-011fc4a229f0661be"
    instance_type = "t3.micro"
    key_name = "nextgen-key"
    vpc_security_group_ids = [aws_security_group.nextgen-sg.id]
    user_data_replace_on_change = true
    user_data = <<-EOF
        #!/bin/bash
        yum update -y
        yum install -y docker
        systemctl start docker
        systemctl enable docker
        docker rm -f nextgen-app || true
        docker pull ${var.docker_image}
        docker run -d --name nextgen-app -p 80:80 --restart unless-stopped ${var.docker_image}
    EOF
    tags = {
        Project = "PFS-2026"
    }
}
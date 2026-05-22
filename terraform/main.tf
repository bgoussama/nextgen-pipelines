provider "aws" {
    region = "eu-west-3"
}

variable "docker_image" {
    type = string
    default = "bgoussama/nextgen-app:latest"
}

resource "aws_security_group" "nextgen-sg" {
    name_prefix = "nextgen-sg-"
    description = "Security group for nextgen-app"
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
    egress {
        from_port = 0
        to_port = 0
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
    key_name = "nextgen-key"
    user_data = "#!/bin/bash\n\nyum update -y\n\nyum install -y docker\n\nsystemctl start docker\n\nsystemctl enable docker\n\ndocker rm -f nextgen-app || true\n\ndocker pull ${var.docker_image}\n\ndocker run -d --name nextgen-app -p 80:80 --restart unless-stopped ${var.docker_image}\n"
    user_data_replace_on_change = true
    monitoring = true
    tags = {
        Project = "PFS-2026"
    }
}
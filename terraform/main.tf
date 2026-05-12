provider "aws" {
    region = "us-west-2"
}

resource "aws_security_group" "nextgen-sg" {
    name        = "nextgen-sg"
    description = "Allow inbound traffic on port 8080"
    vpc_id      = "vpc-12345678"

    ingress {
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "nextgen-sg"
    }
}

resource "aws_instance" "nextgen-instance" {
    ami           = "ami-0123456789abcdef0"
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.nextgen-sg.id]
    monitoring = true
}
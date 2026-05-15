provider "aws" {
    region = "eu-west-3"
}

resource "aws_security_group" "nextgen-sg" {
    name        = "nextgen-sg"
    description = "Security group for nextgen app"
    ingress {
        from_port   = 80
        to_port     = 80
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
        Project = "PFS-2026"
    }
}

resource "aws_instance" "nextgen-instance" {
    ami           = "ami-011fc4a229f0661be"
    instance_type = "t3.micro"
    vpc_security_group_ids = [aws_security_group.nextgen-sg.id]
    monitoring = true
    tags = {
        Project = "PFS-2026"
    }
}
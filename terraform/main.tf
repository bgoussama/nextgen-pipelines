provider 'aws' {
    region = 'eu-west-1'
}

resource 'aws_security_group' 'your-sg' {
    name        = 'your-sg'
    description = 'Allow inbound traffic on port 80'
    vpc_id      = 'your-vpc-id'

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = 'tcp'
        cidr_blocks = ['0.0.0.0/0']
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = '-1'
        cidr_blocks = ['0.0.0.0/0']
    }

    tags = {
        Name = 'your-sg'
    }
}

resource 'aws_instance' 'your-ec2' {
    ami           = 'ami-0c94855ba95c71c99'
    instance_type = 't2.micro'
    vpc_security_group_ids = [aws_security_group.your-sg.id]
    monitoring = true
}
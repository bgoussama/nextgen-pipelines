{
  "provider": "aws",
  "region": "eu-west-3",
  "resource": "aws_instance",
  "name_prefix": "nextgen-sg-",
  "description": "Security group for nextgen app",
  "ingress": [
    {
      "from_port": 22,
      "to_port": 22,
      "protocol": "tcp",
      "cidr_blocks": [
        "0.0.0.0/0"
      ]
    },
    {
      "from_port": 80,
      "to_port": 80,
      "protocol": "tcp",
      "cidr_blocks": [
        "0.0.0.0/0"
      ]
    }
  ],
  "egress": [
    {
      "from_port": 0,
      "to_port": 0,
      "protocol": "-1",
      "cidr_blocks": [
        "0.0.0.0/0"
      ]
    }
  ],
  "lifecycle": {
    "create_before_destroy": true
  },
  "tags": {
    "Project": "PFS-2026"
  },
  "ami": "ami-011fc4a229f0661be",
  "instance_type": "t3.micro",
  "vpc_security_group_ids": [
    "${aws_security_group.nextgen-sg.id}"
  ],
  "key_name": "nextgen-key",
  "user_data": "#!/bin/bash\nyum update -y\nyum install -y docker\nsystemctl start docker\nsystemctl enable docker\ndocker pull ${docker_image}\ndocker run -d -p 80:80 --user root --restart always ${docker_image}",
  "variable": "docker_image",
  "type": "string",
  "default": "nginx:latest"
}
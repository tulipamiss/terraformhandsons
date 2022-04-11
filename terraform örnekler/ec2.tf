provider "aws" {
  region = "us-east-1"
  # Configuration options
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.9.0"
    }
  }
}

resource "aws_instance" "tf-ec2" {
  ami             = "ami-0c02fb55956c7d316"
  instance_type   = "t2.micro"
  key_name        = "leon"
  security_groups = ["tf-sec-gr"]
  tags = {
    "Name" = "leon-terraform"
  }
  user_data = <<-EOF
	#!/bin/bash
  echo "*** Installing apache2"
  yum update -y
  yum install httpd -y
  DATE_TIME=`date`
  echo "<html>
  <head>
      <title> My First Web Server</title>
  </head>
  <body>
      <h1>Hello to Everyone from My First Web Server</h1>
      <p>This instance is created at <b>$DATE_TIME</b></p>
  </body>
  </html>" > /var/www/html/index.html
  systemctl start httpd
  systemctl enable httpd
  echo "*** Completed Installing apache2"
  EOF
}

resource "aws_security_group" "tf-ec2-sec-gr" {
  name = "tf-sec-gr"
  tags = {
    "Name" = "leon-terraform-sec-gr-allow_ssh_http"
  }

  ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "HTTP from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}






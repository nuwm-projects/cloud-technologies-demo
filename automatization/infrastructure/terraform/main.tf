terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "eu-north-1"
}

provider "cloudflare" {}

# Configure networking
resource "aws_vpc" "counter-app-vpc" {
  cidr_block           = "10.50.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_internet_gateway" "counter-app-gw" {
  vpc_id = aws_vpc.counter-app-vpc.id
}

resource "aws_route_table" "counter-app-routing" {
  vpc_id = aws_vpc.counter-app-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.counter-app-gw.id
  }
}

resource "aws_subnet" "counter-app-subnet" {
  vpc_id                  = aws_vpc.counter-app-vpc.id
  cidr_block              = "10.50.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "counter-app-10-50-1-0"
    Tier = "Public"
  }
}

resource "aws_route_table_association" "subnet-association" {
  subnet_id      = aws_subnet.counter-app-subnet.id
  route_table_id = aws_route_table.counter-app-routing.id
}

# Configure firewall
resource "aws_security_group" "counter-app-security" {
  name        = "counter-app-security"
  description = "counter-app-security"
  vpc_id      = aws_vpc.counter-app-vpc.id

  ingress {
    description = "http"
    from_port   = 0
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ssh"
    from_port   = 0
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["65.108.204.154/32", "65.108.204.148/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Allow HTTP"
  }
}

# Create instance
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_instance" "wp-server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.counter-app-subnet.id

  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    sudo apt update && sudo apt upgrade -y && sudo apt install -y ca-certificates curl gnupg lsb-release git
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update
    sudo apt -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin

    sudo usermod -aG docker ubuntu

    echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCuz7afrniHyBq1pIolCqUf0CU/WSMkE4zzhakwcGj1+DmrrbVcFLXNcR7oZPe9hbkolZkfMHKuoz0JMG/YPxmKTSqjtTKDnvu2blVv/+ADwrpAbf8/QtKBdgug4EfPky+UmJqdvyXnsuFy6r/iqbaJyYE+862Hfhf0oWzY9KwyySUJ0sUamiPIzbj6kwTscsPd3A1euZYPf4uxdR8B98TvtoA51Vr96opaaa1051CBLxz7REjEdy2pDP0rcWXkhYe9+9Puk2KEFWIOZ0nEI5GCsgJ8MRpUs16DyMkRmCoE10Vy3bokD/dCjLIwYErhYwl4o69T9eiT7YsOeL0S8zWSSiaV7iTcJdWdgQ4nik8lX9wQNWJsnm5/gEb5ZXKkMaUQce0K1Ovt/5gYiFH+2lUYb2VySh1RrgO5vfjb9w1fN5NcKmxK5NfLK4KiaVYxN9586V0gOlTG4DIMxRENNcnM+F//thiMrZaUvAdiFsoY4O0zzgRLKilWlcvxpdtUzO0= manager@management" >> /home/ubuntu/.ssh/authorized_keys

    git clone https://github.com/nuwm-projects/cloud-technologies-demo.git

    cd ./cloud-technologies-demo/app/backend
    docker compose -f docker-compose.yml up
  EOF

  vpc_security_group_ids = [
    aws_security_group.counter-app-security.id
  ]
}

# Create S3 bucket for static content

# Create DNS record for API service

# Create DNS record for front end service
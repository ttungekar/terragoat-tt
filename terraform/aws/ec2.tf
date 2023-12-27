resource "aws_instance" "web_host" {
  # ec2 have plain text secrets in user data
  ami           = "${var.ami}"
  instance_type = "t2.nano"

  vpc_security_group_ids = [
  "${aws_security_group.web-node.id}"]
  subnet_id = "${aws_subnet.web_subnet.id}"
  user_data = <<EOF
#! /bin/bash
sudo apt-get update
sudo apt-get install -y apache2
sudo systemctl start apache2
sudo systemctl enable apache2
export AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMAAA
export AWS_SECRET_ACCESS_KEY=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
export AWS_DEFAULT_REGION=us-west-2
echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html
EOF
  tags = {
    Name      = "${local.resource_prefix.value}-ec2"
    yor_trace = "e5a3bc07-0e64-4cf5-9ce4-46aaa7dea207"
  }
}

resource "aws_ebs_volume" "web_host_storage" {
  # unencrypted volume
  availability_zone = "${var.availability_zone}"
  #encrypted         = false  # Setting this causes the volume to be recreated on apply 
  size = 1
  tags = {
    Name      = "${local.resource_prefix.value}-ebs"
    yor_trace = "c531083a-77a4-49ff-b356-4fd4f2cd554a"
  }
}

resource "aws_ebs_snapshot" "example_snapshot" {
  # ebs snapshot without encryption
  volume_id   = "${aws_ebs_volume.web_host_storage.id}"
  description = "${local.resource_prefix.value}-ebs-snapshot"
  tags = {
    Name      = "${local.resource_prefix.value}-ebs-snapshot"
    yor_trace = "a676d6f0-3d7d-4ac5-a3d2-efc5bdc4a8c1"
  }
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = "${aws_ebs_volume.web_host_storage.id}"
  instance_id = "${aws_instance.web_host.id}"
}

resource "aws_security_group" "web-node" {
  # security group is open to the world in SSH port
  name        = "${local.resource_prefix.value}-sg"
  description = "${local.resource_prefix.value} Security Group"
  vpc_id      = aws_vpc.web_vpc.id

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = [
    "0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = [
    "0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
    "0.0.0.0/0"]
  }
  depends_on = [aws_vpc.web_vpc]
  tags = {
    yor_trace = "ac44f8e7-0249-43f8-9347-0b572db02728"
  }
}

resource "aws_vpc" "web_vpc" {
  cidr_block           = "172.16.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name      = "${local.resource_prefix.value}-vpc"
    yor_trace = "ddba1920-2217-4f1d-a92e-a19831897162"
  }
}

resource "aws_subnet" "web_subnet" {
  vpc_id                  = aws_vpc.web_vpc.id
  cidr_block              = "172.16.10.0/24"
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name      = "${local.resource_prefix.value}-subnet"
    yor_trace = "7236271e-a4cb-44c0-ab94-52645c15e374"
  }
}

resource "aws_subnet" "web_subnet2" {
  vpc_id                  = aws_vpc.web_vpc.id
  cidr_block              = "172.16.11.0/24"
  availability_zone       = var.availability_zone2
  map_public_ip_on_launch = true

  tags = {
    Name      = "${local.resource_prefix.value}-subnet2"
    yor_trace = "3d317d62-aa5a-4aa4-a693-48862cf42c20"
  }
}


resource "aws_internet_gateway" "web_igw" {
  vpc_id = aws_vpc.web_vpc.id

  tags = {
    Name      = "${local.resource_prefix.value}-igw"
    yor_trace = "0b2396cf-0de0-4d78-90d8-5a991432423a"
  }
}

resource "aws_route_table" "web_rtb" {
  vpc_id = aws_vpc.web_vpc.id

  tags = {
    Name      = "${local.resource_prefix.value}-rtb"
    yor_trace = "317a96ea-dd87-44fb-8eb9-62b8fb2c2e0e"
  }
}

resource "aws_route_table_association" "rtbassoc" {
  subnet_id      = aws_subnet.web_subnet.id
  route_table_id = aws_route_table.web_rtb.id
}

resource "aws_route_table_association" "rtbassoc2" {
  subnet_id      = aws_subnet.web_subnet2.id
  route_table_id = aws_route_table.web_rtb.id
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.web_rtb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.web_igw.id

  timeouts {
    create = "5m"
  }
}


resource "aws_network_interface" "web-eni" {
  subnet_id   = aws_subnet.web_subnet.id
  private_ips = ["172.16.10.100"]

  tags = {
    Name      = "${local.resource_prefix.value}-primary_network_interface"
    yor_trace = "9cc543b9-08a6-4b04-9d41-7a68b42f48f8"
  }
}

# VPC Flow Logs to S3
resource "aws_flow_log" "vpcflowlogs" {
  log_destination      = aws_s3_bucket.flowbucket.arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.web_vpc.id

  tags = {
    Name        = "${local.resource_prefix.value}-flowlogs"
    Environment = local.resource_prefix.value
    yor_trace   = "ff3a1ae1-401d-4e86-aa3e-0501be6aeab9"
  }
}

resource "aws_s3_bucket" "flowbucket" {
  bucket        = "${local.resource_prefix.value}-flowlogs"
  force_destroy = true

  tags = {
    Name        = "${local.resource_prefix.value}-flowlogs"
    Environment = local.resource_prefix.value
    yor_trace   = "679cc592-0105-484c-a096-a598f4ec17ba"
  }
}

output "ec2_public_dns" {
  description = "Web Host Public DNS name"
  value       = aws_instance.web_host.public_dns
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.web_vpc.id
}

output "public_subnet" {
  description = "The ID of the Public subnet"
  value       = aws_subnet.web_subnet.id
}

output "public_subnet2" {
  description = "The ID of the Public subnet"
  value       = aws_subnet.web_subnet2.id
}

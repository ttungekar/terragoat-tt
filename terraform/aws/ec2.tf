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
    Name                 = "${local.resource_prefix.value}-ec2"
    yor_trace            = "e33c8752-6643-4fb9-adea-737190448076"
    git_commit           = "d68d2897add9bc2203a5ed0632a5cdd8ff8cefb0"
    git_file             = "terraform/aws/ec2.tf"
    git_last_modified_at = "2020-06-16 14:46:24"
    git_last_modified_by = "nimrodkor@gmail.com"
    git_modifiers        = "nimrodkor"
    git_org              = "ttungekar"
    git_repo             = "terragoat-tt"
    yor_name             = "web_host"
  }
}

resource "aws_ebs_volume" "web_host_storage" {
  # unencrypted volume
  availability_zone = "${var.availability_zone}"
  #encrypted         = false  # Setting this causes the volume to be recreated on apply 
  size = 1
  tags = {
    Name                 = "${local.resource_prefix.value}-ebs"
    yor_trace            = "a7619d65-d631-4e11-9a8b-9d7a46ca5b60"
    git_commit           = "68e454047fb4520f27ed75ffa066ee09d75e325b"
    git_file             = "terraform/aws/ec2.tf"
    git_last_modified_at = "2020-06-16 14:46:24"
    git_last_modified_by = "nimrodkor@gmail.com"
    git_modifiers        = "nimrodkor"
    git_org              = "ttungekar"
    git_repo             = "terragoat-tt"
    yor_name             = "web_host_storage"
  }
}

resource "aws_ebs_snapshot" "example_snapshot" {
  # ebs snapshot without encryption
  volume_id   = "${aws_ebs_volume.web_host_storage.id}"
  description = "${local.resource_prefix.value}-ebs-snapshot"
  tags = {
    Name                 = "${local.resource_prefix.value}-ebs-snapshot"
    yor_trace            = "485dbe2e-f624-49be-aee3-83f14a7ea05b"
    git_commit           = "68e454047fb4520f27ed75ffa066ee09d75e325b"
    git_file             = "terraform/aws/ec2.tf"
    git_last_modified_at = "2020-06-16 14:46:24"
    git_last_modified_by = "nimrodkor@gmail.com"
    git_modifiers        = "nimrodkor"
    git_org              = "ttungekar"
    git_repo             = "terragoat-tt"
    yor_name             = "example_snapshot"
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
    yor_trace            = "f21556ae-926d-47fa-af42-476f7f2fa25c"
    git_commit           = "68e454047fb4520f27ed75ffa066ee09d75e325b"
    git_file             = "terraform/aws/ec2.tf"
    git_last_modified_at = "2021-05-02 10:06:10"
    git_last_modified_by = "nimrodkor@users.noreply.github.com"
    git_modifiers        = "nimrodkor"
    git_org              = "ttungekar"
    git_repo             = "terragoat-tt"
    yor_name             = "web-node"
  }
}

resource "aws_vpc" "web_vpc" {
  cidr_block           = "172.16.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name                 = "${local.resource_prefix.value}-vpc"
    yor_trace            = "eb0ca0f1-01fd-4373-8b3c-40454a49af7d"
    git_commit           = "68e454047fb4520f27ed75ffa066ee09d75e325b"
    git_file             = "terraform/aws/ec2.tf"
    git_last_modified_at = "2020-06-16 14:46:24"
    git_last_modified_by = "nimrodkor@gmail.com"
    git_modifiers        = "nimrodkor"
    git_org              = "ttungekar"
    git_repo             = "terragoat-tt"
    yor_name             = "web_vpc"
  }
}

resource "aws_subnet" "web_subnet" {
  vpc_id                  = aws_vpc.web_vpc.id
  cidr_block              = "172.16.10.0/24"
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name                 = "${local.resource_prefix.value}-subnet"
    yor_trace            = "32bb3751-f144-44c9-963c-4e8a18bb6d90"
    git_commit           = "68e454047fb4520f27ed75ffa066ee09d75e325b"
    git_file             = "terraform/aws/ec2.tf"
    git_last_modified_at = "2020-06-16 14:46:24"
    git_last_modified_by = "nimrodkor@gmail.com"
    git_modifiers        = "nimrodkor"
    git_org              = "ttungekar"
    git_repo             = "terragoat-tt"
    yor_name             = "web_subnet"
  }
}

resource "aws_subnet" "web_subnet2" {
  vpc_id                  = aws_vpc.web_vpc.id
  cidr_block              = "172.16.11.0/24"
  availability_zone       = var.availability_zone2
  map_public_ip_on_launch = true

  tags = {
    Name                 = "${local.resource_prefix.value}-subnet2"
    yor_trace            = "9fd88bd1-f388-4b62-adc0-ce524f3fa806"
    git_commit           = "68e454047fb4520f27ed75ffa066ee09d75e325b"
    git_file             = "terraform/aws/ec2.tf"
    git_last_modified_at = "2020-06-16 14:46:24"
    git_last_modified_by = "nimrodkor@gmail.com"
    git_modifiers        = "nimrodkor"
    git_org              = "ttungekar"
    git_repo             = "terragoat-tt"
    yor_name             = "web_subnet2"
  }
}


resource "aws_internet_gateway" "web_igw" {
  vpc_id = aws_vpc.web_vpc.id

  tags = {
    Name                 = "${local.resource_prefix.value}-igw"
    yor_trace            = "ee59373c-9974-4ccf-b122-35af38f925d7"
    git_commit           = "68e454047fb4520f27ed75ffa066ee09d75e325b"
    git_file             = "terraform/aws/ec2.tf"
    git_last_modified_at = "2020-06-16 14:46:24"
    git_last_modified_by = "nimrodkor@gmail.com"
    git_modifiers        = "nimrodkor"
    git_org              = "ttungekar"
    git_repo             = "terragoat-tt"
    yor_name             = "web_igw"
  }
}

resource "aws_route_table" "web_rtb" {
  vpc_id = aws_vpc.web_vpc.id

  tags = {
    Name                 = "${local.resource_prefix.value}-rtb"
    yor_trace            = "cb4dd41e-a592-4b4e-bebf-e63d41ebf9ee"
    git_commit           = "68e454047fb4520f27ed75ffa066ee09d75e325b"
    git_file             = "terraform/aws/ec2.tf"
    git_last_modified_at = "2020-06-16 14:46:24"
    git_last_modified_by = "nimrodkor@gmail.com"
    git_modifiers        = "nimrodkor"
    git_org              = "ttungekar"
    git_repo             = "terragoat-tt"
    yor_name             = "web_rtb"
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
    Name                 = "${local.resource_prefix.value}-primary_network_interface"
    yor_trace            = "309fa6e6-4bff-48ae-a166-3dfecabee662"
    git_commit           = "68e454047fb4520f27ed75ffa066ee09d75e325b"
    git_file             = "terraform/aws/ec2.tf"
    git_last_modified_at = "2020-06-16 14:46:24"
    git_last_modified_by = "nimrodkor@gmail.com"
    git_modifiers        = "nimrodkor"
    git_org              = "ttungekar"
    git_repo             = "terragoat-tt"
    yor_name             = "web-eni"
  }
}

# VPC Flow Logs to S3
resource "aws_flow_log" "vpcflowlogs" {
  log_destination      = aws_s3_bucket.flowbucket.arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.web_vpc.id

  tags = {
    Name                 = "${local.resource_prefix.value}-flowlogs"
    Environment          = local.resource_prefix.value
    yor_trace            = "77ba9e1a-887b-4b35-80bf-2aa1a2290053"
    git_commit           = "68e454047fb4520f27ed75ffa066ee09d75e325b"
    git_file             = "terraform/aws/ec2.tf"
    git_last_modified_at = "2020-06-16 14:46:24"
    git_last_modified_by = "nimrodkor@gmail.com"
    git_modifiers        = "nimrodkor"
    git_org              = "ttungekar"
    git_repo             = "terragoat-tt"
    yor_name             = "vpcflowlogs"
  }
}

resource "aws_s3_bucket" "flowbucket" {
  bucket        = "${local.resource_prefix.value}-flowlogs"
  force_destroy = true

  tags = {
    Name                 = "${local.resource_prefix.value}-flowlogs"
    Environment          = local.resource_prefix.value
    yor_trace            = "b7ddcffe-dddf-45c5-9786-ee3e06cf971e"
    git_commit           = "68e454047fb4520f27ed75ffa066ee09d75e325b"
    git_file             = "terraform/aws/ec2.tf"
    git_last_modified_at = "2020-06-16 14:46:24"
    git_last_modified_by = "nimrodkor@gmail.com"
    git_modifiers        = "nimrodkor"
    git_org              = "ttungekar"
    git_repo             = "terragoat-tt"
    yor_name             = "flowbucket"
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

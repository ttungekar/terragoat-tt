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
    yor_trace            = "3875cee0-2e91-4309-a292-76aee47c8264"
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
    yor_trace            = "e603812a-19bc-4a5a-be87-3c46130bbc81"
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
    yor_trace            = "3dc42102-248d-401b-995b-32d1aafe4031"
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
    yor_trace            = "4281033d-ef27-46e5-a64a-78e750f39dbb"
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
    yor_trace            = "06d58175-87a1-49dc-bac1-ece18b3ddc9f"
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
    yor_trace            = "b1939b2d-8ad5-40b3-9d04-18431c79873d"
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
    yor_trace            = "8ec96beb-4295-4f7c-8596-6ede195f97a3"
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
    yor_trace            = "ddc1fc53-99a9-4c40-bcf3-c2c46d0886d8"
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
    yor_trace            = "f0d3b33d-db17-4f58-94ab-5090c7bb921c"
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
    yor_trace            = "bfafb741-f6a4-4138-b0f5-8858052af5fc"
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
    yor_trace            = "3824469c-ec0d-4adf-a2f0-21c64655f286"
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
    yor_trace            = "51320119-4f41-463f-9acf-eb9c99404610"
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

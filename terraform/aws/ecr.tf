resource aws_ecr_repository "repository" {
  name                 = "${local.resource_prefix.value}-repository"
  image_tag_mutability = "MUTABLE"

  tags = {
    Name      = "${local.resource_prefix.value}-repository"
    yor_trace = "fd3cd7bb-cc54-40c3-a3b0-c8b72c4c477a"
  }
}

locals {
  docker_image = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com/${aws_ecr_repository.repository.name}"
}


resource null_resource "push_image" {
  provisioner "local-exec" {
    working_dir = "${path.module}/resources"
    command     = <<BASH
    aws ecr get-login-password --region ${var.region} | docker login --username AWS --password-stdin ${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com
    docker build -t ${aws_ecr_repository.repository.name} .
    docker tag ${aws_ecr_repository.repository.name} ${local.docker_image}
    docker push ${local.docker_image}
    BASH
  }
}
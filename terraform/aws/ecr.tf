resource aws_ecr_repository "repository" {
  name                 = "${local.resource_prefix.value}-repository"
  image_tag_mutability = "MUTABLE"

  tags = {
    Name                 = "${local.resource_prefix.value}-repository"
    yor_trace            = "f9906d0e-bd6b-4814-9479-dea85cf4e0fd"
    git_commit           = "d68d2897add9bc2203a5ed0632a5cdd8ff8cefb0"
    git_file             = "terraform/aws/ecr.tf"
    git_last_modified_at = "2020-06-16 14:46:24"
    git_last_modified_by = "nimrodkor@gmail.com"
    git_modifiers        = "nimrodkor"
    git_org              = "ttungekar"
    git_repo             = "terragoat-tt"
    yor_name             = "repository"
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
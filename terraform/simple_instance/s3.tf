provider "aws" {
  region = "us-west-2"
}

resource "aws_s3_bucket" "dockingbay" {
  bucket_prefix = "docking-bay-storage-"

  tags = {
    Name                 = "Docking Bay"
    Environment          = "Dev"
    git_commit           = "4952e7b3159439bdaeeb465d4218e454d5817831"
    git_file             = "terraform/simple_instance/s3.tf"
    git_last_modified_at = "2022-12-10 01:41:38"
    git_last_modified_by = "118484314+ttungekar@users.noreply.github.com"
    git_modifiers        = "118484314+ttungekar"
    git_org              = "ttungekar"
    git_repo             = "terragoat-tt"
    yor_trace            = "7605fb89-06c5-4c39-a8cb-c4508f006ace"
  }
}

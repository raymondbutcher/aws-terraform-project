resource "aws_codecommit_repository" "project" {
  repository_name = "${var.project_name}"
}

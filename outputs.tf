output "git_clone_url_http" {
  value = "${aws_codecommit_repository.project.clone_url_http}"
}

output "git_clone_url_ssh" {
  value = "${aws_codecommit_repository.project.clone_url_ssh}"
}

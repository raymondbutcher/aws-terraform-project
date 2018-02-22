resource "aws_codebuild_project" "project" {
  name          = "${var.project_name}"
  build_timeout = "${var.codebuild_timeout}"
  service_role  = "${aws_iam_role.codebuild.arn}"

  source {
    type     = "CODECOMMIT"
    location = "${aws_codecommit_repository.project.clone_url_http}"
  }

  environment {
    compute_type = "${var.codebuild_compute_type}"
    image        = "${var.codebuild_image}"
    type         = "${var.codebuild_type}"
  }

  artifacts {
    type = "NO_ARTIFACTS"
  }
}

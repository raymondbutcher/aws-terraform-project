# http://clarkgrubb.com/makefile-style-guide

MAKEFLAGS += --warn-undefined-variables --no-print-directory
SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := help
.DELETE_ON_ERROR:
.SUFFIXES:

.PHONY: help
help:
	@echo "Available make targets:"
	@egrep '^(.+)\:\ ##\ (.+)' ${MAKEFILE_LIST} | column -t -c 2 -s ':#'

backend: ## Create the S3 backend for Terraform state
	if ! aws s3api head-bucket --bucket $(TF_BACKEND_BUCKET) 2>/dev/null; then \
		aws s3api create-bucket \
			--acl private \
			--bucket $(TF_BACKEND_BUCKET) \
			--create-bucket-configuration LocationConstraint=$(AWS_DEFAULT_REGION) \
		; \
	fi
	aws s3api wait bucket-exists \
		--bucket $(TF_BACKEND_BUCKET)
	aws s3api put-bucket-versioning \
		--bucket $(TF_BACKEND_BUCKET) \
		--versioning-configuration Status=Enabled

init: ## Runs 'terraform init' using the S3 backend
	terraform init \
		-backend-config="bucket=$(TF_BACKEND_BUCKET)" \
		-backend-config="key=terraform.tfstate" \
		-backend-config="region=$(AWS_DEFAULT_REGION)"

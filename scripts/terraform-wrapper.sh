#!/usr/bin/env bash

function clean()
{
	rm -rf .terraform
}

function assume_role()
{
	echo "=> Assuming Role: ${AWS_ROLE_ARN}"

	if [ -z $AWS_ACCESS_KEY_ID ] || [ -z $AWS_SECRET_ACCESS_KEY ]; then
		echo "Either AWS_ACCESS_EKEY_ID and/or AWS_SECRET_ACCESS_KEY are not properly set"
		exit
	fi

	session="$(aws sts assume-role \
		--role-arn "${AWS_ROLE_ARN}" \
		--role-session-name 'Docker-Terraform-Session')"

	if [ $? -ne 0 ]; then
		echo "=> Could not assume role"
		exit
	fi

	unset AWS_ACCESS_KEY_ID
	unset AWS_SECRET_ACCESS_KEY

	export AWS_ACCESS_KEY_ID="$(echo $session | jq -r '.Credentials.AccessKeyId')"
	export AWS_SECRET_ACCESS_KEY="$(echo $session | jq -r '.Credentials.SecretAccessKey')"
	export AWS_SESSION_TOKEN="$(echo $session | jq -r '.Credentials.SessionToken')"
}

function transform_variables() {
    if [ -n "$VERSION" ]; then
        echo "=> Performing Variable Transformation"

        sed -i "s|#{VERSION}|${VERSION}|" backend.tf
    fi
}

clean

if [ -n "$AWS_ROLE_ARN" ]; then
	assume_role
fi

if [ $? ]; then
	transform_variables \
        && terraform init \
		&& terraform workspace select $TERRAFORM_WORKSPACE \
		&& terraform $@
fi

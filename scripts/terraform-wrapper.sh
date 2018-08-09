#!/usr/bin/env bash

function assume_role() {
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

function terraform_workspace() {
    if [ ! -z ${TERRAFORM_WORKSPACE} ]; then
        worksapce_exist=$(/usr/bin/terraform workspace list | grep "${TERRAFORM_WORKSPACE}" | wc -l)

        if [ "${workspace_exist}" == 0 ]; then
            /usr/bin/terraform workspace new ${TERRAFORM_WORKSPACE}
        fi

        /usr/bin/terraform workspace select ${TERRAFORM_WORKSPACE}
    else
        echo "=> No workspace info has been provided! Using 'default' workspace."
    fi
}

if [ "$(find /terraform-src -maxdepth 1 -name '*.tf' -type f | wc -l)" > 0 ]; then
    # Take a snapshot of the terraform scripts before running
    cp -r /terraform-src/* /infra/

    if [ -n "$AWS_ROLE_ARN" ]; then
        assume_role
    fi

    if [ $? ]; then
        transform_variables \
            && /usr/bin/terraform init \
            && terraform_workspace \
            && /usr/bin/terraform $@
    fi
else
    echo "=> There are no Terraform Configuration files!"
fi

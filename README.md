# Docker for Terraform
> This project intends to provide a streamlined execution of Terrafrom commands especially when using AWS Role Assumption.
> Using this Docker container would provide a wrapper for Terraform CLI tools; in other words, any Terraform commands are a valid commands while using this container.


## Table of Contents
* [Quick References](#quick-references)
* [How to use](#how-to-use)
    + [With AWS Assume Role](#with-aws-assume-role)
    + [Without AWS Assume Role](#without-aws-assume-role)
* [Additional Examples](#additional-examples)


## Quick References
* [Terraform Docs](https://www.terraform.io/docs/index.html)
* [Docker Docs](https://docs.docker.com/)


## How to use
### With AWS Assume Role
```BASH
$ docker run --rm -v "$PWD":/terraform-src \
    -e AWS_ACCESS_KEY_ID="YOUR_AWS_ACCESS_KEY_ID" \
    -e AWS_SECRET_ACCESS_KEY="YOUR_AWS_SECRET_ACCESS_KEY" \
    -e AWS_ROLE_ARN="YOUR_AWS_ROLE_ARN" \
    -e TERRAFORM_WORKSPACE="WORKSPACE_NAME" \
    minakhalil/docker-terraform terraform plan
```
### Without AWS Assume Role
```BASH
$ docker run --rm -v "$PWD":/terraform-src \
    -e AWS_ACCESS_KEY_ID="YOUR_AWS_ACCESS_KEY_ID" \
    -e AWS_SECRET_ACCESS_KEY="YOUR_AWS_SECRET_ACCESS_KEY" \
    minakhalil/docker-terraform terraform plan
```

## Additional Examples
1. Creating new Worksapce
```BASH
$ docker run --rm -v "$PWD":/terraform-src \
    -e AWS_ACCESS_KEY="YOUR_AWS_ACCESS_KEY_ID" \
    -e AWS_SECRET_ACCESS_KEY="YOUR_AWS_SECRET_ACCESS_KEY" \
    minakhalil/docker-terraform terraform workspace new WORKSPACE_NAME
```

2. Applying Terraform changes
```BASH
$ docker run --rm -v "$PWD":/terraform-src \
    -e AWS_ACCESS_KEY="YOUR_AWS_ACCESS_KEY_ID" \
    -e AWS_SECRET_ACCESS_KEY="YOUR_AWS_SECRET_ACCESS_KEY" \
    minakhalil/docker-terraform terraform apply -auto-approve
```

3. Desstroying Terraform stack
```BASH
$ docker run --rm -v "$PWD":/terraform-src \
    -e AWS_ACCESS_KEY="YOUR_AWS_ACCESS_KEY_ID" \
    -e AWS_SECRET_ACCESS_KEY="YOUR_AWS_SECRET_ACCESS_KEY" \
    minakhalil/docker-terraform terraform destroy -auto-approve
```

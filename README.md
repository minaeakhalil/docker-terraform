# Docker for Terraform
## Quick References
* [Terraform Docs](https://www.terraform.io/docs/index.html)
* [Docker Docs](https://docs.docker.com/)


## How to use
### With AWS Assume Role
```BASH
$ docker run --rm -v TERRAFORM_SRC_CODE:/terraform-src -e AWS_ACCESS_KEY_ID="YOUR_AWS_ACCESS_KEY_ID" -e AWS_SECRET_ACCESS_KEY="YOUR_AWS_SECRET_ACCESS_KEY" -e AWS_ROLE_ARN="YOUR_AWS_ROLE_ARN" minakhalil/terraform terraform-wrapper plan
```
### Without AWS Assume Role
```BASH
$ docker run --rm -v TERRAFORM_SRC_CODE:/terraform-src -e AWS_ACCESS_KEY_ID="YOUR_AWS_ACCESS_KEY_ID" -e AWS_SECRET_ACCESS_KEY="YOUR_AWS_SECRET_ACCESS_KEY" minakhalil/terraform terraform-wrapper plan
```

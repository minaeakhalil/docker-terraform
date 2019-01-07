# Build Stage
FROM amazonlinux:2 AS build-env

# Install required packages
RUN yum install -y \
  wget \
  unzip

# Download and install Terraform
RUN wget -O /tmp/terraform.zip https://releases.hashicorp.com/terraform/0.11.11/terraform_0.11.11_linux_amd64.zip \
  && unzip /tmp/terraform.zip -d /usr/local/bin/

# Final Stage
FROM amazonlinux:2 AS runtime

# Copy Terraform Binary from build env
COPY --from=build-env /usr/local/bin /usr/bin

# Cope terraform custom wrapper
COPY scripts/terraform-wrapper.sh /usr/local/bin/terraform

RUN chmod +x /usr/local/bin/terraform

WORKDIR /infra

# Terraform Environment Variables
ENV TERRAFORM_WORKSPACE default

# AWS Environments Variables
ENV AWS_ACCESS_KEY_ID=""
ENV AWS_SECRET_ACCESS_KEY=""
ENV AWS_ROLE_ARN=""

CMD /usr/local/bin/terraform

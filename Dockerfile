# Build Stage
FROM ubuntu:17.10 AS build-env

RUN apt-get update \
    && apt-get install -y

# Install Terraform
RUN apt-get install -y \
      wget \
      unzip \
      curl

RUN mkdir /src \
    && curl https://bootstrap.pypa.io/get-pip.py -o /src/get-pip.py

# Install Terraform
RUN wget -O /tmp/terraform.zip https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_amd64.zip \
    && unzip /tmp/terraform.zip -d /usr/local/bin/

# # Clean up
# RUN apt-get --purge -y remove \
#       wget \
#       unzip \
#     && apt-get --purge -y autoremove


# Final Stage
FROM ubuntu:17.10 AS runtime

COPY --from=build-env /src /src

COPY --from=build-env /usr/local/bin /usr/local/bin

COPY scripts/terraform-wrapper.sh /usr/local/bin/terraform-wrapper

RUN apt-get update \
    && apt-get install -y \
        python \
        jq

RUN python /src/get-pip.py \
    && pip install awscli

WORKDIR /terraform-src

ENV TERRAFORM_WORKSPACE develop

ENTRYPOINT terraform-wrapper

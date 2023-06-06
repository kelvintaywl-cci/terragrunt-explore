FROM continuumio/miniconda3:4.10.3p0-alpine

ENV TERRAFORM_VERSION=1.3.6

# Set the Terragrunt version to install
ENV TERRAGRUNT_VERSION=0.43.2

# Set the kubectl version to install
ENV KUBECTL_VERSION=1.24

### Instll required dependencies ######
RUN apk add --no-cache             \
    bash                           \
    git                            \
    unzip                          \
    curl                           \
    gettext                        \
    wget                           \
    jq


##########Install aws cli########### 
RUN curl -q "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
  unzip -q awscliv2.zip && \
  ./aws/install 1>/dev/null

##########Install kubectl ########### 
RUN curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/${KUBECTL_VERSION}/2023-03-17/bin/linux/amd64/kubectl

#### Install Terraform #####
RUN wget --quiet https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && mv terraform /usr/bin \
    && rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

#### Install helm ######
RUN wget https://get.helm.sh/helm-v3.9.3-linux-amd64.tar.gz
RUN tar xvf helm-v3.9.3-linux-amd64.tar.gz
RUN mv linux-amd64/helm /usr/local/bin
RUN helm version

#### Install Terragrunt ######
# Download the Terragrunt binary
RUN wget "https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64" -O terragrunt

# Make the binary executable
RUN chmod +x terragrunt

# Move the binary to /usr/local/bin
RUN mv terragrunt /usr/local/bin/

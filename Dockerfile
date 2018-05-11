FROM golang:1.10-alpine

ENV GOPATH=/go

# Install build dependencies
RUN apk add --update git wget openssh unzip

# Install Azure provider
RUN mkdir -p /go/src/github.com/terraform-providers && \
    git clone --depth 1 -b v1.4.0 https://github.com/terraform-providers/terraform-provider-azurerm.git /go/src/github.com/terraform-providers/terraform-provider-azurerm && \
    cd /go/src/github.com/terraform-providers/terraform-provider-azurerm && go build && go install && \
    rm -rf /go/src/github.com/terraform-providers/terraform-provider-azurerm

# Install Terraform
RUN wget https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_amd64.zip && \
    unzip terraform_*.zip -d /go/bin/ && \
    rm -f terraform_*.zip

ENTRYPOINT ["/go/bin/terraform"]

# XXX: doesn't work for unknown reason - terraform is fine but azure plugin
# will not authenticate (even when building with CGO_ENABLED=0)
#FROM alpine
#COPY --from=0 /go/bin/terraform /usr/local/bin/terraform
#COPY --from=0 /go/bin/terraform-provider-azurerm /usr/local/bin/terraform-provider-azurerm
#ENTRYPOINT ["/usr/local/bin/terraform"]

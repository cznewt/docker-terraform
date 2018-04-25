FROM golang:1.10-stretch

ENV GOPATH=/go
ENV CGO_ENABLED=0

RUN mkdir -p /go/src/github.com/terraform-providers
RUN git clone -b v1.3.3 https://github.com/fpytloun/terraform-provider-azurerm.git /go/src/github.com/terraform-providers/terraform-provider-azurerm
RUN cd /go/src/github.com/terraform-providers/terraform-provider-azurerm && go build && go install

RUN go get github.com/hashicorp/terraform

FROM alpine
COPY --from=0 /go/bin/terraform /usr/local/bin/terraform
COPY --from=0 /go/bin/terraform-provider-azurerm /usr/local/bin/terraform-provider-azurerm
ENTRYPOINT ["/usr/local/bin/terraform"]

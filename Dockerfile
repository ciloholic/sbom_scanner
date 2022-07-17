ARG GO_VERSION
ARG GOLANGCI_VERSION

FROM golangci/golangci-lint:v$GOLANGCI_VERSION AS golangci-lint

FROM golang:$GO_VERSION

COPY --from=golangci-lint /usr/bin/golangci-lint /usr/local/bin/

WORKDIR /sbomer

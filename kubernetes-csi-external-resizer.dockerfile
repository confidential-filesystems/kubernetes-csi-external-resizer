FROM confidentialfilesystems/go:v1.21.7-amd64 AS builder

ARG VERSION=v1.9.2-filesystem-d2

RUN mkdir -p -m 0600 ~/.ssh && \
    ssh-keyscan -H github.com >> ~/.ssh/known_hosts
RUN cat <<EOF > ~/.gitconfig
[url "ssh://git@github.com/"]
    insteadOf = https://github.com/
EOF

WORKDIR /usr/src
COPY . kubernetes-csi-external-resizer
RUN --mount=type=ssh cd kubernetes-csi-external-resizer && go mod download && \
    CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags "-X 'main.version=${VERSION}'" ./cmd/csi-resizer

FROM confidentialfilesystems/static:v2.40-amd64

COPY --from=builder /usr/src/kubernetes-csi-external-resizer/csi-resizer /csi-resizer

ENTRYPOINT ["/csi-resizer"]
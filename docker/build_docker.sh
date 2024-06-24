#!/bin/bash

set -e
SERVICE_NAME=local-csi-resizer
VERSION=v1.9.2-d1
HUB=hub.confidentialfilesystems.com:4443

git pull

CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags "-X 'main.version=${VERSION}'" ../cmd/csi-resizer

docker build -f ./Dockerfile -t ${HUB}/cc/${SERVICE_NAME}:${VERSION} .
docker push ${HUB}/cc/${SERVICE_NAME}:${VERSION}

rm -f csi-resizer
echo "build time: $(date)"
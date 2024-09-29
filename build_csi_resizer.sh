#!/bin/bash

set -e
SERVICE_NAME=kubernetes-csi-external-resizer
HUB=hub.confidentialfilesystems.com:30443
VERSION=${1:-v1.9.2-filesystem-r1}
SSH_KEY=${2:-$HOME/.ssh/id_rsa}

docker build --ssh default=${SSH_KEY} --build-arg VERSION=${VERSION} -f ./kubernetes-csi-external-resizer.dockerfile -t ${HUB}/cc/${SERVICE_NAME}:${VERSION} .
docker push ${HUB}/cc/${SERVICE_NAME}:${VERSION}

echo "build time: $(date)"

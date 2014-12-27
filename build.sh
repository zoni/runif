#!/bin/bash

set -e
set -x

WORKDIR=${GOPATH}/src/github.com/zoni/runif/
BUILDAREA=/build-source/build-area/

rm --recursive --force $BUILDAREA
mkdir --parents $WORKDIR
ln --symbolic $BUILDAREA $WORKDIR/build-area

cd $WORKDIR
cp --recursive /build-source/* .
mkdir $BUILDAREA

go get

per-go-platform go build -v -o build-area/runif-\$GOOS-\$GOARCH\$GOARM
cd build-area
strip * || true  # It's okay not all files can be stripped
sha256sum * > sha256sums

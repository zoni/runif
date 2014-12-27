FROM zoni/gobuild
MAINTAINER Nick Groenen

ADD build-runif.sh /build-runif.sh

RUN mkdir -p ${GOPATH}/src/github.com/zoni/runif
ADD . ${GOPATH}/src/github.com/zoni/runif

RUN /build-runif.sh

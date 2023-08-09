#
# Dockerfile for vlmcsd
#

FROM alpine:latest as builder

RUN set -ex \
  && apk add --update --no-cache \
     git \
     make \
     build-base \
  && rm -rf /tmp/* /var/cache/apk/*

ENV REPO_URL https://github.com/Wind4/vlmcsd.git

WORKDIR /builder

RUN set -ex \
  && git clone --depth 1 -q ${REPO_URL} . \
  && make \
  && ls bin \
  && bin/vlmcsd -V

FROM alpine:latest

COPY --from=builder /builder/bin /usr/local/bin

EXPOSE 1688/tcp

CMD ["vlmcsd","-D","-d","-e","-v"]

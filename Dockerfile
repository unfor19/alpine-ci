ARG ALPINE_VERSION="3.12"
ARG BASH_VERSION="5.0"
ARG CURL_VERSION="7.69"
ARG GIT_VERSION="2.26"
ARG OPENSSH_VERSION="8.3"
ARG ZIP_VERSION="3.0"

FROM alpine:${ALPINE_VERSION}

# Fetch build arguments
ARG BASH_VERSION
ARG CURL_VERSION
ARG GIT_VERSION
ARG OPENSSH_VERSION
ARG ZIP_VERSION

RUN apk --update add \
  bash=~"${BASH_VERSION}" \
  curl=~"${CURL_VERSION}" \
  git=~"${GIT_VERSION}" \
  openssh=~"${OPENSSH_VERSION}" \
  zip=~"${ZIP_VERSION}" \
  && \
  rm -rf /var/lib/apt/lists/* && \
  rm /var/cache/apk/*

ENTRYPOINT bash

ARG ALPINE_VERSION="3.12"

FROM alpine:${ALPINE_VERSION}

# Fetch build arguments
ARG ALPINECI_VERSION_PATH="/opt/alpineci_version"
ARG BASH_VERSION="5.0"
ARG CURL_VERSION="7.69"
ARG GIT_VERSION="2.26"
ARG JQ_VERSION="1.6"
ARG OPENSSH_VERSION="8.3"
ARG ZIP_VERSION="3.0"

RUN apk --update add \
  bash=~"${BASH_VERSION}" \
  curl=~"${CURL_VERSION}" \
  git=~"${GIT_VERSION}" \
  openssh=~"${OPENSSH_VERSION}" \
  zip=~"${ZIP_VERSION}" \
  && \
  wget -q -O jq "https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64" && \
  chmod +x jq && mv jq /usr/local/bin/jq \
  && \
  rm -rf /var/lib/apt/lists/* && \
  rm /var/cache/apk/*

COPY version "$ALPINECI_VERSION_PATH"

ENTRYPOINT bash

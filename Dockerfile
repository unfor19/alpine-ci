ARG ALPINE_VERSION="3.14"

FROM alpine:${ALPINE_VERSION} as alpine-ci
WORKDIR /tmp/

# Fetch build arguments
ARG DOCKER_VERSION_FILE_PATH="/opt/alpineci_version"
ARG BASH_VERSION="5.1"
ARG CURL_VERSION="7.79"
ARG GIT_VERSION="2.32"
ARG JQ_VERSION="1.6"
ARG OPENSSH_VERSION="8.6"
ARG ZIP_VERSION="3.0"
ARG OPENSSL_VERSION="1.1.1"

RUN apk --update add \
  bash=~"${BASH_VERSION}" \
  curl=~"${CURL_VERSION}" \
  git=~"${GIT_VERSION}" \
  openssh=~"${OPENSSH_VERSION}" \
  zip=~"${ZIP_VERSION}" \
  openssl=~"${OPENSSL_VERSION}" \
  make \
  && \
  wget -q -O jq "https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64" && \
  chmod +x jq && mv jq /usr/local/bin/jq \
  && \
  rm -rf /var/lib/apt/lists/* && \
  rm /var/cache/apk/*

COPY version "$DOCKER_VERSION_FILE_PATH"

ENTRYPOINT bash



### ----------------------------------
### AWS CLI Builder
### ----------------------------------
FROM python:3.8-alpine${ALPINE_VERSION} as awscli-builder

ARG AWSCLI_VERSION="2.4.13"

RUN apk add --no-cache \
  gcc \
  git \
  libc-dev \
  libffi-dev \
  openssl-dev \
  py3-pip \
  zlib-dev \
  make \
  cmake

RUN git clone --recursive  --depth 1 --branch ${AWSCLI_VERSION} --single-branch https://github.com/aws/aws-cli.git
WORKDIR /aws-cli
# Follow https://github.com/six8/pyinstaller-alpine to install pyinstaller on alpine
RUN pip install --no-cache-dir --upgrade pip \
  && pip install --no-cache-dir pycrypto \
  && git clone --depth 1 --single-branch --branch v$(grep PyInstaller requirements-build.txt | cut -d'=' -f3) https://github.com/pyinstaller/pyinstaller.git /tmp/pyinstaller \
  && cd /tmp/pyinstaller/bootloader \
  && CFLAGS="-Wno-stringop-overflow -Wno-stringop-truncation" python ./waf configure --no-lsb all \
  && pip install .. \
  && rm -Rf /tmp/pyinstaller \
  && cd - \
  && boto_ver=$(grep botocore setup.cfg | cut -d'=' -f3) \
  && git clone --single-branch --branch v2 https://github.com/boto/botocore /tmp/botocore \
  && cd /tmp/botocore \
  && git checkout $(git log --grep $boto_ver --pretty=format:"%h") \
  && pip install . \
  && rm -Rf /tmp/botocore  \
  && cd -
RUN sed -i '/botocore/d' requirements.txt \
  && scripts/installers/make-exe
RUN unzip dist/awscli-exe.zip && \
  ./aws/install --bin-dir /aws-cli-bin


# AWS CLI
FROM alpine-ci as awscli
RUN apk --no-cache add groff
COPY --from=awscli-builder /usr/local/aws-cli/ /usr/local/aws-cli/
COPY --from=awscli-builder /aws-cli-bin/ /usr/local/bin/
ENTRYPOINT [ "bash", "-c" ]


# AWS CLI + Docker
FROM awscli as awscli-docker
ARG DOCKER_VERSION="20.10"
RUN apk --no-cache add docker=~"$DOCKER_VERSION"
ENTRYPOINT [ "bash", "-c" ]

# AWS CLI + Docker + Python
FROM awscli-docker as docker-python
RUN apk add --no-cache python3 py3-pip

# Dev
FROM awscli as dev
WORKDIR /src/
ENTRYPOINT [ "bash" ]

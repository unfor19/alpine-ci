#!/usr/bin/env bash
set -e
set -o pipefail

_DOCKER_BUILD_TARGET="${1:-"$DOCKER_BUILD_TARGET"}"
_DOCKER_BUILD_TARGET="${_DOCKER_BUILD_TARGET:-"alpine-ci"}"
_DOCKER_TAG_LATEST="${DOCKER_TAG_LATEST:-"unfor19/alpine-ci:latest"}"
_VERSION_FILE_PATH="${VERSION_FILE_PATH:-"version"}"
_GIT_SHORT_COMMIT="${GIT_SHORT_COMMIT:-"$(git rev-parse --short HEAD)"}"
_DOCKER_TAG_COMMIT="${DOCKER_TAG_COMMIT:-"unfor19/alpine-ci:${_GIT_SHORT_COMMIT}"}"

declare -a build_args
version_list=($(cat "$_VERSION_FILE_PATH"))
for item in "${version_list[@]}"; do
    if [[ -n "$item" && $item != *DOCKER_TAG_* ]]; then
        var_name=$(echo "$item" | cut -d'=' -f 1 )
        var_value=$(echo "$item" | cut -d'=' -f 2 )
    build_args+=("--build-arg ${var_name}=${var_value}")
    fi
done
build_args+=("--build-arg VERSION_FILE_PATH=${_VERSION_FILE_PATH}")
echo Build arguments: "${build_args[@]}"
docker build --file Dockerfile --target "${_BUILD_TARGET}" --tag "${_DOCKER_TAG_LATEST}" --tag "${_DOCKER_TAG_COMMIT}" ${build_args[@]} .

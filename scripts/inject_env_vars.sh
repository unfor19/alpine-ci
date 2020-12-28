#!/bin/bash
set -e

main(){
  local version_list
  version_list=("$(< version)")
  for item in "${version_list[@]}"; do
    echo "$item" >> "$GITHUB_ENV"
  done
}


main

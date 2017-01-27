#!/bin/bash

function __readDependency() {
  local base_path="."
  if [[ $4 != "" ]]; then
    base_path=$4
  fi

  if [ -e $base_path/version.json ]; then
    local dependency=$1
    local url_var=$2
    local tag_var=$3
    local path=$(sed -n "/$dependency/p" $base_path/version.json | awk -F'"' '{print $4}')
    local url=$(echo $path | awk -F"#" '{print $1}')
    local tag=$(echo $path | awk -F"#" '{print $2}')

    eval $url_var="$url"
    eval $tag_var="$tag"
  else
    echo "Unable to find version.json file"
    exit 1
  fi
}

function __version() {
  local base_path="."
  if [ -n $1 ]; then
    base_path=$1
  fi
  local version=""
  if [ -e $base_path/VERSION ]; then
    version=$(cat VERSION)
  elif [ -e $base_path/version.json ]; then
    version=$(grep version version.json | cut -f 2 -d: | cut -f 2 -d \")
  else
    echo "Unable to find VERSION/version.json file"
    exit 1
  fi

  echo $version
}

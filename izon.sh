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
}

function getVersionFile() {
    #if needed, get the version.json that resolves dependent repos from another github repo
  if [ ! -f "$VERSION_JSON" ]; then
    if [[ $currentDir == *"$REPO_NAME" ]]; then
      if [[ ! -f manifest.yml ]]; then
        echo "We noticed you are in a directory named $REPO_NAME but the usual contents are not here, please rename the dir or do a git clone of the whole repo.  If you rename the dir, the script will get the repo."
        exit 1
      fi
    fi
    #echo $VERSION_JSON_URL
    curl -s -O $VERSION_JSON_URL
  fi
}

function getLocalSetupFuncs() {
  #get the predix-scripts url and branch from the version.json
  __readDependency $PREDIX_SCRIPTS PREDIX_SCRIPTS_URL PREDIX_SCRIPTS_BRANCH
  LOCAL_SETUP_FUNCS_URL=https://raw.githubusercontent.com/brajpanda/$PREDIX_SCRIPTS/$PREDIX_SCRIPTS_BRANCH/bash/scripts/local-setup-funcs.sh
  echo $LOCAL_SETUP_FUNCS_URL
  if [ -f "local-setup-funcs.sh" ]; then
    rm local-setup-funcs.sh
  fi
  if [ ! -f "local-setup-funcs.sh" ]; then
    curl -s -O $LOCAL_SETUP_FUNCS_URL
  fi
  source local-setup-funcs.sh
}

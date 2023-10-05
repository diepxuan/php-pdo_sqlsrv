#!/usr/bin/env bash
#!/bin/bash

set -e
# set -u
. $(dirname $(realpath "$BASH_SOURCE"))/head.sh

env() {
    param=$1
    value=$2
    if [ "$(cat $GITHUB_ENV | grep $param= 2>/dev/null | wc -l)" != "0" ]; then
        sed -i "s|$param=.*|$param=$value|" $GITHUB_ENV
    else
        echo "$param=$value" >>$GITHUB_ENV
    fi
}

# INPUT_SOURCE_DIR=${INPUT_SOURCE_DIR:-"src"}
# INPUT_HOST_ARCH=${INPUT_HOST_ARCH:-""}
env INPUT_SOURCE_DIR ${INPUT_SOURCE_DIR:-"src"}
env INPUT_HOST_ARCH ${INPUT_HOST_ARCH:-""}

# source_dir=$(realpath ./$INPUT_SOURCE_DIR)
# dists_dir=$(realpath ./dists)
# ci_dir=$(dirname $(realpath "$BASH_SOURCE"))
# pwd_dir=$(pwd || dirname $(realpath "$0") || realpath .)

env source_dir $(realpath ./$INPUT_SOURCE_DIR)
env dists_dir $(realpath ./dists)
env ci_dir $(dirname $(realpath "$BASH_SOURCE"))
env pwd_dir $(pwd || dirname $(realpath "$0") || realpath .)

# user evironment
env email ductn@diepxuan.com
env changelog $INPUT_SOURCE_DIR/debian/changelog

# plugin
env owner runkit7
env project runkit7

# os evironment
CODENAME=${CODENAME:-$DISTRIB_CODENAME}
CODENAME=${CODENAME:-$VERSION_CODENAME}
CODENAME=${CODENAME:-$UBUNTU_CODENAME}

RELEASE=${RELEASE:-$(echo $DISTRIB_DESCRIPTION | awk '{print $2}')}
RELEASE=${RELEASE:-$(echo $VERSION | awk '{print $1}')}
RELEASE=${RELEASE:-$(echo $PRETTY_NAME | awk '{print $2}')}
RELEASE=${RELEASE:-${DISTRIB_RELEASE}}
RELEASE=${RELEASE:-${VERSION_ID}}

DISTRIB=${DISTRIB:-$DISTRIB_ID}
DISTRIB=${DISTRIB:-$ID}
DISTRIB=$(echo "$DISTRIB" | awk '{print tolower($0)}')

env CODENAME $CODENAME
env RELEASE $RELEASE
env DISTRIB $DISTRIB

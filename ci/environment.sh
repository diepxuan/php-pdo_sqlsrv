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

env source_dir $(realpath ./src)
env dists_dir $(realpath ./dists)
env ci_dir $(dirname $(realpath "$BASH_SOURCE"))
env pwd_dir $(pwd || dirname $(realpath "$0") || realpath .)

# user evironment
env email ductn@diepxuan.com
env changelog $(realpath ./src/debian/changelog)
env timelog=${BUILDPACKAGE_EPOCH:-$(date -R)}

# plugin
echo "repository: $repository"
owner=$(echo $repository | cut -d '/' -f1)
project=$(echo $repository | cut -d '/' -f2)
module=$(echo $project | sed 's/^php-//g')
echo "$owner - $project - $module"
env owner $owner
env project $project
env module $module

# os evironment
[[ -f /etc/os-release ]] && . /etc/os-release
[[ -f /etc/lsb-release ]] && . /etc/lsb-release
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

#!/usr/bin/env bash
#!/bin/bash

set -e
# set -u
. $(dirname $(realpath "$BASH_SOURCE"))/head.sh

cd $source_dir
# shellcheck disable=SC2086
__build_status=$(dpkg-buildpackage $BUILDPACKAGE_OPTS) 2>&1
cd -

package=$(echo "$__build_status" | grep _source.changes | grep signfile | sed 's| signfile ||g')
[[ -n $package ]] && echo "SOURCEPACKAGE_PATH=$package" >>$GITHUB_ENV

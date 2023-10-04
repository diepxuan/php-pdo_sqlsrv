#!/usr/bin/env bash
#!/bin/bash

set -e
# set -u
. $(dirname $(realpath "$BASH_SOURCE"))/head.sh

cd $source_dir
# shellcheck disable=SC2086
dpkg-buildpackage $BUILDPACKAGE_OPTS 2>&1
cd -

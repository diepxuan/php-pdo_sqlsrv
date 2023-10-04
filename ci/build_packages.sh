#!/usr/bin/env bash
#!/bin/bash

set -e
# set -u
. $(dirname $(realpath "$BASH_SOURCE"))/head.sh

# Adapted from pbuilder's support for cross-compilation:
if [ -n "$INPUT_HOST_ARCH" ]; then
    if [ -z "${CONFIG_SITE-}" ]; then
        export CONFIG_SITE="/etc/dpkg-cross/cross-config.$INPUT_HOST_ARCH"
    fi
    export DEB_BUILD_OPTIONS="${DEB_BUILD_OPTIONS:+$DEB_BUILD_OPTIONS }nocheck"
    export DEB_BUILD_PROFILES="${DEB_BUILD_PROFILES:+$DEB_BUILD_PROFILES }cross nocheck"
    INPUT_BUILDPACKAGE_OPTS="$INPUT_BUILDPACKAGE_OPTS --host-arch=$INPUT_HOST_ARCH"
fi

cd $source_dir
# shellcheck disable=SC2086
dpkg-buildpackage $INPUT_BUILDPACKAGE_OPTS
cd -

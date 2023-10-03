#!/usr/bin/env bash
#!/bin/bash

set -e
# set -u

# Usage:
#   error MESSAGE
error() {
    echo "::error::$1"
}

# Usage:
#   end_group
end_group() {
    echo "::endgroup::"
}

# Usage:
#   start_group GROUP_NAME
start_group() {
    echo "::group::$1"
}

clean_up() {
    rm --force --recursive -- "${build_dir-}"
}

build_dir=$(mktemp --directory --tmpdir="${RUNNER_TEMP-}" build-deb-action-XXXXXX) || exit 1
ci_dir=$(dirname $(realpath "$BASH_SOURCE")) || exit 1
trap clean_up EXIT INT HUP TERM

INPUT_SOURCE_DIR=src
INPUT_HOST_ARCH=$INPUT_HOST_ARCH || ''

start_group "Installing build dependencies"
. $ci_dir/install_build_deps.sh
end_group

start_group "Updating build information"
. $ci_dir/update_packages.sh
end_group

start_group "Building package binary"
. $ci_dir/build_packages.sh
end_group

start_group "Building package source"
INPUT_BUILDPACKAGE_OPTS="$INPUT_BUILDPACKAGE_OPTS -S"
. $ci_dir/build_packages.sh
end_group

__build() {
    local old_pwd=$(pwd)
    # git submodule add -b 4.0.0a6 git@github.com:runkit7/runkit7.git src/runkit7-4.0.0a6
    # git submodule update --init -f
    cp src/runkit7-4.0.0a6/package.xml src/package.xml

    cd ./src/
    dpkg-buildpackage
    cd - >/dev/null

    cd ./src/
    __build_status=$(dpkg-buildpackage -S 2>&1)
    cd - >/dev/null

    mkdir -p dists
    mv *.ddeb *.deb *.buildinfo *.changes *.dsc *.tar.xz *.tar.gz *.tar.* dists/ >/dev/null 2>&1
}

__dput_ppa() {
    package=dists/$(echo "$__build_status" | grep _source.changes | grep signfile | sed 's| signfile ||g')
    dput ductn-ppa $package
}

# if [[ -n $* ]]; then
#     "__$@"
# fi

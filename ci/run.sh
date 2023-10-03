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

INPUT_SOURCE_DIR=src
INPUT_HOST_ARCH=$INPUT_HOST_ARCH || ''

source_dir=$(realpath ./$INPUT_SOURCE_DIR)
dists_dir=$(realpath ./dists)
ci_dir=$(dirname $(realpath "$BASH_SOURCE"))
pwd_dir=$(pwd || dirname $(realpath "$0") || realpath .)

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

start_group "Put packages"
. $ci_dir/put_packages.sh
end_group

__dput_ppa() {
    package=dists/$(echo "$__build_status" | grep _source.changes | grep signfile | sed 's| signfile ||g')
    dput ductn-ppa $package
}

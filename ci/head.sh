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

INPUT_SOURCE_DIR=${INPUT_SOURCE_DIR:-"src"}
INPUT_HOST_ARCH=${INPUT_HOST_ARCH:-""}

source_dir=$(realpath ./$INPUT_SOURCE_DIR)
dists_dir=$(realpath ./dists)
ci_dir=$(dirname $(realpath "$BASH_SOURCE"))
pwd_dir=$(pwd || dirname $(realpath "$0") || realpath .)

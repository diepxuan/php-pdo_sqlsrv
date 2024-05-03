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

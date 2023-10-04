#!/usr/bin/env bash
#!/bin/bash

set -e
# set -u
. $(dirname $(realpath "$BASH_SOURCE"))/head.sh

cat | tee ~/.dput.cf <<-EOF
[caothu91ppa]
fqdn = ppa.launchpad.net
method = ftp
incoming = ~caothu91/ubuntu/ppa/
login = anonymous
allow_unsigned_uploads = 0
EOF

release_package=$(cat $changelog | head -n 1 | awk '{print $1}')
release_version=$(cat $changelog | head -n 1 | awk '{print $2}' | sed 's|[()]||g')

package=$(ls -a $dists_dir | grep ${release_package}_${release_version} | grep _source.changes | head -n 1)
[[ -n $package ]] &&
    package=$dists_dir/$package &&
    [[ -f $package ]] &&
    dput caothu91ppa $package || true

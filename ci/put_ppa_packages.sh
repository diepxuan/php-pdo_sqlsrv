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

package=dists/$(ls dists/ | grep $(dpkg-scansources dists/ | grep .dsc | head -n 1 | awk '{print $3}' | sed 's|.dsc||g') | grep _source.changes)
dput caothu91ppa $package

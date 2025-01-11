#!/usr/bin/env bash
#!/bin/bash

set -e
# set -u
. $(dirname $(realpath "$BASH_SOURCE"))/head.sh

start_group "move package builder to dists"
regex='^php.*(.deb|.ddeb|.buildinfo|.changes|.dsc|.tar.xz|.tar.gz|.tar.[[:alpha:]]+)$'
mkdir -p $dists_dir
while read -r file; do
    mv -vf "$source_dir/$file" "$dists_dir/" || true
done < <(ls $source_dir/ | grep -E $regex)

while read -r file; do
    mv -vf "$pwd_dir/$file" "$dists_dir/" || true
done < <(ls $pwd_dir/ | grep -E $regex)
end_group

start_group "put package to ppa"
cat | tee ~/.dput.cf <<-EOF
[caothu91ppa]
fqdn = ppa.launchpad.net
method = ftp
incoming = ~caothu91/ubuntu/ppa/
login = anonymous
allow_unsigned_uploads = 0
EOF

package=$(ls -a $dists_dir | grep _source.changes | head -n 1)

[[ -n $package ]] &&
    package=$dists_dir/$package &&
    [[ -f $package ]] &&
    dput caothu91ppa $package || true
end_group

start_group "Put package to Personal Package archives"
git clone --depth=1 --branch=main git@github.com:diepxuan/ppa.git

rm -rf ppa/src/$repository
mkdir -p ppa/src/$repository/
cp -r src/. ppa/src/$repository/

cd ppa
if [ -n "$(git status --porcelain=v1 2>/dev/null)" ]; then
    git add src/
    git commit -m "${GIT_COMMITTER_MESSAGE:-'Auto-commit'}"
    if ! git push; then
        git stash
        git pull --rebase
        git stash pop
        git push || true
    fi
fi
end_group

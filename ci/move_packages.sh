#!/usr/bin/env bash
#!/bin/bash

set -e
# set -u
. $(dirname $(realpath "$BASH_SOURCE"))/head.sh
regex='^php.*(.deb|.ddeb|.buildinfo|.changes|.dsc|.tar.xz|.tar.gz|.tar.[[:alpha:]]+)$'

mkdir -p $dists_dir
ls $source_dir | grep -E $regex
ls $pwd_dir | grep -E $regex

while read -r file; do
    [[ -f "$source_dir/$file" ]] &&
        && echo "move $source_dir/$file to $dists_dir/"
        cp -urf "$source_dir/$file" "$dists_dir/" || true
done < <(ls $source_dir/ | grep -E $regex)

while read -r file; do
    [[ -f "$pwd_dir/$file" ]] &&
        && echo "move $pwd_dir/$file to $dists_dir/"
        cp -urf "$pwd_dir/$file" "$dists_dir/" || true
done < <(ls $pwd_dir/ | grep -E $regex)

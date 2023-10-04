#!/usr/bin/env bash
#!/bin/bash

set -e
# set -u

mkdir -p $dists_dir

while read -r file; do
    [[ -f "$source_dir/$file" ]] &&
        [[ ! -f "$dists_dir/$file" ]] &&
        cp -urf "$source_dir/$file" "$dists_dir/" || true
done < <(ls $source_dir/ | grep -E '^php.*(.deb|.ddeb|.buildinfo|.changes|.dsc|.tar.xz|.tar.gz|.tar.[[:alpha:]]+)$')

while read -r file; do
    [[ -f "$pwd_dir/$file" ]] &&
        [[ ! -f "$dists_dir/$file" ]] &&
        cp -urf "$pwd_dir/$file" "$dists_dir/" || true
done < <(ls $pwd_dir/ | grep -E '^php.*(.deb|.ddeb|.buildinfo|.changes|.dsc|.tar.xz|.tar.gz|.tar.[[:alpha:]]+)$')

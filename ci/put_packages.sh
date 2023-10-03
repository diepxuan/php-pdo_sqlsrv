#!/usr/bin/env bash
#!/bin/bash

set -e
# set -u

mkdir -p $dists_dir

while read -r file; do
    [[ -f "$source_dir/$file" ]] && cp "$source_dir/$file" "$dists_dir" || true
done < <(ls $source_dir/ | grep -E '^php.*(.deb|.ddeb|.buildinfo|.changes|.dsc|.tar.xz|.tar.gz|.tar.[[:alpha:]]+)$')

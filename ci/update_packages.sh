#!/usr/bin/env bash
#!/bin/bash

set -e
# set -u
. $(dirname $(realpath "$BASH_SOURCE"))/head.sh

pecl download $module
package_dist=$(ls | grep $module)
tar xvzf $package_dist -C $INPUT_SOURCE_DIR

ls -la $INPUT_SOURCE_DIR

# Update module sqlsrv release latest
release_tag=$(echo $package_dist | sed 's|.tgz||g' | cut -d '-' -f2)
old_release_tag=$(cat $changelog | head -n 1 | awk '{print $2}' | cut -d '+' -f1 | sed 's|[()]||g')
sed -i -e "0,/$old_release_tag/ s/$old_release_tag/$release_tag/g" $changelog

# Update os release latest
old_release_os=$(cat $changelog | head -n 1 | awk '{print $2}' | cut -d '+' -f2 | sed 's|[()]||g')
# sed -i -e "0,/$old_release_os/ s/$old_release_os/${DISTRIB}${RELEASE}/g" $changelog
sed -i -e "0,/$old_release_os/ s/$old_release_os//g" $changelog

# Update os codename
old_codename_os=$(cat $changelog | head -n 1 | awk '{print $3}')
sed -i -e "0,/$old_codename_os/ s/$old_codename_os/$CODENAME;/g" $changelog

# Update time building
BUILDPACKAGE_EPOCH=${BUILDPACKAGE_EPOCH:-$(date -R)}
sed -i -e "0,/<$email>  .*/ s/<$email>  .*/<$email>  $BUILDPACKAGE_EPOCH/g" $changelog

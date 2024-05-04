#!/usr/bin/env bash
#!/bin/bash

set -e
# set -u
. $(dirname $(realpath "$BASH_SOURCE"))/head.sh

stability=$(pecl search $module 2>/dev/null | grep ^$module | awk '{print $3}' | sed 's|[()]||g')
pecl download $module-$stability
# pecl download runkit7-alpha
package_dist=$(ls | grep $module)
tar xvzf $package_dist -C $source_dir

ls -la $source_dir

sed -i -e "s|_PROJECT_|$project|g" $control
sed -i -e "s|_PROJECT_|$project|g" $controlin
sed -i -e "s|_MODULE_|$module|g" $control
sed -i -e "s|_MODULE_|$module|g" $controlin

cat | tee "$source_dir/debian/$module.ini" <<-EOF
; configuration for pecl $module module
; priority=20
extension=$module.so
EOF

release_tag=$(echo $package_dist | sed 's|.tgz||g' | cut -d '-' -f2)
old_project=$(cat $changelog | head -n 1 | awk '{print $1}' | sed 's|[()]||g')
old_release_tag=$(cat $changelog | head -n 1 | awk '{print $2}' | sed 's|[()]||g')
old_codename_os=$(cat $changelog | head -n 1 | awk '{print $3}')

sed -i -e "s|$old_project|$project|g" $changelog
sed -i -e "s|$old_release_tag|$release_tag|g" $changelog
sed -i -e "s|$old_codename_os|$CODENAME|g" $changelog
sed -i -e "s|<$email>  .*|<$email>  $timelog|g" $changelog

. $ci_dir/package_update.$module.sh

rm -rf "$control-e"
rm -rf "$controlin-e"
rm -rf "$changelog-e"

start_group log
cat $control
cat $controlin
cat $changelog
end_group

#!/usr/bin/env bash
#!/bin/bash

set -e

sed -i -e "s|php-all-dev, tar|php-all-dev, tar, unixodbc-dev, unixodbc|g" $control
sed -i -e "s|php-all-dev, tar|php-all-dev, tar, unixodbc-dev, unixodbc|g" $controlin
sed -i -e "s|\${shlibs:Depends}$|\${shlibs:Depends}, msodbcsql18|g" $control
sed -i -e "s|\${shlibs:Depends}$|\${shlibs:Depends}, msodbcsql18|g" $controlin
rm -rf "$control-e"
rm -rf "$controlin-e"

cat | tee -a $rules <<-EOF

override_dh_shlibdeps:
	dh_shlibdeps --dpkg-shlibdeps-params=--ignore-missing-info
EOF

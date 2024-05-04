#!/usr/bin/env bash
#!/bin/bash

set -e

sed -i -e "s|php-all-dev, tar|php-all-dev, tar, unixodbc-dev, unixodbc|g" $control
sed -i -e "s|php-all-dev, tar|php-all-dev, tar, unixodbc-dev, unixodbc|g" $controlin
sed -i -e "s|\${shlibs:Depends}$|\${shlibs:Depends}, msodbcsql18|g" $control
sed -i -e "s|\${shlibs:Depends}$|\${shlibs:Depends}, msodbcsql18|g" $controlin
rm -rf "$control-e"
rm -rf "$controlin-e"

printf "override_dh_shlibdeps:\n\tdh_shlibdeps --dpkg-shlibdeps-params=--ignore-missing-info" | tee -a $rules

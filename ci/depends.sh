#!/usr/bin/env bash
#!/bin/bash

set -e
# set -u
. $(dirname $(realpath "$BASH_SOURCE"))/head.sh

APT_CONF_FILE=/etc/apt/apt.conf.d/50build-deb-action

export DEBIAN_FRONTEND=noninteractive

cat | sudo tee "$APT_CONF_FILE" <<-EOF
APT::Get::Assume-Yes "yes";
APT::Install-Recommends "no";
Acquire::Languages "none";
quiet "yes";
EOF

start_group "add apt source"
# debconf has priority “required” and is indirectly depended on by some
# essential packages. It is reasonably safe to blindly assume it is installed.
printf "man-db man-db/auto-update boolean false\n" | sudo debconf-set-selections

# curl https://packages.microsoft.com/keys/microsoft.asc | sudo tee /etc/apt/trusted.gpg.d/microsoft.asc
# curl https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/prod.list | sudo tee /etc/apt/sources.list.d/mssql-release.list

# add repository for install missing depends
sudo apt install software-properties-common
sudo add-apt-repository ppa:ondrej/php -y
end_group

start_group "install source depends"
sudo apt update
# shellcheck disable=SC2086
cat $controlin | tee $control
sudo apt build-dep $INPUT_APT_OPTS -- "$source_dir"

# In theory, explicitly installing dpkg-dev would not be necessary. `apt-get
# build-dep` will *always* install build-essential which depends on dpkg-dev.
# But let’s be explicit here.
# shellcheck disable=SC2086
sudo apt install $INPUT_APT_OPTS -- dpkg-dev libdpkg-perl dput devscripts $INPUT_EXTRA_BUILD_DEPS
end_group

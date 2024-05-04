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

# debconf has priority “required” and is indirectly depended on by some
# essential packages. It is reasonably safe to blindly assume it is installed.
printf "man-db man-db/auto-update boolean false\n" | sudo debconf-set-selections

# add repository for install missing depends
sudo apt install software-properties-common
sudo add-apt-repository ppa:ondrej/php -y

[[ -f $ci_dir/depends.$module.sh ]] && . $ci_dir/depends.$module.sh

sudo apt update

# shellcheck disable=SC2086
sudo apt build-dep $INPUT_APT_OPTS -- "./$INPUT_SOURCE_DIR"

# In theory, explicitly installing dpkg-dev would not be necessary. `apt-get
# build-dep` will *always* install build-essential which depends on dpkg-dev.
# But let’s be explicit here.
# shellcheck disable=SC2086
sudo apt install $INPUT_APT_OPTS -- dpkg-dev libdpkg-perl dput $INPUT_EXTRA_BUILD_DEPS
# sudo apt update
# sudo ACCEPT_EULA=Y apt install -y msodbcsql18
# # optional: for unixODBC development headers
# sudo apt install -y unixodbc-dev

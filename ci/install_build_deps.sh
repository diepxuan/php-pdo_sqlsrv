#!/usr/bin/env bash
#!/bin/bash

set -e
# set -u
. $(dirname $(realpath "$BASH_SOURCE"))/head.sh

APT_CONF_FILE=/etc/apt/apt.conf.d/50build-deb-action

export DEBIAN_FRONTEND=noninteractive

cat | tee "$APT_CONF_FILE" <<-EOF
APT::Get::Assume-Yes "yes";
APT::Install-Recommends "no";
Acquire::Languages "none";
quiet "yes";
EOF

# debconf has priority “required” and is indirectly depended on by some
# essential packages. It is reasonably safe to blindly assume it is installed.
printf "man-db man-db/auto-update boolean false\n" | debconf-set-selections

# add repository for install missing depends
apt install software-properties-common
grep -r "/ondrej/php" /etc/apt/sources.list /etc/apt/sources.list.d/*.list >/dev/null 2>&1 ||
    add-apt-repository ppa:ondrej/php -y

apt update

# shellcheck disable=SC2086
apt build-dep $INPUT_APT_OPTS -- "./$INPUT_SOURCE_DIR"

# In theory, explicitly installing dpkg-dev would not be necessary. `apt-get
# build-dep` will *always* install build-essential which depends on dpkg-dev.
# But let’s be explicit here.
# shellcheck disable=SC2086
apt install $INPUT_APT_OPTS -- dpkg-dev libdpkg-perl dput $INPUT_EXTRA_BUILD_DEPS

if ! [[ "18.04 20.04 22.04 23.04" == *"$(lsb_release -rs)"* ]]; then
    echo "Ubuntu $(lsb_release -rs) is not currently supported."
    exit
fi

curl https://packages.microsoft.com/keys/microsoft.asc | tee /etc/apt/trusted.gpg.d/microsoft.asc
curl https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/prod.list | tee /etc/apt/sources.list.d/mssql-release.list

apt update
ACCEPT_EULA=Y apt install -y msodbcsql18
# optional: for unixODBC development headers
apt install -y unixodbc-dev

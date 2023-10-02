#!/usr/bin/env bash
#!/bin/bash

__build() {
    __build_time

    local old_pwd=$(pwd)
    # git submodule add -b 4.0.0a6 git@github.com:runkit7/runkit7.git src/runkit7-4.0.0a6
    git submodule update --init -f
    cp src/runkit7-4.0.0a6/package.xml src/package.xml

    echo " - build package"
    echo "==============================="

    cd ./src/
    dpkg-buildpackage
    cd -

    echo " - build source"
    echo "==============================="
    cd ./src/
    dpkg-buildpackage -S
    cd -

    mkdir -p dists
    mv *.ddeb *.deb *.buildinfo *.changes *.dsc *.tar.xz dists/ >/dev/null 2>&1
}

__build_time() {
    cat src/debian/changelog | sed -e "0,/<ductn@diepxuan.com>  .*/ s/<ductn@diepxuan.com>  .*/<ductn@diepxuan.com>  $(date -R)/g" >src/debian/changelog
}

__dput_ppa() {
    packages=$(dpkg-scanpackages dists/ 2>/dev/null | grep "Filename:" | sed 's|Filename: ||g' | sed 's|_amd64.deb|_source.changes|g' | sed 's|_all.deb|_source.changes|g')

    for package in $packages; do
        [[ -f $package ]] && dput ductn-ppa $package
    done
}

__build
__dput_ppa

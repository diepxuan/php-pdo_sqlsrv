#!/usr/bin/env bash
#!/bin/bash

set -e
# set -u

mkdir -p dists
cp *.ddeb *.deb *.buildinfo *.changes *.dsc *.tar.xz *.tar.gz *.tar.* dists/

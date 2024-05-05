#!/usr/bin/env bash
#!/bin/bash

set -e

printf "override_dh_shlibdeps:\n\tdh_shlibdeps --dpkg-shlibdeps-params=--ignore-missing-info" | tee -a $rules

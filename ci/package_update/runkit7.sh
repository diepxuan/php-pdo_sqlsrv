#!/usr/bin/env bash
#!/bin/bash

set -e

cat | tee -a "$source_dir/debian/$module.ini" <<-EOF
runkit.internal_override=On
EOF

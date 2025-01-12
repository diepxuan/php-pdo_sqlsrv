#!/usr/bin/env bash
#!/bin/bash

for remote in $(git remote); do
    git push "$remote" HEAD
done

#!/bin/bash

# Populate the commonly used docker images.
IMAGES="
ubuntu
debian
"

for i in `echo "$IMAGES"`; do (
    ./import.sh "$i"
); done

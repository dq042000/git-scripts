#!/bin/bash

if [ -z "$2" ]; then
    echo "Commit message is required."
    exit 1
fi

git add --all && git commit -m "$2"

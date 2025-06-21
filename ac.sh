#!/bin/bash

if [ -z "$1" ]; then
    git add --all && git commit
else
    git add --all && git commit -m "$1"
fi
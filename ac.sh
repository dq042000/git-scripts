#!/bin/bash
branch=$(git rev-parse --abbrev-ref HEAD)
git add --all && git commit -m "$2"

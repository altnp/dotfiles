#!/usr/bin/env bash

current_branch=$(git rev-parse --abbrev-ref HEAD)

if [ -z "$current_branch" ]; then
  echo "Could not detect the current branch name."
  exit 1
fi

git push --set-upstream origin "$current_branch"

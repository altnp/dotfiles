#!/usr/bin/env bash
segments=()

ns="$(kubectl config view --minify --output 'jsonpath={..namespace}' 2>/dev/null)"
if [ -n "$ns" ] && [ "$ns" != "default" ]; then
  segments+=("#[fg=#316CE7]󱃾 $ns#[default]")
fi

if [ -n "$VIRTUAL_ENV" ]; then
  venv_name="${VIRTUAL_ENV##*/}"
  segments+=("#[fg=#F7CA40] $venv_name#[default]")
fi

aws_name="${AWS_VAULT:-$AWS_PROFILE}"
if [ -n "$aws_name" ]; then
  segments+=("#[fg=#F88F1D] $aws_name#[default]")
fi

printf '%s\n' "$(IFS=' | '; echo "${segments[*]}")"


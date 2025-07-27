#!/bin/zsh

function emufzf {
    local args=("$@")
    emulator -list-avds | sed 's/[^a-zA-Z0-9._-]//g' | fzf | xargs -r -I {} bash -c 'nohup emulator -avd "$1" "${@:2}" > /dev/null 2>&1 &' _ {} "${args[@]}"
}

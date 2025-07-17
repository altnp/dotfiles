#!/bin/zsh
function load-profile {
    if [[ $# -eq 0 ]]; then
        echo "No profile name specified"
        return
    fi

    local profileName="$1"
    local dir=""
    if [[ -n "$XDG_CONFIG_HOME" && -d "$XDG_CONFIG_HOME/envs" ]]; then
        dir="$XDG_CONFIG_HOME/envs"
    else
        dir="$HOME/.envs"
    fi
    local profilePath="$dir/$profileName.env"

    unload-profile

    if [[ -f "$profilePath" ]]; then
        while IFS='=' read -r key value || [ -n "$key" ]; do
            export "$key=$value"
            echo "Loaded $key"
        done <"$profilePath"
        export LOADED_ENV_PROFILE="$profileName"
    else
        echo "Profile: \"$profileName\" Not Found" >&2
    fi
}

function unload-profile {
    local dir=""
    if [[ -n "$XDG_CONFIG_HOME" && -d "$XDG_CONFIG_HOME/envs" ]]; then
        dir="$XDG_CONFIG_HOME/envs"
    else
        dir="$HOME/.envs"
    fi
    if [[ -n "$LOADED_ENV_PROFILE" ]]; then
        local prevProfilePath="$dir/$LOADED_ENV_PROFILE.env"
        if [[ -f "$prevProfilePath" ]]; then
            while IFS='=' read -r key _ || [ -n "$key" ]; do
                unset "$key"
            done <"$prevProfilePath"
        fi
        unset LOADED_ENV_PROFILE
    fi
}

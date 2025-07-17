#!/bin/zsh
function set-aws-profile {
    export AWS_PROFILE="$1"
}

function clear-aws-profile {
    unset AWS_PROFILE
}

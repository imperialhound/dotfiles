#!/bin/bash
# MAKE SURE TO USE SOURCE asm.sh
#profile=$(cat ~/.aws/credentials | sed -n ')s/^\[\(.*\)\]$/\1/p' | fzf +m)
function profiles() {
    cat ~/.aws/config | sed -n 's/^\[profile \(.*\)\]$/\1/p'
}

# Assume Role
profile=$( profiles | grep -v -E 'default|_login' | fzf +m) 

aws sts get-caller-identity --profile $profile

export AWS_PROFILE=$profile

#!/bin/zsh
add-ssh-host() {
    local alias host_name user identity_file auth_method local_forward

    print "Enter alias for this host: "
    read -r alias
    print "Enter Hostname: "
    read -r host_name
    print "Enter User: "
    read -r user

    ssh_config_file="$HOME/.ssh/config"

    [[ ! -f "$ssh_config_file" ]] && touch "$ssh_config_file"

    print "Choose authentication method ([p]assword/[i]dentity): "
    read -r auth_method

    if [[ "$auth_method" == "i" || "$auth_method" == "identity" ]]; then
        if [[ -z "$identity_file" ]]; then
            pem_files=("$HOME"/.ssh/*.pem)
            for i in {1..${#pem_files[@]}}; do
                echo "$i. ${pem_files[i]}"
            done
            echo "Choose a .pem file by number: "
            read -r choice
            identity_file="${pem_files[choice]}"
        fi

        new_host_entry="Host $alias\n    HostName $host_name\n    User $user\n    IdentityFile $identity_file\n    IdentitiesOnly yes\n"
    else
        new_host_entry="Host $alias\n    HostName $host_name\n    User $user\n"
    fi

    if [[ -n "$local_forward" ]]; then
        new_host_entry+="    LocalForward $local_forward\n"
    fi

    echo -e "$new_host_entry" >> "$ssh_config_file"
}

remove-ssh-host() {
    local alias ssh_config_file line new_lines skip

    echo "Enter alias for the host to remove: "
    read -r alias
    ssh_config_file="$HOME/.ssh/config"

    if [[ -f "$ssh_config_file" ]]; then
        while IFS= read -r line; do
            if [[ "$line" =~ ^Host[[:space:]]+$alias$ ]]; then
                skip=true
            elif [[ $skip == true && "$line" =~ ^Host[[:space:]]+ ]]; then
                skip=false
            fi
            if [[ $skip != true ]]; then
                new_lines+=("$line")
            fi
        done < "$ssh_config_file"
        printf "%s\n" "${new_lines[@]}" > "$ssh_config_file"
    else
        echo "SSH config file not found."
        return 1
    fi
}

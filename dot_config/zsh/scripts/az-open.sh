#!bin/zsh
function az-open {
    local line
    line=$(git remote -v | head -n1)

    if [[ -z "$line" ]] || [[ ! "$line" == *"dev.azure.com"* ]]; then
        echo "Not an AzureDevops git repo..." >&2
        return 1
    fi

    local account=$(echo "$line" | cut -d'/' -f2)
    local project=$(echo "$line" | cut -d'/' -f3)
    local repo=$(echo "$line" | cut -d'/' -f4 | cut -d' ' -f1)

    powershell.exe -c "Start-Process https://dev.azure.com/$account/$project/_git/$repo"
}

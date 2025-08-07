function Open-VSCode {
    param(
        [string]$Path,
        [Parameter(ValueFromRemainingArguments = $true)]
        $Args
    )

    $vsCodePath = "C:\Program Files\Microsoft VS Code\bin\code.cmd"
    if (-not (Test-Path $vsCodePath)) {
        $vsCodePath = "$env:LOCALAPPDATA\Programs\Microsoft VS Code\bin\code.cmd"
    }

    if ($Path) {
        # Resolve path to handle '~' and other special characters
        $resolvedPath = Resolve-Path $Path -ErrorAction SilentlyContinue

        if ($resolvedPath) {
            & $vsCodePath $resolvedPath @Args
        }
        else {
            & $vsCodePath $Path @Args
        }
    }
    else {
        & $vsCodePath @Args
    }
}

Set-Alias -Name code -Value Open-VSCode

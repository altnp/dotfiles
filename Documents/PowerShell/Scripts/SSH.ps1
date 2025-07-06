function Add-SSH-Host {
    param(
        [string]$Alias,
        [string]$HostName,
        [string]$User,
        [string]$IdentityFile,
        [string]$AuthMethod,
        [string]$LocalForward
    )

    if (!$Alias) { $Alias = Read-Host "Enter alias for this host" }
    if (!$HostName) { $HostName = Read-Host "Enter HostName" }
    if (!$User) { $User = Read-Host "Enter User" }

    $sshConfigFile = "${env:USERPROFILE}\.ssh\config"
    $sshDir = "${env:USERPROFILE}\.ssh"

    if (-Not (Test-Path -Path $sshConfigFile)) { New-Item -Path $sshConfigFile -ItemType File }

    if (!$AuthMethod) {
        $AuthMethod = Read-Host "Choose authentication method ([p]assword/[i]dentity)"
    }

    if ($AuthMethod -eq "i" -or $AuthMethod -eq "identity") {
        if (!$IdentityFile) {
            $pemFiles = Get-ChildItem -Path $sshDir -Filter *.pem
            $i = 1
            $pemFiles | ForEach-Object { Write-Host "$i. $($_.Name)"; $i++ }
            $choice = Read-Host "Choose a .pem file by number"
            $IdentityFile = $pemFiles[$choice - 1].FullName
        }

        $newHostEntry = @"
Host $Alias
    HostName $HostName
    User $User
    IdentityFile $IdentityFile
    IdentitiesOnly yes

"@
    } else {
        $newHostEntry = @"
Host $Alias
    HostName $HostName
    User $User

"@
    }

    if ($LocalForward) {
        $newHostEntry += "    LocalForward $LocalForward`n"
    }

    Add-Content -Path $sshConfigFile -Value $newHostEntry
}

function Remove-SSH-Host {
    param(
        [string]$Alias
    )

    if (!$Alias) { $Alias = Read-Host "Enter alias for the host to remove" }

    $sshConfigFile = "${env:USERPROFILE}\.ssh\config"

    if (Test-Path -Path $sshConfigFile) {
        $lines = Get-Content $sshConfigFile
        $newLines = @()
        $skip = $false

        for ($i = 0; $i -lt $lines.Length; $i++) {
            if ($lines[$i] -match "^Host\s+$Alias`$") {
                $skip = $true
            }
            elseif ($skip -and ($lines[$i] -match "^Host\s+")) {
                $skip = $false
            }

            if (-not $skip) {
                $newLines += $lines[$i]
            }
        }

        Set-Content -Path $sshConfigFile -Value $newLines
    } else {
        Write-Host "SSH config file not found."
    }
}

function Add-SshTabCompletion {
    Register-ArgumentCompleter -Native -CommandName ssh -ScriptBlock {
        param($commandName, $wordToComplete, $cursorPosition)
            $sshConfigFile = "$HOME/.ssh/config"
            if (Test-Path $sshConfigFile) {
                Get-Content $sshConfigFile | Where-Object { $_ -match '^Host\s+(.+)' } |
                ForEach-Object { [System.Management.Automation.CompletionResult]::new($Matches[1], $Matches[1], 'ParameterValue', $Matches[1]) }
            }
    }
}

Add-SshTabCompletion

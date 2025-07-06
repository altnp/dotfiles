function Get-AWS-Profiles {
    $profiles = @()

    if (Test-Path "$HOME/.aws/config") {
        $profiles += (Get-Content "$HOME/.aws/config" -ErrorAction Ignore |
                Where-Object { $_ -match '^(?i)\[.+\]$' } |
                ForEach-Object {
                    ($_ -replace '^(?i)\[profile\s*(.+)\]$', '$1') -replace '^(?i)\[(.+)\]$', '$1'
                })
    }

    if (Test-Path "$HOME/.aws/credentials") {
        $profiles += (Get-Content "$HOME/.aws/credentials" -ErrorAction Ignore |
                Where-Object { $_ -match '^(?i)\[.+\]$' } |
                ForEach-Object { ($_ -replace '^(?i)\[(.+)\]$', '$1') })
    }

    $profiles | Sort-Object -Unique
}

Register-ArgumentCompleter -Native -CommandName Set-AWS-Profile -ScriptBlock {
    param($commandName, $wordToComplete, $cursorPosition)

    try {
        # Hardcoding command name for case-insensitive match
        $cleanWord = $wordToComplete -replace "^(?i)set-aws-profile\s*", ""

        Get-AWS-Profiles |
            Where-Object { $_ -like "$cleanWord*" } |
            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "AWS profile: $_") }
    }
    catch {
        Write-Host "Error in completion script: $_" -ForegroundColor Red
    }
}

function Set-AWS-Profile {
    param(
        [Parameter(Position = 0, Mandatory = $true)]
        [string] $profileName
    )
    Import-ModuleIfNotImported AWSCompleter
    $env:AWS_Profile = $profileName
}

function Clear-AWS-Profile {
    $env:AWS_Profile = $null
}

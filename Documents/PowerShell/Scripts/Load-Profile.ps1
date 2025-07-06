function Unload-Profile {
    $dir = "$env:USERPROFILE\.envs"
    if ($env:LOADED_ENV_PROFILE) {
        $prevProfilePath = "$dir\$($env:LOADED_ENV_PROFILE).env"
        if (Test-Path $prevProfilePath) {
            Get-Content $prevProfilePath | ForEach-Object {
                $key = $_.Split('=')[0]
                [Environment]::SetEnvironmentVariable($key, $null)
            }
        }
        [Environment]::SetEnvironmentVariable("LOADED_ENV_PROFILE", $null)
    }
}

Set-Alias -Name uprof -Value Unload-Profile;

function Load-Profile {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [ArgumentCompleter({
                param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

                $dir = "$env:USERPROFILE\.envs"
                Get-ChildItem -Path $dir -Filter "*.env" | ForEach-Object {
                    $_.BaseName
                } | Where-Object {
                    $_ -like "$wordToComplete*"
                }
            })]
        [string] $profileName
    )
    Unload-Profile

    $dir = "$env:USERPROFILE\.envs"
    $profilePath = "$dir\$profileName.env"
    if (Test-Path $profilePath) {
        Get-Content $profilePath | ForEach-Object {
            $parts = $_.Split('=')
            [Environment]::SetEnvironmentVariable($parts[0], $parts[1])
            Write-Host "Loaded $($parts[0])"
        }
        $env:LOADED_ENV_PROFILE = $profileName
        return
    }

    Write-Host "Profile: `"$profileName`" Not Found" -ForegroundColor Red
}

Set-Alias -Name lprof -Value Load-Profile;

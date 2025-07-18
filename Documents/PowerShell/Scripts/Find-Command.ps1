function Find-Command {
    param (
        [Parameter(Mandatory)]
        [string]$Name,
        [switch]$o
    )
    $commands = Get-Command $Name -ErrorAction SilentlyContinue
    if (-not $commands) {
        Write-Error "'$Name' not found"
        return
    }
    foreach ($cmd in $commands) {
        switch ($cmd.CommandType) {
            'Application' { $cmd.Source }
            'ExternalScript' { $cmd.Source }
            'Alias' { "$($cmd.Name) (alias for: $($cmd.ResolvedCommandName))" }
            'Function' { "$($cmd.Name) (function from $($cmd.ScriptBlock.File))" }
            'Cmdlet' { "$($cmd.Name) (cmdlet from: $($cmd.ModuleName))" }
            'Script' { "$($cmd.Source)" }
            default { "$($cmd.Name) ($($cmd.CommandType))" }
        }

        if ($o) {
            $path = $null
            switch ($cmd.CommandType) {
                'Application' { $path = $cmd.Source }
                'ExternalScript' { $path = $cmd.Source }
                'Script' { $path = $cmd.Source }
                'Function' { $path = $cmd.ScriptBlock.File }
            }
            if ($path -and (Test-Path $path)) {
                $dir = Split-Path $path -Parent
                Start-Process explorer.exe $dir
            }
        }

    }
}

Set-Alias whereis Find-Command -Force;

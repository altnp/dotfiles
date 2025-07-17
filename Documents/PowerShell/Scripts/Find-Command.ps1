function Find-Command {
    param (
        [Parameter(Mandatory)]
        [string]$Name
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
    }
}

Set-Alias whereis Find-Command -Force;

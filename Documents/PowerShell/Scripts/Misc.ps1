function Import-ModuleIfNotImported($ModuleName) {
    if (Get-Module -ListAvailable -Name $ModuleName -ErrorAction SilentlyContinue) {
        if (-not (Get-Module -Name $ModuleName -ErrorAction SilentlyContinue)) {
            Import-Module -Name $ModuleName -ErrorAction SilentlyContinue
        }
    }
}

function Print-Env {
    $Local:envVars = Get-ChildItem -Path Env: | Sort-Object Name
    $envVars | ForEach-Object { "{0,-30} : {1}" -f $_.Name, $_.Value }
}

Set-Alias -Name printenv -Value Print-Env;
Set-Alias -Name env -Value Print-Env;

function Admin() {
    Start-Process wt.exe -Verb RunAs -ArgumentList "-d $(Get-Location)"
}

function Print-Colors {
    $colors = [enum]::GetValues([System.ConsoleColor])

    foreach ($background in $colors) {
        $foregroundColor = if ($background -eq 'Black' -or $background -eq 'DarkBlue' -or $background -eq 'DarkCyan' -or $background -eq 'DarkGreen' -or $background -eq 'DarkMagenta' -or $background -eq 'DarkRed') { 'White' } else { 'Black' }

        $name = $background
        $padLeft = [math]::Ceiling((25 - $name.length) / 2)
        $padRight = 25 - $padLeft - $name.length

        $output = (" " * $padLeft) + $name + (" " * $padRight)

        Write-Host $output -NoNewline -BackgroundColor $background -ForegroundColor $foregroundColor
        Write-Host
    }
}

Set-Alias -Name colors -Value Print-Colors;

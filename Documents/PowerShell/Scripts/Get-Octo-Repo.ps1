function Get-Octo-Repo {
    $Local:path = Join-Path (Get-Item ((Get-Package Octopus.Client).source)).Directory.FullName "lib/netstandard2.0/Octopus.Client.dll"
    Add-Type -Path $path

    if (-not $Env:OCTOPUS_CLI_SERVER -or -not $Env:OCTOPUS_CLI_API_KEY) {
        Write-Error "Octopus Env Variables Not Set"
        exit 1
    }

    $Local:server = $Env:OCTOPUS_CLI_SERVER;
    $Local:apiKey = $Env:OCTOPUS_CLI_API_KEY;
    $Local:endpoint = New-Object Octopus.Client.OctopusServerEndpoint($server, $apiKey)
    $Local:repo = New-Object Octopus.Client.OctopusRepository($endpoint)

    return $repo
}

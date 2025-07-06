function Open-Azure {
    $line = ($(git remote -v) -split '\n')

    if (-not $line -or -not ($line[0] -like "*dev.azure.com*")) {
        Write-Host "Not an AzureDevops git repo..." -ForegroundColor Red
        return
    }

    $line = $line[0].Split("/")
    $account = $line[1]
    $project = $line[2]
    $repo = $line[3].Split(" ")[0]
    Start-Process "https://dev.azure.com/$account/$project/_git/$repo"
}

Set-Alias -Name azo -Value Open-Azure;

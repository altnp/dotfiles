function Open-VisualStudio([System.IO.FileInfo]$path) {
    if (!(Test-Path $path)) {
        "Invalid value for path..."
        return;
    }

    $Local:sln = "";
    $Local:items = Get-ChildItem *.sln -Recurse -Path $path;

    if ($items.Count -gt 1 ) {
        "Multiple .sln files found...";
        "";

        $Local:i = 0;
        foreach ($item in $items) {
            "$i. $item"
            $i++;
        }

        $Local:j = Read-Host "Select a sln to open:"
        if ($j -match "^\d+$") {
            $sln = $items[$j].FullName
        }
        else {
            "Invalid input."
            return;
        }

    }
    elseif ($items.Count -eq 1) {
        $sln = $items[0].FullName
    }
    else {
        "No sln found..."
        return;
    }

    "";
    "Opening $sln...";
    Start-Process $sln;
}

Set-Alias -Name vs -Value Open-VisualStudio;

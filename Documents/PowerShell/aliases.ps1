Set-Alias -Name tf -Value terraform;
Set-Alias -Name k8s -Value kubectl;
Set-Alias -Name py -Value python;

function gho { gh browse @args }

if (-not (Test-Path Variable:PSise)) {
    # Only run this in the console and not in the ISE
    Import-Module Get-ChildItemColor
    Remove-Item Alias:ls -ErrorAction SilentlyContinue

    function l {
        Get-ChildItemColor -HumanReadableSize -Force $Args[0]
    }

    function ls {
        Get-ChildItemColorFormatWide -TrailingSlashDirectory -Force @args
    }
}

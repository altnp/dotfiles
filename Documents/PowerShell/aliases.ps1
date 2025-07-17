Set-Alias -Name tf -Value terraform;
Set-Alias -Name k8s -Value kubectl;
Set-Alias -Name py -Value python;

function gho { gh browse @args }

if (-not (Test-Path Variable:PSise)) {
    Remove-Item Alias:ls -ErrorAction SilentlyContinue
    if (Get-Command eza -ErrorAction SilentlyContinue) {
        function l {
            eza -la --group-directories-first --icons $Args
        }
        function ls {
            eza -a --group-directories-first --icons $Args
        }
        function lt {
            eza -a -T --group-directories-first --color=auto --level 3 --icons $Args
        }
    }
    else {
        Import-Module Get-ChildItemColor
        function l {
            Get-ChildItemColor -HumanReadableSize -Force $Args[0]
        }
        function ls {
            Get-ChildItemColorFormatWide -TrailingSlashDirectory -Force @args
        }
    }
}

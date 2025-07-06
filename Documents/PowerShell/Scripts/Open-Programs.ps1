function Open-Brave {
    Start-Process brave.exe @Args
}

Set-Alias -Name brave -Value Open-Brave;

function Open-Chrome {
    Start-Process chrome.exe @Args
}

Set-Alias -Name chrome -Value Open-Chrome;

function Open-FireFox {
    Start-Process firefox.exe @Args
}

Set-Alias -Name fire-fox -Value Open-FireFox;

function Open-WebSearch([string] $term) {
    $encodedTerm = [System.Web.HttpUtility]::UrlEncode($term)
    Start-Process "https://google.com/search?q=$encodedTerm"
}

Set-Alias -Name webserch -Value Open-WebSearch;

Register-ArgumentCompleter -Native -CommandName dotnet-octo -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)
    $params = $commandAst.ToString().Split(' ') | Select-Object -Skip 1
    & "C:\Users\altnp\.dotnet\tools\dotnet-octo.exe" complete $params | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_)
    }
}

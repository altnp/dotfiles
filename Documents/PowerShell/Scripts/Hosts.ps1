function Add-Host([string]$ip, [string]$hostname) {
	$Local:hostsPath = "C:\Windows\System32\drivers\etc\hosts";
	remove-host $hostsPath $hostname
	$ip + "`t`t" + $hostname | Out-File -Encoding ASCII -Append $hostsPath
}

function Remove-Host([string]$hostname) {
	$Local:hostsPath = "C:\Windows\System32\drivers\etc\hosts";
	$Local:c = Get-Content $hostsPath
	$Local:newLines = @()

	foreach ($Local:line in $c) {
		$Local:bits = [regex]::Split($line, "\s+")
		if ($bits.count -eq 2) {
			if ($bits[1] -ne $hostname) {
				$newLines += $line
			}
		}
		else {
			$newLines += $line
		}
	}

	Clear-Content $hostsPath
	foreach ($Local:line in $newLines) {
		$line | Out-File -Encoding ASCII -Append $hostsPath
	}
}

function List-Hosts() {
	$Local:hostsPath = "C:\Windows\System32\drivers\etc\hosts";
	$Local:c = Get-Content $hostsPath

	foreach ($Local:line in $c) {
		$Local:bits = [regex]::Split($line, "\s+")
		if (($bits.count -eq 2) -and ($bits[0] -notmatch "^#")) {
			Write-Host $bits[0] `t`t $bits[1]
		}
	}
}

---
layout: post
title:  "Windows docker images creation goodies"
tags: [windows, docker, powershell]
categories: work
---

# Docker for Windows Server Cheatsheet

## Below are some commands that migth be usefull for docker image creator:

Don't forget that windows multiline commands can be separated by `\` symbol in dockerfile and `^` in powershell/cmd file.

| Decription                                 | Command Syntax                                                    |
| ------------------------------------------ | ----------------------------------------------------------------- |
| Download file                              | Invoke-WebRequest <URL> -OutFile <path>                           |
| Unzip file                                 | Expand-Archive <ZIP> -DestinationPath <path>                      |
| Run command                                | Start-Process <process name> -ArgumentList 'arg1', 'arg2';        |
| Sleep                                      | Start-Sleep -s 5                                                  |
| Print to console                           | Write-Host "It's like echo on Linux"                              |
| Get environment variable `SOMETHING`       | (Get-Item Env:SOMETHING).Value                                    |
| Fail & exit with errorcode                 | exit($ERRORCODE)                                                  |
| Check if env. variable is not empty        | if (-Not (Get-Item Env:SOMETHING)) {  }                           |
| Add registry key                           | New-Item -Path <Path> -Name MSMQ –Force                           |
| Update registry entry                      | Set-ItemProperty -Path <Path> -Name <Key> -Value <Value> -Force   |
| Remove registry entry                      | Remove-Item -Path <Path>                                          |
| Install service / feature (windows server) | Install-WindowsFeature -ConfigurationFilePath c:\temp\appInit.xml |
| Stop / Start service                       | Stop-Service / Start-Service -Name WMSVC                          |
| Start process                              | & "C:/Windows/System32/iisreset" /restart                         |

# Here are some usefull code snippets:

## Clean code
Remember that you can create functions in powershell and keep code clean:
```powershell
#functions definitions
function initDbWithBasicValues {
  ...
}

function copyFilledDb {
  ...
}

#functions call place
initDbWithBasicValues
copyFilledDb
```

## Wait for server restart
```powershell
function waitForServerStart {
$sw = [Diagnostics.Stopwatch]::StartNew()
	while ($True){
		Write-Host "waiting for server to start"
		try {
			$status = (Invoke-WebRequest -Uri http://localhost:80 -UseBasicParsing -TimeoutSec 30).StatusCode.equals(200)
			if ($status) {break};

			Start-Sleep -s 5

		} catch {}
	}
$sw.Stop()

	Write-Host "Server is started !"
	Write-Host "Time-taken:" $sw.Elapsed
}
```

## Grant permission to some folder
```powershell
$Account = New-Object System.Security.Principal.NTAccount("IIS APPPOOL\.NET v4.5");
	$ItemList = Get-ChildItem -Path <SomePath> -Recurse;
	$ACL = Get-ACL <SomePath>;
	foreach ($Item in $ItemList) {
		$ACL.SetOwner($Account);
		Set-Acl -Path $Item.FullName -AclObject $Acl;
	};
```

## Replace File contents
```powershell
$content = Get-Content -Encoding UTF8 -path somePath
$content = $content -Replace '#original', "#newvalue"
$content | Out-File -Encoding UTF8 newPath
```

## Download Huge file (it will take forever otherwise)
```powershell
# Unless we silence here Download progress it would pause every second for no reason
$ProgressPreference = "SilentlyContinue"
Invoke-WebRequest $url -OutFile <outfile>
# Return back output
$progressPreference = 'Continue'
```

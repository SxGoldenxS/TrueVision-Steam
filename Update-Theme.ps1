[CmdletBinding()]
param([string]$SteamPath, [switch]$Force)
$ErrorActionPreference='Stop'
$temporary=$null
try {
 if(-not $SteamPath){
  $SteamPath=(Get-ItemProperty 'HKCU:\Software\Valve\Steam' -ErrorAction SilentlyContinue).SteamPath
  if(-not $SteamPath){$SteamPath='C:\Program Files (x86)\Steam'}
 }
 $steamRoot=[IO.Path]::GetFullPath($SteamPath)
 $installed=Join-Path $steamRoot 'millennium\themes\Raphael-Ciel'
 if(-not(Test-Path -LiteralPath (Join-Path $installed 'skin.json'))){throw 'Install TrueVision using INSTALL.cmd first.'}
 $identity='SxGoldenxS/TrueVision-Steam'
 $headers=@{'User-Agent'='TrueVision-Updater';Accept='application/vnd.github+json'}
 [Net.ServicePointManager]::SecurityProtocol=[Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
 Write-Output 'Checking Golden''s TrueVision repository...'
 $latest=Invoke-RestMethod -Uri "https://api.github.com/repos/$identity/commits/main" -Headers $headers -TimeoutSec 30
 $commit=[string]$latest.sha
 if($commit -notmatch '^[a-f0-9]{40}$'){throw 'GitHub did not return a valid commit.'}
 $localMetadata=Join-Path $installed 'metadata.json'
 if((Test-Path -LiteralPath $localMetadata) -and -not $Force){
  $current=Get-Content -LiteralPath $localMetadata -Raw|ConvertFrom-Json
  if($current.owner -eq 'SxGoldenxS' -and $current.repo -eq 'TrueVision-Steam' -and $current.commit -eq $commit){
   Write-Output 'TrueVision is already up to date.'
   return
  }
 }
 $temporary=Join-Path ([IO.Path]::GetTempPath()) ('TrueVision-update-'+[guid]::NewGuid().ToString('N'))
 New-Item -ItemType Directory -Path $temporary|Out-Null
 $archive=Join-Path $temporary 'theme.zip'
 # Pin the download to the checked commit, rather than a branch that can change
 # between checking and downloading. No account credentials are needed.
 Write-Output 'Downloading the latest theme from GitHub...'
 Invoke-WebRequest -UseBasicParsing -Uri "https://codeload.github.com/$identity/zip/$commit" -Headers $headers -OutFile $archive -TimeoutSec 60
 Add-Type -AssemblyName System.IO.Compression.FileSystem
 $zip=[IO.Compression.ZipFile]::OpenRead($archive)
 try {
  if($zip.Entries.Count -gt 2000){throw 'Theme archive contains too many files.'}
  $total=[long]0
  foreach($entry in $zip.Entries){
   $name=$entry.FullName.Replace('\','/')
   if($name -match '(^/|^[A-Za-z]:|(^|/)\.\.(/|$)|:)' -or (($entry.ExternalAttributes -shr 16) -band 0xF000) -eq 0xA000){throw 'Unsafe archive path or link.'}
   $total+=$entry.Length
   if($total -gt 64MB){throw 'Theme archive exceeds the size limit.'}
  }
 } finally {$zip.Dispose()}
 $expanded=Join-Path $temporary 'expanded'
 Expand-Archive -LiteralPath $archive -DestinationPath $expanded
 $roots=@(Get-ChildItem -LiteralPath $expanded -Directory)
 if($roots.Count -ne 1){throw 'Unexpected GitHub archive layout.'}
 $source=$roots[0].FullName
 $skin=Get-Content -LiteralPath (Join-Path $source 'skin.json') -Raw|ConvertFrom-Json
 if($skin.name -ne 'TrueVision' -or $skin.author -ne 'Golden' -or $skin.github.owner -ne 'SxGoldenxS' -or $skin.github.repo_name -ne 'TrueVision-Steam'){throw 'Unexpected downloaded theme identity.'}
 @{owner='SxGoldenxS';repo='TrueVision-Steam';commit=$commit}|ConvertTo-Json|Set-Content -LiteralPath (Join-Path $source 'metadata.json') -Encoding utf8
 $installer=Join-Path $PSScriptRoot 'Install-Theme.ps1'
 if(-not(Test-Path -LiteralPath $installer)){throw 'Keep Install-Theme.ps1 beside the updater.'}
 & $installer -SteamPath $steamRoot -ThemeSource $source
 if(-not $?){throw 'Theme installation failed.'}
 $verified=Get-Content -LiteralPath (Join-Path $installed 'metadata.json') -Raw|ConvertFrom-Json
 if($verified.commit -ne $commit){throw 'Installed commit verification failed.'}
 Write-Output "Updated TrueVision to $($skin.version). Fully exit and reopen Steam to apply it."
} catch { Write-Error $_; exit 1 }
finally {
 if($temporary -and (Test-Path -LiteralPath $temporary)){
  $resolved=[IO.Path]::GetFullPath($temporary)
  if((Split-Path -Parent $resolved) -eq [IO.Path]::GetFullPath([IO.Path]::GetTempPath()).TrimEnd('\') -and (Split-Path -Leaf $resolved) -match '^TrueVision-update-[a-f0-9]{32}$'){
   Remove-Item -LiteralPath $resolved -Recurse -Force
  }
 }
}

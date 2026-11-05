[CmdletBinding(SupportsShouldProcess)]
param([string]$SteamPath, [string]$ThemeSource)
$ErrorActionPreference='Stop'
try {
 if(-not $SteamPath){
  $SteamPath=(Get-ItemProperty 'HKCU:\Software\Valve\Steam' -ErrorAction SilentlyContinue).SteamPath
  if(-not $SteamPath){$SteamPath='C:\Program Files (x86)\Steam'}
 }
 $steamRoot=[IO.Path]::GetFullPath($SteamPath)
 $themes=[IO.Path]::GetFullPath((Join-Path $steamRoot 'millennium\themes'))
 if(-not $ThemeSource){$ThemeSource=Join-Path $PSScriptRoot 'Raphael-Ciel'}
 $source=[IO.Path]::GetFullPath($ThemeSource)
 $target=[IO.Path]::GetFullPath((Join-Path $themes 'Raphael-Ciel'))
 if((Split-Path -Parent $target) -ne $themes){throw 'Unexpected theme destination.'}
 if(-not(Test-Path -LiteralPath $themes -PathType Container)){throw 'Install Millennium first: https://steambrew.app/ . Then rerun INSTALL.cmd.'}
 $skin=Get-Content -LiteralPath (Join-Path $source 'skin.json') -Raw|ConvertFrom-Json
 $metadata=Get-Content -LiteralPath (Join-Path $source 'metadata.json') -Raw|ConvertFrom-Json
 if($skin.name -ne 'TrueVision' -or $skin.author -ne 'Golden' -or $skin.github.owner -ne 'SxGoldenxS' -or $skin.github.repo_name -ne 'TrueVision-Steam' -or $metadata.owner -ne $skin.github.owner -or $metadata.repo -ne $skin.github.repo_name -or $metadata.commit -notmatch '^[a-f0-9]{40}$'){throw 'Unexpected theme package or update metadata.'}
 if($source -eq $target){Write-Output 'TrueVision is already in its theme folder.';return}
 if(-not $PSCmdlet.ShouldProcess($target,'Install TrueVision; back up the previous copy')){return}
 $lock=$null;$stage=$null;$backup=$null
 try {
  $lock=[IO.File]::Open((Join-Path $themes '.TrueVision-install.lock'),[IO.FileMode]::OpenOrCreate,[IO.FileAccess]::ReadWrite,[IO.FileShare]::None)
  if((Test-Path -LiteralPath $target) -and ((Get-Item -LiteralPath $target).Attributes -band [IO.FileAttributes]::ReparsePoint)){throw 'Theme destination cannot be a link.'}
  $stage=[IO.Path]::GetFullPath((Join-Path $themes ('.TrueVision-stage-'+[guid]::NewGuid().ToString('N'))))
  New-Item -ItemType Directory -Path $stage|Out-Null
  Get-ChildItem -LiteralPath $source -Force|Copy-Item -Destination $stage -Recurse -Force
  if(Test-Path -LiteralPath $target){
   $backupRoot=Join-Path $steamRoot 'millennium\backups\TrueVision'
   New-Item -ItemType Directory -Path $backupRoot -Force|Out-Null
   $backup=Join-Path $backupRoot ('before-'+(Get-Date -Format 'yyyyMMdd-HHmmss-fff'))
   [IO.Directory]::Move($target,$backup)
  }
  # Stage on the same volume; switch folders only once the copy is complete.
  try{[IO.Directory]::Move($stage,$target)}catch{
   if($backup -and -not(Test-Path -LiteralPath $target)){[IO.Directory]::Move($backup,$target)}
   throw
  }
  $stage=$null
  if($backup){Write-Output "Previous copy backed up: $backup"}
  Write-Output "Installed TrueVision $($skin.version), by Golden."
  Write-Output 'Active theme and saved settings were preserved. Discord support: daddysxgold'
  Write-Output 'Select TrueVision in Millennium if needed, then fully exit and reopen Steam.'
  Write-Output 'Future updates: double-click UPDATE.cmd. No background service is installed.'
 } finally {
  if($stage -and (Test-Path -LiteralPath $stage)){
   if((Split-Path -Parent $stage) -eq $themes -and (Split-Path -Leaf $stage) -match '^\.TrueVision-stage-[a-f0-9]{32}$'){Remove-Item -LiteralPath $stage -Recurse -Force}
  }
  if($lock){$lock.Dispose()}
 }
} catch {Write-Error $_;exit 1}

# before running the installer:
# see install.md
if ( -Not (Get-Command scoop -errorAction SilentlyContinue)) { Invoke-WebRequest -useb get.scoop.sh | Invoke-Expression } # install scoop if not installed
if ( -Not (Get-Command git -errorAction SilentlyContinue)) { winget install --id Git.Git -e --source winget } # install git if not installed

scoop bucket add extras
foreach ($command in ( "fzf", "winfetch", "ntop", "gsudo", "duf", "bat")) { if ( -Not (Get-Command $command -errorAction SilentlyContinue)) { scoop install $command } }

Start-Process -Verb RunAs powershell -Args '-NoExit', '-c', 'foreach ($mod in (\"posh-git\", \"PSFzf\", \"PSReadline\")) { Install-Module $mod -Confirm:$False -Force }'
if ( -Not (Get-Command oh-my-posh -errorAction SilentlyContinue)) { scoop install https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/oh-my-posh.json } # install oh-my-posh if not installed

$pwfolder = "$HOME\.pw"
if (-Not (Test-Path $pwfolder)) { git clone "https://github.com/matan-h/.pw.git" $pwfolder }
Copy-Item $pwfolder\documentsProfile.ps1 $PROFILE 


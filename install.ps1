# before running the installer:
# install mesloLGM NF manully - download https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Meslo.zip
# setup font:
# windows new terminal - open settings;click on "windows powershell";scroll and click "Appearance";chenge font to "mesloLGM NF"
# windows new terminal - for making powershell more faster, chenge cmdline to powershell -nologo
# vscode - add this to vscode settings: (the impotent is the fontFamily, the nologo is only to make powershell faster )
<#
"terminal.integrated.fontFamily":"MesloLGM NF",
"terminal.integrated.profiles.windows": {
      "PowerShell": {
        "source": "PowerShell",
        "icon": "terminal-powershell",
        "args": ["-nologo"]
      },
#>
if ( -Not (Get-Command scoop -errorAction SilentlyContinue)) { Invoke-WebRequest -useb get.scoop.sh | Invoke-Expression } # install scoop if not installed
if ( -Not (Get-Command git -errorAction SilentlyContinue)) { winget install --id Git.Git -e --source winget } # install git if not installed

scoop bucket add extras
foreach ($command in ( "fzf", "lsd", "winfetch", "ntop", "gsudo", "duf","bat")) { if ( -Not (Get-Command $command -errorAction SilentlyContinue)) { scoop install $command } }

Start-Process -Verb RunAs powershell -Args '-NoExit','-c', 'foreach ($mod in (\"posh-git\", \"PSFzf\", \"PSReadline\",\"PSWindowsUpdate\")) { Install-Module $mod -Confirm:$False -Force }'
if ( -Not (Get-Command oh-my-posh -errorAction SilentlyContinue)) { scoop install https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/oh-my-posh.json } # install oh-my-posh if not installed

$pwfolder="$HOME\.pw"
if (-Not (Test-Path $pwfolder)){git clone "https://github.com/matan-h/.pw.git" $pwfolder}
Copy-Item $pwfolder\documentsProfile.ps1 $PROFILE 


# history
function global:hist () {
    Get-Content (Get-PSReadlineOption).HistorySavePath
}
function global:hsi () {
    hist | Select-String $args
}
# python:
$pythoncommmand = ''
if (Get-Command python -errorAction SilentlyContinue) {
    $pythoncommmand = "python"
}
elseif (Get-Command py -errorAction SilentlyContinue) {
    $pythoncommmand = "py"
}
if ($pythoncommmand) {
    function global:venv { . venv/Scripts/Activate.ps1 } # activate python virtualenv
    function global:cvenv { & $pythoncommmand -m venv venv }    # create python virtualenv
    function global:uvenv { cvenv ; venv ; & $pythoncommmand -m pip install -U pip setuptools wheel $args } # create venv;activate it;update packages

    # decode/encode url from stdin or from command line arguments:
    function global:urlencode { & $pythoncommmand -c "import sys; import urllib.parse as up; print(up.quote_plus('\'' '\''.join(sys.argv[1:]) or sys.stdin.read()[0:-1]))" $args }
    function global:urldecode { & $pythoncommmand -c "import sys; import urllib.parse as up; print(up.unquote_plus('\'' '\''.join(sys.argv[1:]) or sys.stdin.read()[0:-1]))" $args }
}
if (Get-Command http.exe -errorAction SilentlyContinue) {
    # net:
    function global:durl { http.exe -d $args } # download file using httpie (usually better and slower then wget/curl/Invoke-WebRequest)
}
# files tools:
if (Get-Command pygmentize -errorAction SilentlyContinue) {
    function global:ccat { pygmentize -g @args }  # color cat using pygmentize
}
function global:FormatJson { $Args | ConvertFrom-Json | ConvertTo-Json } # gh:tehmantra
# windows useful system tools
function global:Edit-Env { rundll32 sysdm.cpl, EditEnvironmentVariables } # open EditEnvironmentVariables window (for edit $PATH)# gh:tehmantra
function global:ReloadPATH { $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User") }  # reload the $PATH# so:17794507
function global:AddToPath($path) {
    # add dir to $PATH
    # gh:hashhar
    if ($path.Length -eq 0) {
        return
    }
    foreach ($item in $env:Path.Split(';')) {
        if ($item.TrimEnd('\').Equals($path.TrimEnd('\'))) {
            Write-Output "Already in PATH."
            break
        }
    }
    $env:Path = $env:Path.Insert(0, $path + ";")
}
function global:find_proc { Get-Process -ErrorAction ignore $args }
# powershell useful tools
if (-Not (Get-Command pwsh -errorAction SilentlyContinue)) {
    function global:pwsh() {
        # start powershell script without this profile
        powershell -noprofile -nologo $args
    }
}

if (Get-Command bat -errorAction SilentlyContinue) {
    function global:what($name) {
        # view the source file of command # gh:younger-1
        bat (Get-Command $name).Definition
    }
}

function global:pwconfig { code $PSScriptRoot/pwaliases.ps1 $PSScriptRoot/pwfunctions.ps1 $PSScriptRoot/profile.ps1 $PROFILE } # open vscode on pwaliases,pwfunctions and $PROFILE
# function global:pwrc { &([Environment]::GetCommandLineArgs()[0]) }  # rerun powershell # TODO : find better way to reload powershell profile
function global:pwrc { . $PROFILE }  # refresh $PROFILE
function global:ListViewMode { Set-PSReadLineOption -PredictionViewStyle ListView } # set powershell auto-suggestion to listview
function global:FishMode { Set-PSReadLineOption -PredictionViewStyle InlineView }   # set powershell auto-suggestion to normal (fish-like)

# scoop
if (Get-Command scoop -errorAction SilentlyContinue) {
    # scoop - package manager 2
    function global:scup() {
        scoop update "*"
    }
    function global:scinstall() {
        scoop install @args
    }
    function global:sclist() {
        scoop list @args
    }
    function global:scrm() {
        scoop uninstall @args
    }
}
# winget - package manager 1
if (Get-Command winget -errorAction SilentlyContinue) {
    function global:wininstall { winget install $args }
    function global:wininfo { winget info $args }        # get info on package remotely
    function global:winsearch { winget search $args }    # search package remotely
    function global:winrm { winget uninstall $args }     # Remove Package
    function global:winup { winget upgrade -a }          #  upgrade all winget packages
    function global:wingets { winget $args -s winget }    #  use winget source insted of msstore
}
# all system
if ((Get-Command winget -errorAction SilentlyContinue ) -and (Get-Command scoop -errorAction SilentlyContinue)) {
    function global:sysup { scup ; winup }        #  update winget
    function global:Update() {
        UpdatePW # update .pw
        gsudo Update-Module # update all modules as adminstor
        scup # update all scoop apps
    }
}
# .pw 
function global:UpdatePW() {
    $pwdtmp = Get-Location
    Set-Location $HOME\.pw
    git pull # update .pw
    Copy-Item .\documentsProfile.ps1 $PROFILE # update $PROFILE 
    Set-Location $pwdtmp
}

# simple shortcuts
function global:.. { Set-Location .. } 
function global:src { Set-Location src } # most of the time, "src" is a folder


function global:e. { explorer . } # start file manager

# fix common mistakes and typeos
function global:cd.. { Set-Location .. }
function global:code. { code . }

# git
function global:gitam { git commit -am @args } #  Auto stage all modified files and commit
function global:gitp { git pull @args } # pull chenges from the server
function global:gitst { git status @args } # pull chenges from the server

# yarn
if (Get-Command yarn -errorAction SilentlyContinue) {

    function global:yst { yarn start @args } #   yarn start command
    function global:ya { yarn add @args } # yarn add package
    function global:yad { yarn add -D @args } # yarn add dev package
}
# linux/bash like

function global:grep { Select-String -AllMatches $args } # bash grep.exe usually dont work nice with powershell
function global:mkdirs { New-Item -ItemType Directory -Path @args } # Create directories recursively with verbose  # TODO
function global:rmtree { Remove-Item -Recurse -Force $args }     # remove folder recursively
function global:sudoterm { gsudo -d wt } # start windows terminal with administrator 
function global:which($name) { Get-Command -All $name -ErrorAction SilentlyContinue } # from git:jayharris
function global:take($dir) { mkdir $dir; Set-Location $dir } # mkdir && cd
function global:poweroff { shutdown /hybrid /s /t $($args[0] * 60) } 
function global:bg { Start-Process powershell -NoNewWindow "-Command $args" } # send command to another powershell # gh:camba3d
function global:edit { & "code" -g @args } # open file in vscode # gh:mikemaccana
# cmd like:
function global:rename { Rename-Item -Verbose @args }          
function global:mklink { if (Get-Command ln -ErrorAction SilentlyContinue) { ln -s $Args } else { cmd.exe /c mklink $Args } }

# web apps
# translate
function global:trans {
    Invoke-WebRequest "https://lingva.ml/api/v1/iw/en/$args" | ConvertFrom-Json | Select-Object "translation"
}
function global:detrans {
    Invoke-WebRequest "https://lingva.ml/api/v1/en/iw/$args" | ConvertFrom-Json | Select-Object "translation"
}
function global:google() {
    # search $args in google # so:32703483
    $query = 'https://www.google.com/search?q='
    $args | ForEach-Object { $query = $query + "$_+" }
    $url = $query.Substring(0, $query.Length - 1)
    Start-Process "$url"
}
<#
list of applications:
* winget - package maneger 1
* scoop - package maneger 2
* mingw - install with git bash
* httpie - with pip,pipx or package manager
* pygmentize - with pip,pipx or package manager
* yarn - just some shortcuts
* git - shortcuts
* helix - editor
#>
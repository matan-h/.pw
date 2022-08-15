# history
function hist () {
    Get-Content (Get-PSReadlineOption).HistorySavePath
}
function hsi () {
    hist | Select-String $args
}
# python:
function venv { . venv/bin/Activate.ps1 } # activate python virtualenv
function cvenv { python -m venv venv }     # create python virtualenv
function uvenv { cvenv ; venv ; python -m pip install -U pip setuptools wheel $args } #TODO : "&&" # create python virtualenv,activate it, and upgrade it
# net:
function durl { http -d $args } # download file using httpie (usually better and slower then wget)
# decode/encode url from stdin or from command line arguments:
function urlencode { python -c "import sys; import urllib.parse as up; print(up.quote_plus('\'' '\''.join(sys.argv[1:]) or sys.stdin.read()[0:-1]))" $args }
function urldecode { python -c "import sys; import urllib.parse as up; print(up.unquote_plus('\'' '\''.join(sys.argv[1:]) or sys.stdin.read()[0:-1]))" $args }
function FormatJson { $Args | ConvertFrom-Json | ConvertTo-Json } # gh:tehmantra
function ccat { pygmentize -g }                                                           # color cat using pygmentize
# windows useful tools
function Edit-Env { rundll32 sysdm.cpl,EditEnvironmentVariables } # gh:tehmantra
function ReloadPATH{$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User") } # so:17794507
function AddToPath($path) { # gh:hashhar
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

# powershell useful tools
function pwsh(){
    powershell -noprofile $args
}

function what($name) { # gh:younger-1
    bat (Get-Command $name).Definition
}
function google(){ # so:32703483
        $query = 'https://www.google.com/search?q='
        $args | ForEach-Object { $query = $query + "$_+" }
        $url = $query.Substring(0, $query.Length - 1)
        Start-Process "$url"
}
function pwconfig { code $HOME/.pwaliases.ps1 $HOME/.pwfunctions.ps1 $PROFILE } # open vscode on .aliases file and .zshrc
function pwAliases { hx $HOME/.pwaliases.ps1  $HOME/.pwfunctions.ps1  $PROFILE } # open helix on .aliases file and .zshrc
function pwrc { . $PROFILE } 
function ListViewMode{Set-PSReadLineOption -PredictionViewStyle ListView}
function FishMode{Set-PSReadLineOption -PredictionViewStyle InlineView}
# scoop
function ScoopCommand {
    param(
        # [Parameter(position=0)]
        $command=$null,
        [Parameter(ValueFromRemainingArguments)]
        $apps=$null
    )

    $configJson = "${env:USERPROFILE}\.config\scoop\config.json"
    $scoopConfig = Get-Content $configJson -Raw | ConvertFrom-Json
    $scoopConfig.lastupdate = [System.DateTime]::Now.ToString('o')
    $scoopConfig | ConvertTo-Json -Depth 2 | Set-Content $configJson
        scoop.ps1 $command $apps
}
# winget
function wininstall { winget install $args } # upgrade system && install package if not installed yet (this is the normal way of installing package on arch)
function wininfo { winget info $args }        # get info on package remotely
function winrm { winget uninstall $args }  # Remove Package with all its dependencies

# winget - package manager
function sysup { winget upgrade -a $args }        # update sccop && update winget

function find_proc { Get-Process -ErrorAction ignore $args }
# simple shortcuts
function s { Start-Process "https://www.google.com/search?q=$($args -join '+')" }

function .. { Set-Location .. } 
function fzc { fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}' }  # file selector using fzf and bat preview

# fix common mistakes and typeos
function e. { explorer . } # start file manager
function cd.. { Set-Location .. }
function code. { code . }

# git
function gitam { git commit -am } #  Auto stage all modified files and commit
function gitp { git pull } # pull chenges from the server

# yarn
function yst { yarn start } #   Auto stage all modified files and commit
function ya { yarn add } # pull chenges from the server
function yad { yarn add -D } # yarn add dev

# linux like
function grep { grep.exe --color=always $args }
function mkdirs {New-Item -ItemType Directory -Path @args } # Create directories recursively with verbose  # TODO
function rmtree { Remove-Item -r $args }     # remove folder recursively
function rmtreef { Remove-Item -rfo $args }    # remove folder recursively with force
function sudoterm { gsudo -d wt } # so:55314557
function which($name) { Get-Command -All $name -ErrorAction SilentlyContinue } # from git:jayharris
function take($dir){ mkdir $dir;Set-Location $dir}# macos like (not much - just to use navi)
function poweroff { shutdown /hybrid /s /t $($args[0] * 60) }
function bg { Start-Process powershell -NoNewWindow "-Command $args" } # gh:camba3d
function edit {& "code" -g @args} # gh:mikemaccana

# cmd like:
function rename { Rename-Item -Verbose $args }          # rename file is actually moving it to another name
function mklink { cmd.exe /c mklink $Args }

# curl apps
# translate
function trans {
    Invoke-WebRequest "https://lingva.ml/api/v1/iw/en/$args" | ConvertFrom-Json | Select-Object "translation"
}
function detrans {
    Invoke-WebRequest "https://lingva.ml/api/v1/en/iw/$args" | ConvertFrom-Json | Select-Object "translation"
}
function Update(){
    gsudo Update-Module # update all modules as adminstor
    scoop update "*" # update all scoop apps
    $pwdtmp=Get-Location
    Set-Location $HOME\.pw
    git pull
    Set-Location $pwdtmp
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
* vim/neovim - editor
#>
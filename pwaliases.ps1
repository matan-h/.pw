Set-Alias create New-Item

Set-Alias l ls -Option AllScope -Description "one letter shortcut to lsd (l->ls->lsd)"
Set-Alias sl ls -Option AllScope -Force
Set-Alias helix hx -Description "helix (noevim inspired editor) is 'helix' in linux and 'hx.exe' in windows"
Set-Alias g git -Description "one letter shortcut to git"
Set-Alias c z -Description "zoxide (smarter cd command)"
Set-Alias aliases Get-Alias -Description "get list of aliases"
Set-Alias lsalias Get-Alias
Set-Alias unalias Remove-Alias
# macos like
Set-Alias pbcopy Set-Clipboard 
Set-Alias pbpaste Get-Clipboard

# linux like:
if (Get-Command lsd.exe -errorAction SilentlyContinue) {
    Set-Alias ls lsd.exe -Option AllScope
}
Set-Alias clippaste Get-Clipboard
Set-Alias clipcopy Set-Clipboard
Set-Alias time Measure-Command -Description "Measures the time it takes to run script block"
Set-Alias whereis which
Set-Alias touch New-Item # gh:tehmantra
if (Get-Command ntop.exe -errorAction SilentlyContinue) { 
    Set-Alias htop ntop.exe # gh:AndreasBrostrom
    Set-Alias top ntop.exe  # gh:AndreasBrostrom
}
if (Get-Command duf.exe -errorAction SilentlyContinue) {
    Set-Alias df duf.exe
}
if ((Get-Command winfetch.ps1 -errorAction SilentlyContinue) -and (-not (Get-Command neofetch.cmd -errorAction SilentlyContinue))) {
    Set-Alias neofetch winfetch.ps1
}


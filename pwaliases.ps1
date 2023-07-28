function add_alias # function to add global alias
 {
     Param(
         [String] $Name,
         [String] $Value,
         [Parameter(Mandatory=$false)][string] $Description
     )
     Set-Alias -Option AllScope -Scope Global -Force @args -Name $Name -Value $Value -Description $Description
 }

add_alias create New-Item

add_alias l ls -Description "one letter shortcut to lsd (l->ls->lsd)"
add_alias sl ls
add_alias helix hx -Description "helix (noevim inspired editor) is 'helix' in linux and 'hx.exe' in windows"
add_alias g git -Description "one letter shortcut to git"
add_alias c z -Description "zoxide (smarter cd command)"
add_alias aliases Get-Alias -Description "get list of aliases"
add_alias lsalias Get-Alias
add_alias unalias Remove-Alias
# macos like
add_alias pbcopy Set-Clipboard 
add_alias pbpaste Get-Clipboard

# linux like:
if (Get-Command lsd.exe -errorAction SilentlyContinue) {
    add_alias ls lsd.exe
}
add_alias clippaste Get-Clipboard
add_alias clipcopy Set-Clipboard
add_alias time Measure-Command -Description "Measures the time it takes to run script block"
add_alias whereis which
add_alias touch New-Item # gh:tehmantra
if (Get-Command ntop.exe -errorAction SilentlyContinue) { 
    add_alias htop ntop.exe # gh:AndreasBrostrom
    add_alias top ntop.exe  # gh:AndreasBrostrom
}
if (Get-Command duf.exe -errorAction SilentlyContinue) {
    add_alias df duf.exe
}
if ((Get-Command winfetch.ps1 -errorAction SilentlyContinue) -and (-not (Get-Command neofetch.cmd -errorAction SilentlyContinue))) {
    add_alias neofetch winfetch.ps1
}


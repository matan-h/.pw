Set-Alias create New-Item

Set-Alias ls lsd -Option AllScope # TODO: only if lsd exsist
Set-Alias l ls -Option AllScope -Description "one letter shortcut to lsd (l->ls->lsd)"
Set-Alias sl ls -Option AllScope -Force
Set-Alias helix hx -Description "helix (noevim inspired editor) is 'helix' in linux and 'hx.exe' in windows"
Set-Alias g git -Description "one letter shortcut to git"
Set-Alias c z -Description "zoxide (smarter cd command)"
Set-Alias aliases Get-Alias -Description "get list of aliases"
Set-Alias lsalias Get-Alias

# macos like
Set-Alias pbcopy Set-Clipboard 
Set-Alias pbpaste Get-Clipboard

# linux like:
Set-Alias clippaste Get-Clipboard
Set-Alias clipcopy Set-Clipboard
Set-Alias time Measure-Command -Description "Measures the time it takes to run script block"
Set-Alias whereis which
Set-Alias touch New-Item # gh:tehmantra
Set-Alias htop ntop # gh:AndreasBrostrom
Set-Alias top ntop  # gh:AndreasBrostrom
Set-Alias df duf 
Set-Alias neofetch winfetch

Set-Alias scoop ScoopCommand -Description "install packages without update scoop"  # scoop


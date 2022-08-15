$envArgs = [Environment]::GetCommandLineArgs()
$promptMode = (-Not (($envArgs -contains "-Command") -or ($envArgs -contains "-c"))) # only import methods and add aliases...

# global settings:
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding # set pw to utf-8:
Set-Variable -Name ConfirmPreference -Value High # prevent windows from popping up confirmation boxes 
$env:EDITOR = 'code --wait' # --wait required, see https://github.com/Microsoft/vscode/issues/23219 # gh:mikemaccana 


if ($promptMode) {
    if (-Not ([Environment]::GetCommandLineArgs() -contains "-nologo")) {
        Clear-Host
    }
    $curUser = (Get-ChildItem Env:\USERNAME).Value
    $curComp = (Get-ChildItem Env:\COMPUTERNAME).Value
    $identity = "$curUser@$curComp"
    $paddingString = " " * 2

    # psreadline
    Set-PSReadLineOption -EditMode Emacs # set line edit mode to emacs (like bash default)
    Set-PSReadLineOption -PredictionSource History # add autosuggestions
    Set-PSReadLineOption -BellStyle None # no bell
    Set-PSReadlineOption -HistorySearchCursorMovesToEnd # move cursor to end of line in autosuggestions
    Set-PSReadLineOption -HistoryNoDuplicates:$True # Avoid duplicates
    # 
    Set-PSReadLineKeyHandler -Chord 'Ctrl+v' -Function Paste # add ctrl+v -> paste
    Set-PSReadLineKeyHandler -Chord 'Ctrl+Backspace' -Function BackwardDeleteWord # ctrl+backspace -> delete last word
    Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete # tab for complete (like zsh)
    # add search history up/down
    Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
    Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward
    # For git rebasing

    function Get-char($Number) { [System.Char]::ConvertFromUtf32($Number) }
    Write-Host $paddingString, "$(Get-char 128187) Windows PowerShell $($Host.Version.Major).$($Host.Version.Minor)" -ForegroundColor "White"
    # external shell modules
    Import-Module posh-git # add autocomplete for git

    # Fzf:
    Import-Module PSFzf
    Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r' # ctrl+f->fzf in files,ctrl+r->fzf in history
    ## init the shell
    function Test-Administrator { (New-Object Security.Principal.WindowsPrincipal ([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator) }
    $THEME = "agnoster.minimal.omp.json"
    if (Test-Administrator) {
        $THEME = "spaceship.omp.json"
    }
    Write-Host $paddingString, "'``' is the escape character (use '``n' instead of '\n')" -ForegroundColor "Green"
    oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/$THEME" | Invoke-Expression
    if ([Console]::CapsLock){ # if capslock is on
        Write-host $paddingString "$(Get-char 128288) CAPS-LOCK IS ON" -ForegroundColor "Red"
    }
    # zoxide
    Invoke-Expression (& {
            $hook = if ($PSVersionTable.PSVersion.Major -lt 6) { 'prompt' } else { 'pwd' }
    (zoxide init --hook $hook powershell | Out-String)
        })
    Write-Host $paddingString, "$(Get-char 128104) $identity" -ForegroundColor "Yellow"
    # Set up word autocompletion for winget. 
    Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
        param($wordToComplete, $commandAst, $cursorPosition)
        [Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
        $Local:word = $wordToComplete.Replace('"', '""')
        $Local:ast = $commandAst.ToString().Replace('"', '""')
        winget complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition | ForEach-Object {
            [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
        }
    }
}
# add bash commands to path
if (Test-Path "C:\Program Files\Git\usr\bin"){$env:Path += ';C:\Program Files\Git\usr\bin'}
# external modules
$gsudoModule = Get-Command gsudoModule.psd1 -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Source # search for gsudo
if ($gsudoModule) {
    Import-Module "$gsudoModule" # add gsudo (sudo for windows)
}


# load aliases
. $PSScriptRoot/.pwaliases.ps1
. $PSScriptRoot/.pwfunctions.ps1
if ($promptMode) {
    if (Test-Administrator) {
        Write-Host $paddingString, "$(Get-char 128178) You are Administor" -ForegroundColor "red"
    }
    else {
        Write-Host $paddingString, "$(Get-char 127881) Happy coding!" -ForegroundColor "Gray"
    }

    Write-Host 
}


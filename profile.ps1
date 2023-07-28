[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding # set pw to utf-8:

$DEBUG = $env:PW_DEBUG # set to $true for debug the prompt function
$_first_prompt = $true;
function _init_posh {
    $THEME = "agnoster.minimal.omp.json"
    if (Test-Administrator) {
        $THEME = "spaceship.omp.json"
    }
    $poshPath = if ($env:POSH_THEMES_PATH) { $env:POSH_THEMES_PATH } else { "$HOME/.poshthemes" }
    oh-my-posh init pwsh --config "$poshPath/$THEME" | Invoke-Expression -ErrorVariable posh_error
    if ($posh_error) { Write-host "error: cannot load posh." }
    else { prompt; }; # at this point, oh-my-posh take over the prompt function
}

function _config_psreadline() {
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
}
function _config_env {
    Set-Variable -Name ConfirmPreference -Value High -Scope Global  # prevent windows from popping up confirmation boxes 
    $env:EDITOR = 'code --wait' # --wait required, see https://github.com/Microsoft/vscode/issues/23219 # gh:mikemaccana 
    # add bash commands to path
    if (Test-Path "C:\Program Files\Git\usr\bin") { $env:Path += ';C:\Program Files\Git\usr\bin' }
}
function _init_external {
    # Fzf:
    if (Import-Module PSFzf -ErrorAction SilentlyContinue) {
        Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r' # ctrl+f->fzf in files,ctrl+r->fzf in history
    }
    # zoxide
    <#
    # powershell function define in functions, are only acssesable outside of them, if the function is define with "function global:",
    # so this hook is replacing all zoxide function with global functions:
    # this hook would be needed until zoxide merge my pull request
    #>
    Invoke-Expression (& {
        $hook = if ($PSVersionTable.PSVersion.Major -lt 6) { 'prompt' } else { 'pwd' }
        (zoxide init --hook $hook powershell | Out-String).Replace("function __","function global:__")
    })
    
    # Set up word autocompletion for winget. 
    if (Get-Command winget -errorAction SilentlyContinue) {
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
    # gsudo (like sudo just for windows)
    $gsudoModule = Get-Command gsudoModule.psd1 -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Source # search for gsudo
    if ($gsudoModule) {
        Import-Module "$gsudoModule" # add gsudo (sudo for windows)
    }
}

function _init {
    _init_posh;
    _config_psreadline;
    _config_env;
    _init_external;
    . $PSScriptRoot/pwaliases.ps1 # add aliases from pw
    . $PSScriptRoot/pwfunctions.ps1 # add functions from pw
}


function prompt {
    if ($_first_prompt) { _init; $_first_prompt = $false }    
}
# utils
function Test-Administrator { 
    if ($IsLinux) { return $env:USER -eq 'root' }
    (New-Object Security.Principal.WindowsPrincipal ([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator) 
}

if ($DEBUG){prompt;} # for debug. else powershell would not display any error, but just display the fallback prompt
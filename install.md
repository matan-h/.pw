# install .pw
## Install `mesloLGM NF` (or another [Nerd Font](https://www.nerdfonts.com)):

download https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Meslo.zip,
unzip it,select all the fonts in the folder,right click, then click `install`

## setup the font:
### windows new terminal:
open settings, click on `Windows PowerShell`, scroll and click `Appearance`,chenge font to `mesloLGM NF`

for making powershell more faster, also chenge `cmdline` to `powershell -nologo`

### vscode 
open `command palette`,type `open settings (json)`,then add this (the impotent is the `fontFamily`, the `-nologo` is to make powershell faster):

```json
"terminal.integrated.fontFamily":"MesloLGM NF",
"terminal.integrated.profiles.windows": {
      "PowerShell": {
        "source": "PowerShell",
        "icon": "terminal-powershell",
        "args": ["-nologo"]
      }
}
```
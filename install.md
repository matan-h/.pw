# install .pw
## Install `mesloLGM NF` (or another [Nerd Font](https://www.nerdfonts.com)):

download https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Meslo.zip,
unzip it, select all the fonts in the folder, right click, then click `install`

## set-up the font:
### windows new terminal:
open settings, click on `Windows PowerShell`, scroll and click `Appearance`, change font to `mesloLGM NF`

for making PowerShell faster, also change `cmdline` to `powershell -nologo`

### Visual Studio Code (vscode) 
open `command palette`, type `open settings (json)`, then add this (the impotent is the `fontFamily`, the `-nologo` is to make PowerShell faster):

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
# # install .pw repo
run this command
```powershell
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/matan-h/.pw/main/install.ps1'))
```
done !

![prompt screenshot](https://github.com/matan-h/.pw/raw/main/screenshots/prompt.jpg)

# .pw - PowerShell configuration files (for cool shell in windows)

heavily inspired from [my .config for Linux](https://github.com/matan-h/.config)

-   [install.ps1](./install.ps1) - install [scoop](https://scoop.sh),[git](https://gitforwindows.org/),required command-line tools and PowerShell packages, clone this repository to $HOME\\.pw, and copy [documentProfile.ps1](./documentsProfile.ps1) to $PROFILE (PowerShell startup file)

<!-- todo table of cmd-tools and pwsh-packages installed by the installer-->
-   [profile.ps1](./profile.ps1) - the "main" profile. Print greeting message, setup the cool shell ([oh-my-posh](https://ohmyposh.dev/)) and shell option, source [pwaliases.ps1](./pwaliases.ps1) and [pwfunctions.ps1](./pwfunctions.ps1)

-   [pwaliases.ps1](./pwaliases.ps1) - some aliases that can be under the PowerShell definition of alias - map one command exactly to another (without addition)

-   [pwfunctions.ps1](./pwfunctions.ps1) - a lot of functions - make the shell commands simpler

-   [documentProfile.ps1](./documentsProfile.ps1) - just source [profile.ps1](./profile.ps1)

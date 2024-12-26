#                       _oo0oo_
#                      o8888888o
#                      88" . "88
#                      (| -_- |)
#                      0\  =  /0
#                    ___/`---'\___
#                  .' \\|     |# '.
#                 / \\|||  :  |||# \
#                / _||||| -:- |||||- \
#               |   | \\\  -  #/ |   |
#               | \_|  ''\---/''  |_/ |
#               \  .-\__  '-'  ___/-. /
#             ___'. .'  /--.--\  `. .'___
#          ."" '<  `.___\_<|>_/___.' >' "".
#         | | :  `- \`.;`\ _ /`;.`/ - ` : | |
#         \  \ `_.   \_ __\ /__ _/   .-` /  /
#     =====`-.____`.___ \_____/___.-`___.-'=====
#                       `=---='
#
#     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#            Phật phù hộ, không bao giờ BUG
#     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function Write-Start {
    param($msg)

    Write-Host (">> START: " + $msg) -ForegroundColor Gray
}

function Write-Done {
    param($msg)

    Write-Host (">> DONE: " + $msg) -ForegroundColor Green
    Write-Host
}

function DisableUAC {
    $msg = "Disbale UAC"

    Write-Start -msg $msg

    Start-Process -Wait powershell -Verb runas -ArgumentList "Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 0"
    
    Write-Done -msg $msg
}

function InstallChocolatey {
    $msg = "Install Chocolatey"

    Write-Start -msg $msg

    if (Get-Command choco -ErrorAction SilentlyContinue) {
        Write-Warning "Chocolatey already installed"
    }
    else {
        Set-ExecutionPolicy Bypass -Scope Process
        Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    }

    Write-Done -msg $msg
}

function InstallSoftware {
    $msg = "Install Software"

    Write-Start -msg $msg

    choco install googlechrome -y
    choco install winrar -y
    choco install revo-uninstaller -y
    choco install choco-cleaner -y
    choco install unikey -y

    Write-Done -msg $msg
}

function InstallDevTools {
    $msg = "Install Dev Tools"

    Write-Start -msg $msg

    choco install git -y
    choco install gitkraken -y
    choco install vscode -y
    choco install powertoys -y
    choco install dbeaver -y
    choco install tabby -y
    choco install virtualbox -y
    choco install postman -y

    Write-Done -msg $msg
}


function InstallOffice {
    $msg = "Office"

    Write-Start -msg $msg

    .\office\setup.exe /configure .\office\configuration.xml

    Write-Done -msg $msg
}

function DoIt {
    DisableUAC
    InstallChocolatey
    InstallSoftware
    InstallDevTools
    InstallOffice
}

#########################

# Check-Is-Admin
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

## If not admin, restart as admin
if (-not $isAdmin) {
    Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Path)`"" -Verb RunAs

    Exit
}

DoIt

function Main-Action() {
Write-Output "up and running windows"

if (-not(Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Output "install scoop without sudo"
    Invoke-WebRequest -useb get.scoop.sh | Invoke-Expression
}

scoop install sudo pshazz 7zip git aria2

if (-not(Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Output "install chocolatey with sudo"
    sudo Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}
}

Write-Output "up and running windows"

if (-not(Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Output "install scoop"
    iwr -useb get.scoop.sh | iex
}

scoop install sudo pshazz 7zip git aria2

if (-not(Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Output "install chocolatey"
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

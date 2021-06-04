New-Module -Name env -ScriptBlock {
    function Install-Main {
        Write-Output "up and running windows 10"

        if (-not(Get-Command scoop -ErrorAction SilentlyContinue)) {
            Write-Output "install scoop without sudo"
            Invoke-WebRequest -useb get.scoop.sh | Invoke-Expression
        }

				scoop bucket add extras
        scoop install sudo 7zip git aria2

        if (-not(Get-Command choco -ErrorAction SilentlyContinue)) {
            Write-Output "install chocolatey with sudo"
            sudo Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
						sudo Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
        }
    }
}

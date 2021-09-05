New-Module -Name env -ScriptBlock {
  function Install-Main {
    Write-Output "up and running windows 10"

      if (-not(Get-Command scoop -ErrorAction SilentlyContinue)) {
        Write-Output "install scoop without sudo"
          Invoke-WebRequest -useb get.scoop.sh | Invoke-Expression
      }

    scoop bucket add extras
      scoop install sudo 7zip aria2
  }
}

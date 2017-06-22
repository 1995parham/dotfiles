# In The Name Of God
# ========================================
# [] File Name : install.ps1
#
# [] Creation Date : 20-06-2017
#
# [] Created By : Parham Alvani (parham.alvani@gmail.com)
# =======================================

Write-Output "[pre] Home directory found at $HOME"

Write-Output "[pre] Current directory found at $PSScriptRoot"

Function Make-Copy {
    Param ([string] $module, [string] $file, [bool] $is_hidden)

    if ($is_hidden) {
      $dst_file = ".$file"
    } else {
      $dst_file = "$file"
    }

    $src_path = "$PSScriptRoot\$module\$file"
    $dst_path = "$HOME\$dst_file"

    $create_link = $True

    if (Test-Path $dst_path) {
      $title = "Dotfile exists"
      $message = "Do you want to remove $dst_path ?"

      $yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", `
      "Remove $dst_path."

      $no = New-Object System.Management.Automation.Host.ChoiceDescription "&No", `
      "Keep $dst_path."

      $options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)

      $result = $host.ui.PromptForChoice($title, $message, $options, 0)

      if ($result -eq 1) {
        Remove-Item -Path $dst_path -Recurse -Force
      } else {
        $create_link = $False
      }
    }

    if ($create_link) {
        Copy-Item $src_path $dst_path
		    Write-Output "[$module] Copy created successfully from $src_path to $dst_path"
    }

}

Make-Copy "conf" "wakatime.cfg" $True


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

Function Make-Link {
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
    }

    if ($create_link) {
        New-Item -ItemType SymbolicLink -Name $dst_path -Target $src_path
		    Write-Output "[$module] Symbolic link created successfully from $src_path to $dst_path"
    }

}

Make-Link "conf" "wakatime.cfg" $True

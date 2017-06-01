$Host.UI.RawUI.BackgroundColor = "DarkMagenta"
$Host.UI.RawUI.ForegroundColor = "DarkYellow"
$Host.UI.RawUI.BufferSize.Height = 3000
$Host.UI.RawUI.BufferSize.Width = 180
$Host.UI.RawUI.WindowSize.Width = 180
$Host.UI.RawUI.WindowSize.Height = 62

#ErrorForegroundColor    : Red
#ErrorBackgroundColor    : Black
#WarningForegroundColor  : Yellow
#WarningBackgroundColor  : Black
#DebugForegroundColor    : Yellow
#DebugBackgroundColor    : Black
#VerboseForegroundColor  : Yellow
#VerboseBackgroundColor  : Black
#ProgressForegroundColor : Yellow
#ProgressBackgroundColor : DarkCyan

function prompt
{
    Write-Host ("PS") -NoNewline
    Write-Host (" " + $env:USERNAME) -NoNewline -ForegroundColor Yellow 
    Write-Host (" " + $(Get-Date)) -NoNewline -ForegroundColor Green
    Write-Host (" " + $(Get-Location)) -ForegroundColor Red
    Write-Host (" >") -NoNewline
    return " "
}

Set-Location $HOME
Clear-Host

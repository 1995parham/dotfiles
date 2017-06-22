Function Foreground-Color {
	Param ([int] $color)

	$CSI = [char]0x1b + '['

	if ($color -eq 0) {
		"${CSI}39m"
	} else {
		"${CSI}38;5;${color}m"
	}
}

Function Prompt
{
	"PS $(Foreground-Color 27)$(whoami) $(Foreground-Color 46)[$($executionContext.SessionState.Path.CurrentLocation)]$(Foreground-Color 0)
$('>' * ($nestedPromptLevel + 1)) "
}

Set-Location $HOME
Clear-Host

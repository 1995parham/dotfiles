" Filename:	bash.vim
" Purpose:	Vim syntax file
" Language:	Bash - Unix Shell
" Maintainer:	Donovan Rebbechi elflord@pegasus.rutgers.edu
" Maintainer:	Parham Alvani parham.alvani@gmail.com
" URL:		http://pegasus.rutgers.edu/~elflord/vim/syntax/bash.vim
" Last update:	Tue Aug  4 09:02:08 EDT 1998
"
" Updated 1998 July 27
" 	Fixed bugs with embedded echos and command subs in bash
" Updated 1998 August 1
"	Changed Colouring. Added bash environment variables. Added keywords
"	and command options.
" Updated 1998 August 2
"	Use awk syntax file.
" Updated 2015 January 15
" 	Bash options added.
"	

" Remove any old syntax stuff hanging around

syn clear
if !exists("bash_minlines")
	let bash_minlines = 100
endif
if !exists("bash_maxlines")
	let bash_minlines = 2 * bash_minlines
endif



syn include @bashAwk <sfile>:p:h/awk.vim

syn region bashAwkBlockSingle matchgroup=bashStatement start=+g\=awk[ \t]*-[^ \t]*[ \t]*'{+ end=+}'+ contains=@bashAwk
syn region bashAwkBlockSingle matchgroup=bashStatement start=+g\=awk[ \t]*-[^ \t]*[ \t]*"{+ end=+}"+ contains=@bashAwk,bashDeref


" Comment out this to get less colour
" let hi_color=1

" bash syntax is case sensitive
syn case match

syn keyword	bashTodo		contained TODO
syn match	bashComment		"#.*$" contains=bashTodo

" String and Character constants
"===============================
syn match   bashNumber       "-\=\<\d\+\>"
syn match   bashSpecial      contained "\\\d\d\d\|\\[abcfnrtv]"
syn region  bashSinglequote matchgroup=bashOperator start=+'+ end=+'+ 
syn region  bashDoubleQuote      matchgroup=bashOperator start=+"+ skip=+\\"+ end=+"+ contains=bashDeref,bashCommandSub,bashSpecialShellVar,bashSpecial
syn match  bashSpecial  "\\[\\\"\'`$]"
	" This must be after the strings, so that bla \" be correct
syn region bashEmbeddedEcho contained matchgroup=bashStatement start="\<echo\>" skip="\\$" matchgroup=bashOperator end="$" matchgroup=NONE end="[<>;&|`)]"me=e-1 end="\d[<>]"me=e-2 end="#"me=e-1 contains=bashNumber,bashSinglequote,bashDeref,bashSpecialVar,bashSpecial,bashOperator,bashDoubleQuote
 	" This one is needed INSIDE a CommandSub, so that
 	" `echo bla` be correct
syn region bashEcho matchgroup=bashStatement start="\<echo\>" skip="\\$" matchgroup=bashOperator end="$" matchgroup=NONE end="[<>;&|]"me=e-1 end="\d[<>]"me=e-2 end="#"me=e-1 contains=bashNumber,bashCommandSub,bashSinglequote,bashDeref,bashSpecialVar,bashSpecial,bashOperator,bashDoubleQuote,bashDotStrings,bashFileNames

"Error Codes
syn match   bashDoError "\<done\>"
syn match   bashIfError "\<fi\>"
syn match   bashInError "\<in\>"
syn match   bashCaseError ";;"
syn match   bashEsacError "\<esac\>"
syn match   bashCurlyError "}"
syn match   bashParenError ")"
if exists("is_kornshell")
syn match     bashDTestError "]]"
endif
syn match     bashTestError "]"

" Tests
"======
syn region  bashNone transparent matchgroup=bashOperator start="\[" skip=+\\\\\|\\$+ end="\]" contains=ALLBUT,bashFunction,bashTestError,bashIdentifier,bashCase,bashDTestError,bashDerefOperator,@bashSedStuff
syn region  bashNone transparent matchgroup=bashStatement start="\<test\>" skip=+\\\\\|\\$+ matchgroup=NONE end="[;&|]"me=e-1 end="$" contains=ALLBUT,bashFunction,bashIdentifier,bashCase,bashDerefOperator,@bashSedStuff
syn match   bashTestOpr contained "[!=]\|-.\>\|-\(nt\|ot\|ef\|eq\|ne\|lt\|le\|gt\|ge\)\>"

" DO/IF/FOR/CASE : Repitition operaters
" ======================================
syn region  bashDo transparent matchgroup=bashBlock start="\<do\>" end="\<done\>" contains=ALLBUT,bashFunction,bashDoError,bashCase,bashDerefOperator,@bashSedStuff
syn region  bashIf transparent matchgroup=bashBlock start="\<if\>" end="\<fi\>" contains=ALLBUT,bashFunction,bashIfError,bashCase,bashDerefOperator,@bashSedStuff
syn region  bashFor  matchgroup=bashStatement start="\<for\>" end="\<in\>" contains=ALLBUT,bashFunction,bashInError,bashCase,bashDerefOperator,@bashSedStuff
syn region bashCaseEsac transparent matchgroup=bashBlock start="\<case\>" matchgroup=NONE end="\<in\>"me=s-1 contains=ALLBUT,bashFunction,bashCaseError nextgroup=bashCaseEsac,bashDerefOperator,@bashSedStuff
syn region bashCaseEsac matchgroup=bashBlock start="\<in\>" end="\<esac\>" contains=ALLBUT,bashFunction,bashCaseError,bashDerefOperator,@bashSedStuff
syn region bashCase matchgroup=bashBlock contained start=")"  end=";;" contains=ALLBUT,bashFunction,bashCaseError,bashCase,bashDerefOperator,@bashSedStuff
syn region  bashNone transparent matchgroup=bashOperator start="{" end="}" contains=ALLBUT,bashCurlyError,bashCase,bashDerefOperator,@bashSedStuff
syn region  bashSubSh transparent matchgroup=bashOperator start="(" end=")" contains=ALLBUT,bashParenError,bashCase,bashDerefOperator,@bashSedStuff

" Misc
"=====
syn match   bashOperator		"[!&;|=]"
syn match   bashWrapLineOperator	"\\$"
syn region  bashCommandSub   matchGroup=bashSpecial start="`" skip="\\`" end="`" contains=ALLBUT,bashFunction,bashCommandSub,bashTestOpr,bashCase,bashEcho,bashDerefOperator,@bashSedStuff
syn region  bashCommandSub matchgroup=bashOperator start="$(" end=")" contains=ALLBUT,bashFunction,bashCommandSub,bashTestOpr,bashCase,bashEcho,bashDerefOperator,@bashSedStuff
syn match   bashSource	"^\.\s"
syn match   bashSource	"\s\.\s"
syn region  bashColon	start="^\s*:" end="$\|" end="#"me=e-1 contains=ALLBUT,bashFunction,bashTestOpr,bashCase,bashDerefOperator,@bashSedStuff

" File redirection highlighted as operators
"==========================================
syn match	bashRedir	"\d\=>\(&[-0-9]\)\="
syn match	bashRedir	"\d\=>>-\="
syn match	bashRedir	"\d\=<\(&[-0-9]\)\="
syn match	bashRedir	"\d<<-\="

" Shell Input Redirection (Here Documents)
syn region bashHereDoc matchgroup=bashRedir start="<<-\=\s*\**END[a-zA-Z_0-9]*\**" matchgroup=bashRedir end="^END[a-zA-Z_0-9]*$"
syn region bashHereDoc matchgroup=bashRedir start="<<-\=\s*\**EOF\**" matchgroup=bashRedir end="^EOF$"

" Identifiers
"============
syn match  bashIdentifier "\<[a-zA-Z_][a-zA-Z0-9_]*\>="me=e-1
syn region bashIdentifier matchgroup=bashStatement start="\<\(declare\|typeset\|local\|export\|set\|unset\)\>[^/]"me=e-1 matchgroup=bashOperator skip="\\$" end="$\|[;&]" matchgroup=NONE end="#\|="me=e-1 contains=bashTestError,bashCurlyError,bashWrapLineOperator,bashDeref

" The [^/] in the start pattern is a kludge to avoid bad
" highlighting with cd /usr/local/lib...

syn region  bashFunction transparent matchgroup=bashFunctionName 	start="^\s*\<[a-zA-Z_][a-zA-Z0-9_]*\>\s*()\s*{" end="}" contains=ALLBUT,bashFunction,bashCurlyError,bashCase,bashDerefOperator,@bashSedStuff

" CHanged this
syn region bashDeref	     start="\${" end="}" contains=bashDerefOperator,bashSpecialVariables
syn match  bashDeref	     "\$\<[a-zA-Z_][a-zA-Z0-9_]*\>" contains=bashSpecialVariables

" A bunch of useful bash keywords
syn keyword bashStatement    break cd chdir continue eval exec exit kill newgrp pwd read readonly return shift test trap ulimit umask wait bg fg jobs stop suspend alias fc getopts hash history let print time times type whence unalias source bind builtin dirs disown enable help history logout popd printf pushd shopt login newgrp gnugrep grep egrep fgrep du find gnufind expr tail sort clear less sleep ls rm install chmod mkdir rmdir strip rpm mv touch sed
syn keyword bashAdminStatement killproc daemon start stop restart reload status killall nice
syn keyword bashConditional  else then elif if fi
syn keyword bashRepeat       select until for done do while
syn keyword bashFunction     function
syn keyword bashOption	autocd cdable_vars cdspell checkhash checkjobs checkwinsize cmdhist compat31 compat32 compat40 compat41 dirspell dotglob execfail expand_aliases extdebug extglob extquote failglob force_fignore globstar gnu_errfmt histappend histreedit histverify hostcomplete huponexit interactive_comments lastpipe lithist login_shell mailwarn no_empty_cmd_completion nocaseglob nocasematch nullglob progcomp promptvars restricted_shell shift_verbose sourcepath xpg_echo

" Syncs
" =====
if !exists("bash_minlines")
  let bash_minlines = 100
endif
exec "syn sync minlines=" . bash_minlines
syn sync match bashDoSync       grouphere  bashDo       "\<do\>"
syn sync match bashDoSync       groupthere bashDo       "\<done\>"
syn sync match bashIfSync       grouphere  bashIf       "\<if\>"
syn sync match bashIfSync       groupthere bashIf       "\<fi\>"
syn sync match bashForSync      grouphere  bashFor      "\<for\>"
syn sync match bashForSync      groupthere bashFor      "\<in\>"
syn sync match bashCaseEsacSync grouphere  bashCaseEsac "\<case\>"
syn sync match bashCaseEsacSync groupthere bashCaseEsac "\<esac\>"

syn match bashDerefOperator contained  +##\=\|%%\=+



" command line options

syn match bashCommandOpts "\(--\=\|+\)\([a-zA-Z]\)\=\([a-zA-Z0-9]\)*"

" special variables
syn keyword bashSpecialVariables contained PPID PWD OLDPWD REPLY UID EUID GROUPS BASH BASH_VERSION BASH_VERSINFO SHLVL RANDOM SECONDS LINENO HISTCMD DIRSTACK PIPESTATUS OPTARG OPTIND HOSTNAME HOSTTYPE OSTYPE MACHTYPE SHELLOPTS IFS PATH HOME CDPATH BASH_ENV MAIL MAILCHECK PS1 PS2 PS3 PS4 TIMEFORMAT HISTSIZE HISTFILE HISTFILESIZE LANG LC_ALL LC_COLLATE LC_MESSAGES PROMPT_COMMAND IGNOREEOF TIMEOUT FCEDIT FIGNORE GLOBIGNORE INPUTRC HISTCONTROL histchars HOSTFILE auto_resume HISTIGNORE OPTERR MAILPATH
syn match  bashSpecialShellVariables "\$[-#@*$?!0-9]"

" Wildcard
" ========
" class
syn match bashClass	"\[:alnum:\]"
syn match bashClass	"\[:alpha\]"
syn match bashClass	"\[:blank:\]"
syn match bashClass	"\[:cntrl:\]"
syn match bashClass	"\[:digit:\]"
syn match bashClass	"\[:graph:\]"
syn match bashClass	"\[:lower:\]"
syn match bashClass	"\[:print:\]"
syn match bashClass	"\[:punct:\]"
syn match bashClass	"\[:space:\]"
syn match bashClass	"\[:upper:\]"
syn match bashClass	"\[:xdigit:\]"

" The default methods for highlighting.  Can be overridden later


if !exists("did_bash_syntax_inits")
  let did_bash_syntax_inits = 1
  hi link bashAdminStatement	Function
  hi link bashBlock		Function
  hi link bashCaseError		Error
  hi link bashClass		Type
  hi link bashColon		bashStatement
  hi link bashCommandOpts	Operator
  hi link bashComment 		Comment
  hi link bashConditional 	Conditional
  hi link bashCurlyError	Error
  hi link bashDeref		bashShellVariables
  hi link bashDerefOperator 	bashOperator
  hi link bashDoError		Error
  hi link bashDoubleQuote	bashString
  hi link bashEcho		bashString
  hi link bashEmbeddedEcho	bashString
  hi link bashEsacError		Error
  hi link bashFunction	        Function
  hi link bashFunctionName	Function
  hi link bashHereDoc		bashString
  hi link bashIdentifier	Identifier
  hi link bashIfError		Error
  hi link bashInError		Error
  hi link bashNumber		Number
  hi link bashOperator		Operator
  hi link bashOption		Type
  hi link bashParenError	Error
  hi link bashRedir		bashOperator
  hi link bashRepeat		Repeat
  hi link bashShellVariables	PreProc
  hi link bashSinglequote	bashString
  hi link bashSource		bashOperator
  hi link bashSpecial		Special
  hi link bashSpecial		Special
  hi link bashSpecialShellVariables	Type
  hi link bashSpecialShellVar	Type
  hi link bashSpecialVariables	bashSpecialVars
  hi link bashSpecialVars	Identifier
  hi link bashStatement		Statement
  hi link bashString		String
  hi link bashTestError		Error
  hi link bashTestOpr		bashConditional
  hi link bashTodo		Todo
  hi link bashVariables		PreProc
  hi link bashWrapLineOperator	bashOperator
endif
let b:current_syntax = "bash"

" vim: ts=8

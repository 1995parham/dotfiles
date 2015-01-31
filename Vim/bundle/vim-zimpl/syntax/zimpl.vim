" In The Name Of God
" Vim syntax file
" Last Change:	2015 Jan 31
" Maintainer:	Parham Alvani <parham.alvani@gmail.com>
" Language:	Zimpl
"
if version < 600
	syntax clear
elseif exists("b:current_syntax")
	finish
endif

syn case ignore

" strings
syn region zplString	start=/"/ end=/"/ contains=@spell

" comment
syn region zplComment	start=/#/ end=/$/

" tuples and sets
syn keyword zplSets	set
syn keyword zplSetsOp1	cross union inter without symdiff argmin argmax
syn match zplSetsOp2	/\\\|:=\|{\|}/
syn keyword zplSetsFunc	powerset subsets indexset

" parameters
syn keyword zplPrms	param
syn match zplPrmsInd	/[][]/	

" variables
syn keyword zplVars	var

" constraints
syn keyword zplConstrain	subto
syn keyword zplConstrainAttr	scale separate checkonly indicator

" user defiend function
syn region zplParen		transparent start="(" end=")" contains=ALLBUT
syn keyword zplUserFuncID	defset defnumb defstrg defbool	
syn match zplUserFunc		/\w\+\s*(\@=/ contains=zplParen

" initializing from file
syn keyword zplFileFunc		read
syn keyword zplFileKeyword	as skip use match comment

" keyword etc
syn keyword zplKeyword	in forall minimize maximize do defualt
syn keyword zplFunc	min max sum prod card random ord length round ceil floor sgn abs
syn keyword zplFunc	sqrt log ln exp
syn keyword zplFunc	print check
syn keyword zplOp1	mod and or xor not
syn match zplOp2	/[\^*+-/]\|==\|<\|<=\|!=\|>=\|>/
syn keyword zplCond	if then else end with without vif
syn match zplNumber	/-\?\d\+/

" links to default
hi def link zplSets	Type
hi def link zplSetsOp1	Operator
hi def link zplSetsOp2	Operator
hi def link zplSetsFunc	Function

hi def link zplString	String

hi def link zplComment	Comment

hi def link zplPrms	Type
hi def link zplPrmsInd	Operator

hi def link zplVars	Type

hi def link zplFileFunc		Function
hi def link zplFileKeyword	Keyword

hi def link zplConstrain	Statement
hi def link zplConstrainAttr	Special

hi def link zplUserFuncID	Identifier
hi def link zplUserFunc		Function

hi def link zplKeyword	Keyword
hi def link zplOp1	Operator
hi def link zplOp2	Operator
hi def link zplFunc	Function
hi def link zplNumber	Constant

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
syn region zplString	start=/"/ end=/"/

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

" initializing from file
syn keyword zplFileFunc		read
syn keyword zplFileKeyword	as skip use match comment

" keyword etc
syn keyword zplKeyword	in forall minimize maximize do defualt
syn keyword zplFunc	min max sum prod card random ord length round ceil floor sgn abs
syn keyword zplFunc	sqrt log ln exp
syn keyword zplFunc	print check
syn keyword zplOp1	mod
syn match zplOp2	/[\^*+-/]\|==\|<\|<=\|!=\|>=\|>/
syn keyword zplCond	if then else end with without
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

hi def link zplKeyword	Keyword
hi def link zplOp1	Operator
hi def link zplOp2	Operator
hi def link zplFunc	Function
hi def link zplNumber	Constant

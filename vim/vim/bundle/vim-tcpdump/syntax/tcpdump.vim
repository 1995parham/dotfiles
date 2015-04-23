" In The Name Of God
" Vim syntax file
" Last Change:	2015 Feb 03
" Maintainer:	Parham Alvani <parham.alvani@gmail.com>
" Language: TcpDump
"
if version < 600
	syntax clear
elseif exists("b:current_syntax")
	finish
endif

" syn case ignore

" Mac Address
syn match tcpMacAddress	/\(\x\{2}:\)\{5}\x\{2}/

" IPv4 Address
syn match tcpIp4Address	/\(\d\{1,3}\.\)\{3}\d\{1,3}/

" FQDN
syn match tcpFQDN	/\<\([a-zA-Z0-9\-]\{1,63}\.\)\+[a-zA-Z]\{2,63}\>/

" Packet length
syn keyword tcpLength	length

" Tcp header
syn keyword tcpHeader	ack seq win options
syn keyword tcpOptions	nop sack TS

" Packet types
syn keyword tcpPType	IP IP6 ARP STP
syn keyword tcpIPType	TCP UDP ICMP

" Send direction operator
syn match tcpOperator	/[<>]/

" Timestamp
syn match tcpTimeStamp	/\d\{2}:\d\{2}:\d\{2}\.\d\{6}/

hi def link tcpTimeStamp	String
hi def link tcpMacAddress	Type
hi def link tcpIp4Address	Type
hi def link tcpFQDN	Type
hi def link tcpHeader	Identifier
hi def link tcpLength	Identifier
hi def link tcpOptions	PreProc
hi def link tcpPType	Special
hi def link tcpIPType	Conditional
hi def link tcpOperator	Operator

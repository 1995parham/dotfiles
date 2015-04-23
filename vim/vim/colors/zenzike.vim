" zenzike.vim (c) 2010+ Nicolas Wu
" Name: zenzike.vim
" Maintainer: Nicolas Wu <zenzike@gmail.com>
"
" This theme is designed to work for 88 and 256 colour terminals,
" as well as in gvim.

set background=dark
hi clear

if exists("syntax_on")
 syntax reset
endif

let colors_name = "zenzike"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Highlight Groups
"  :h highlight-groups
"  :h group-name

"    colorgroup       fg      bg      cterm   gui         guisp
let s:colors88 = [
  \ ["Normal",        "15",   "",    "",     "",         ""],
  \ ["NonText",       "",   "80",    "",     "",         ""],
  \ ["MatchParen",    "",     "82",   "",     "",         ""],
  \ ["ColorColumn",   "",     "80",   "",     "",         ""],
  \ ["Cursor",        "",    "9",    "",     "",         ""],
  \ ["CursorLine",    "",     "81",   "none", "",         ""],
  \ ["CursorColumn",  "",     "81",   "none", "",         ""],
  \ ["Directory",     "",     "",     "",     "",         ""],
  \ ["ErrorMsg",      "1",    "80",   "bold", "",         ""],
  \ ["WarningMsg",    "7",    "8",    "bold", "",         ""],
  \ ["ModeMsg",       "",     "",     "bold", "",         ""],
  \ ["MoreMsg",       "",     "",     "bold", "",         ""],
  \ ["LineNr",        "86",   "80",   "",     "",         ""],
  \ ["VertSplit",     "80",   "15",   "",     "",         ""],
  \ ["StatusLine",    "85",   "",    "",     "",         ""],
  \ ["StatusLineNC",  "80",   "15",   "",     "",         ""],
  \ ["TabLine",       "87",   "81",   "none", "",         ""],
  \ ["TabLineFill",   "81",   "",     "",     "",         ""],
  \ ["TabLineSel",    "15",   "",    "bold", "",         ""],
  \ ["Folded",        "47",   "81",   "",     "",         ""],
  \ ["FoldColumn",    "",     "",     "",     "",         ""],
  \ ["SignColumn",    "",     "43",   "",     "",         ""],
  \ ["Search",        "",    "77",   "",     "",         ""],
  \ ["Incsearch",     "",     "",     "",     "",         ""],
  \ ["Title",         "85",   "none", "bold", "",         ""],
  \ ["Visual",        "none", "81",   "",     "",         ""],
  \ ["VisualNOS",     "",     "6",    "",     "",         ""],
  \ ["SpecialKey",    "11",   "",     "",     "",         ""],
  \ ["Pmenu",         "80",    "86",   "",     "",         ""],
  \ ["PmenuSel",      "44",   "81",   "",     "",         ""],
  \ ["PmenuSbar",     "",    "86",   "",     "",         ""],
  \ ["PmenuThumb",    "",     "",     "",     "",         ""],
  \ ["Question",      "",     "",     "",     "",         ""],
  \ ["WildMenu",      "",    "2",    "",     "",         ""],
  \ ["SpellBad",      "",     "32",   "",     "undercurl",""],
  \ ["SpellRare",     "",     "",     "",     "",         ""],
  \ ["SpellLocal",    "",     "17",   "",     "",         ""],
  \ ["SpellCap",      "",     "",     "",     "",         ""],
  \ ["DiffAdd",       "28",   "80",   "",     "",         ""],
  \ ["DiffChange",    "",     "16",   "",     "",         ""],
  \ ["DiffDelete",    "32",   "16",   "bold",     "",         ""],
  \ ["DiffText",      "76",   "80",   "none", "",         ""],
  \ ["Comment",       "83",   "",     "",     "",         ""],
  \ ["Costant",       "61",   "",     "",     "",         ""],
  \ ["String",        "44",   "",     "",     "",         ""],
  \ ["Number",        "67",   "",     "",     "",         ""],
  \ ["Float",         "67",   "",     "",     "",         ""],
  \ ["Identifier",    "56",   "",     "",     "",         ""],
  \ ["Function",      "52",   "",     "",     "",         ""],
  \ ["Statement",     "43",   "",     "",     "none",     ""],
  \ ["Conditional",   "26",   "",     "",     "",         ""],
  \ ["Operator",      "42",   "",     "",     "",         ""],
  \ ["Keyword",       "27",   "",     "",     "",         ""],
  \ ["Exception",     "46",   "",     "",     "",         ""],
  \ ["PreProc",       "63",   "",     "",     "",         ""],
  \ ["Type",          "77",   "",     "",     "",         ""],
  \ ["Special",       "73",   "",     "",     "",         ""],
  \ ["SpecialChar",   "73",   "",     "",     "",         ""],
  \ ["Delimiter",     "25",   "",     "",     "",         ""],
  \ ["Ignore",        "80",   "",     "",     "",         ""],
  \ ["Error",         "",    "32",   "",     "",         ""],
  \ ["Todo",          "",    "84",   "",     "",         ""],
  \ ["Underlined",    "77",   "",     "bold", "",         ""]]

function! s:from88to256(n)
  if a:n < 16
    return a:n
  elseif a:n > 79
    return 234 + (3 * (a:n - 80))
  else
    let l:m = [0,1,3,5]
    let l:b = a:n - 16
    let l:x = b % 4
    let l:y = (b / 4) % 4
    let l:z = b / 16
    return 16 + l:m[l:x] + (6 * l:m[l:y] + 36 * l:m[l:z])
endfunction

function! s:from88toRGB(n)
  let l:colors = []
  " ansi
  for i in [
    \ 0x000000, 0xcc0000, 0x00cc00, 0xcccc00,
    \ 0x0000cc, 0xcc00cc, 0x00cccc, 0xcccccc,
    \ 0x333333, 0xff0000, 0x00ff00, 0xffff00,
    \ 0x0000ff, 0xff00ff, 0x00ffff, 0xffffff ]
    let l:colors += [printf("#%06x", i)]
  endfor

  " colour cube
  let l:cincr = [0, 0x8b, 0xcd, 0xff]
  for i in l:cincr
    for j in l:cincr
      for k in l:cincr
        let l:colors += [printf("#%02x%02x%02x", i, j, k)]
      endfor
    endfor
  endfor

  " greys
  for i in [0x2e, 0x5c, 0x73, 0x8b, 0xa2, 0xb9, 0xd0, 0xe7]
    let l:colors += [printf("#%02x%02x%02x", i, i, i)]
  endfor
  return l:colors[a:n]
endfunction

function! s:setColour88()
  for s:col in s:colors88
    if (s:col[1].s:col[2].s:col[3] != "")
      let l:highlight = "hi ".s:col[0]
      if (s:col[1] != "")
        let l:highlight .= " ctermfg=".s:col[1]
      endif
      if (s:col[2] != "")
        let l:highlight .= " ctermbg=".s:col[2]
      endif
      if (s:col[3] != "")
        let l:highlight .= " cterm=".s:col[3]
      endif
      exec l:highlight
    endif
  endfor
endfunction

function! s:setColour256()
  for s:col in s:colors88
    if (s:col[1].s:col[2].s:col[3] != "")
      let l:highlight = "hi ".s:col[0]
      if (s:col[1] != "")
        let l:highlight .= " ctermfg=".s:from88to256(s:col[1]+0)
      endif
      if (s:col[2] != "")
        let l:highlight .= " ctermbg=".s:from88to256(s:col[2]+0)
      endif
      if (s:col[3] != "")
        let l:highlight .= " cterm=".s:col[3]
      endif
      exec l:highlight
    endif
  endfor
endfunction

function! s:setColourRGB()
  for s:col in s:colors88
    if (s:col[1].s:col[2].s:col[3].s:col[4].s:col[5] != "")
      let l:highlight = "hi ".s:col[0]
      if (s:col[1] != "" && s:col[1] != "none")
        let l:highlight .= " guifg=".s:from88toRGB(s:col[1]+0)
      endif
      if (s:col[2] != "" && s:col[2] != "none")
        let l:highlight .= " guibg=".s:from88toRGB(s:col[2]+0)
      endif
      if s:col[4] != ""
        let l:highlight .= " gui=".s:col[4]
      elseif s:col[3] != ""
        let l:highlight .= " gui=".s:col[3]
      endif
      if (s:col[5] != "")
        let l:highlight .= " guisp=".s:col[5]
      endif
      exec l:highlight
    endif
  endfor
endfunction

if !has("gui_running")
  if &t_Co == 256
    call s:setColour256()
  else
    call s:setColour88()
  endif
else
  call s:setColourRGB()
endif

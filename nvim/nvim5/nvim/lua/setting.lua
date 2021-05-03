vim.o.syntax = 'on'

--- uft-8 encoding
vim.o.encoding = 'utf-8'

-- Correct delete key in OSX
vim.o.backspace = 'eol,start,indent'

vim.o.autoindent = true
vim.o.smartindent = true
-- when on, lines longer than the width of the window will wrap and
-- displaying continues on the next line.
vim.wo.wrap = true
-- when on, a <Tab> in front of a line inserts blanks according to
-- 'shiftwidth'.  'tabstop' or 'softtabstop' is used in other places.  A
-- <BS> will delete a 'shiftwidth' worth of space at the start of the
-- line.
vim.o.smarttab = true
-- print the line number in front of each line.
vim.wo.number = true
vim.o.number = true
-- in insert mode: use the appropriate number of spaces to insert a <Tab>.
vim.o.expandtab = true
-- gives the end-of-line (<EOL>) formats that will be tried when
-- starting to edit a new buffer and when reading a file into an existing
-- buffer.
vim.o.fileformats = 'unix,dos'

-- number of spaces that a <Tab> in the file counts for.
vim.o.tabstop = 2
vim.bo.tabstop = vim.o.tabstop
-- number of spaces to use for each step of (auto)indent.
vim.bo.shiftwidth = vim.bo.tabstop
vim.o.shiftwidth = vim.bo.tabstop
-- number of spaces that a <Tab> counts for while performing editing
-- operations, like inserting a <Tab> or using <BS>.
vim.bo.softtabstop = vim.bo.tabstop
vim.o.softtabstop = vim.bo.tabstop

if vim.fn.has('termguicolors') == 1 then vim.o.termguicolors = true end

-- autoload files that have changed outside of vim
vim.o.autoread = true

-- highlight tailing whitespace
vim.o.listchars = 'trail:·'

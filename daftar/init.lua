-- Neovim for Daftar: the settings of ~/.config/nvim/lua/core/options.lua,
-- with no plugins. Daftar starts Neovim with this file (`nvim_config` in
-- config.toml) and draws the note itself, so the options that only change
-- the terminal's screen are left out: numbers, signs, tab line, blend,
-- colour column, list characters.

local cache_dir = os.getenv("HOME") .. "/.cache/nvim/"

-- The runtime's own plugins that a note does not need, as in core/init.lua.
for _, name in ipairs({
    "gzip",
    "tar",
    "tarPlugin",
    "zip",
    "zipPlugin",
    "getscript",
    "getscriptPlugin",
    "vimball",
    "vimballPlugin",
    "matchit",
    "matchparen",
    "2html_plugin",
    "logiPat",
    "rrhelper",
    "netrw",
    "netrwPlugin",
    "netrwSettings",
    "netrwFileHandlers",
}) do
    vim.g["loaded_" .. name] = 1
end

-- Space is the leader key.
vim.g.mapleader = " "

-- Files: Daftar and git keep the history, so no swap or backup files. A
-- swap file would also stop a second Neovim on the same note.
vim.opt.fileformats = "unix,mac,dos"
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.hidden = true
-- The same undo history as your other Neovim.
vim.opt.undofile = true
vim.opt.undodir = cache_dir .. "undo/"
vim.opt.spellfile = cache_dir .. "spell/en.utf-8.add"
vim.opt.history = 2000
vim.opt.shada = "!,'300,<50,@100,s10,h"

-- The macOS clipboard is the unnamed register.
vim.opt.clipboard = "unnamedplus"
vim.g.clipboard = {
    name = "macOS-clipboard",
    copy = { ["+"] = "pbcopy", ["*"] = "pbcopy" },
    paste = { ["+"] = "pbpaste", ["*"] = "pbpaste" },
    cache_enabled = 0,
}

-- Keys and timing.
vim.opt.timeout = true
vim.opt.ttimeout = true
vim.opt.timeoutlen = 500
vim.opt.ttimeoutlen = 10
vim.opt.updatetime = 250
vim.opt.errorbells = true
vim.opt.visualbell = true

-- Search.
vim.opt.magic = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.infercase = true
vim.opt.incsearch = true
vim.opt.wrapscan = true
vim.opt.inccommand = "nosplit"
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.grepprg = "rg --hidden --vimgrep --smart-case --"

-- Moving.
vim.opt.virtualedit = "block"
vim.opt.startofline = false
vim.opt.whichwrap = "h,l,<,>,[,],~"
vim.opt.backspace = "indent,eol,start"
vim.opt.jumpoptions = "stack"
vim.opt.scrolloff = 2
vim.opt.sidescrolloff = 5

-- Completion and the command line.
vim.opt.complete = ".,w,b,k"
vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.wildignorecase = true
vim.opt.wildignore = ".git,.hg,.svn,*.pyc,*.o,*.out,*.jpg,*.jpeg,*.png,*.gif,*.zip"
    .. ",**/tmp/**,*.DS_Store,**/node_modules/**,**/bower_modules/**"
vim.opt.shortmess = "aoOTIcF"
-- Daftar shows the mode in its own status bar.
vim.opt.showmode = false
vim.opt.showcmd = false

-- Indenting: two spaces, as in your config. A note's lists still take
-- four, from the runtime's markdown settings, as the vault's markdownlint
-- wants them.
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smarttab = true
vim.opt.shiftround = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = -1
vim.opt.foldlevelstart = 99
vim.opt.foldenable = false

-- Lines: different from your config on purpose. A paragraph is one long
-- line in the vault, and Daftar wraps it on screen, so Neovim wraps too
-- (`j`, `zz` and the scroll then count the same lines Daftar shows) and
-- never breaks a line by itself.
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.breakindentopt = "shift:2,min:20"
vim.opt.breakat = [[\ \	;:,!?]]
vim.opt.textwidth = 0
vim.opt.formatoptions = "1jcroql"

if vim.fn.executable("fish") == 1 then
    vim.opt.shell = "fish"
else
    vim.opt.shell = "bash"
end

-- Space does nothing alone, as in your keymap/config.lua. Your buffer,
-- tab and window keys are left out: Daftar shows one note, the one it
-- opened, and a key that leaves that buffer would leave the view behind.
vim.keymap.set({ "n", "x" }, " ", "", { noremap = true })

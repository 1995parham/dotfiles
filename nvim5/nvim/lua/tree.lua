local tree_cb = require'nvim-tree.config'.nvim_tree_callback

vim.g.nvim_tree_ignore = { '.git', 'node_modules', '.cache' }
vim.g.nvim_tree_auto_open = 1
vim.g.nvim_tree_auto_close = 1
vim.g.nvim_tree_auto_ignore_ft = { 'dashboard' }
vim.g.nvim_tree_gitignore = 1
vim.g.nvim_tree_tab_open = 1

vim.g.nvim_tree_bindings = {
	["<CR>"]           = tree_cb("edit"),
	["o"]              = tree_cb("edit"),
	["<2-LeftMouse>"]  = tree_cb("edit"),
	["<2-RightMouse>"] = tree_cb("cd"),
	["<C-]>"]          = tree_cb("cd"),
	["v"]							 = tree_cb("vsplit"),
	["s"]              = tree_cb("split"),
	["t"]              = tree_cb("tabnew"),
	["<"]              = tree_cb("prev_sibling"),
	[">"]              = tree_cb("next_sibling"),
	["<BS>"]           = tree_cb("close_node"),
	["<S-CR>"]         = tree_cb("close_node"),
	["<Tab>"]          = tree_cb("preview"),
	["I"]              = tree_cb("toggle_ignored"),
	["H"]              = tree_cb("toggle_dotfiles"),
	["R"]              = tree_cb("refresh"),
	["ma"]             = tree_cb("create"),
	["md"]             = tree_cb("remove"),
	["mm"]             = tree_cb("rename"),
	["<C-r>"]          = tree_cb("full_rename"),
	["x"]              = tree_cb("cut"),
	["c"]              = tree_cb("copy"),
	["p"]              = tree_cb("paste"),
	["[c"]             = tree_cb("prev_git_item"),
	["]c"]             = tree_cb("next_git_item"),
	["-"]              = tree_cb("dir_up"),
	["q"]              = tree_cb("close"),
}

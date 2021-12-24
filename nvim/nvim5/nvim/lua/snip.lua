local snippets = require('snippets')

snippets.use_suggested_mappings()

vim.api.nvim_set_keymap('i', '<c-k>', "<cmd>lua return require'snippets'.expand_or_advance(1)<CR>", {})
vim.api.nvim_set_keymap('i', '<c-j>', "<cmd>lua return require'snippets'.advance_snippet(-1)<CR>", {})

snippets.snippets = {
  _global = {
    epoch = function() return os.time() end;
  },
  go = {
    gofiber_handler = [[
func (${3:h} ${2}) ${1}(c *fiber.Ctx) error {
  c.Status(http.StatusOK).JSON("")
}
    ]]
  }
}

local snippets = require('snippets')

snippets.use_suggested_mappings()

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

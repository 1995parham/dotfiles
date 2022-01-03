local fb_actions = require "telescope".extensions.file_browser.actions
require("telescope").setup {
  extensions = {
    file_browser = {
      theme = "ivy",
      mappings = {
        ["n"] = {
          ["ma"] = fb_actions.create_file,
          ["mm"] = fb_actions.move_file,
          ["mr"] = fb_actions.rename_file,
        },
      },
    },
  },
}

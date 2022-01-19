local fb_actions = require "telescope".extensions.file_browser.actions
require("telescope").setup {
  extensions = {
    file_browser = {
      theme = "ivy",
      mappings = {
        ["n"] = {
          ["ma"] = fb_actions.create,
          ["mm"] = fb_actions.move,
          ["mr"] = fb_actions.rename,
          ["my"] = fb_actions.copy,
          ["mh"] = fb_actions.toggle_hidden,
        },
      },
    },
  },
}

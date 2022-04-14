require('neorg').setup {
  load = {
    ["core.defaults"] = {},
    ["core.norg.concealer"] = {},
    ["core.gtd.base"] = {
      config = {
        workspace = "tasks"
      }
    },
    ["core.gtd.ui"] = {},
    ["core.gtd.helpers"] = {}
    ["core.norg.dirman"] = {
      config = {
        workspaces = {
          tasks = "~/tasks/neorg",
        }
      }
    }
  }
}

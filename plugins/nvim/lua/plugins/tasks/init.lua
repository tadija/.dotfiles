local core = require("plugins.tasks.core")

return {
  {
    "LazyVim/LazyVim",
    optional = true,
    init = core.setup,
  },
}

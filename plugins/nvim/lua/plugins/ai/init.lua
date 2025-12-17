return {
  {
    "olimorris/codecompanion.nvim",
    version = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "ravitemer/mcphub.nvim",
    },
    config = function(_, opts) require("codecompanion").setup(opts) end,
    opts = require("plugins.ai.opts"),
    init = function() require("plugins.ai.utils").setup_request_logging() end,
  },
}

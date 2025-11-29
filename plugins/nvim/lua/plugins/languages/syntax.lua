-- lua/plugins/languages/syntax.lua
-- Treesitter, formatters, linters, Mason tooling, and related plugin specs.

local M = {}

-- Treesitter -----------------------------------------------------------------
M.ensure_installed = {
  "astro",
  "bash",
  "c",
  "c_sharp",
  "cpp",
  "css",
  "dockerfile",
  "elixir",
  "fortran",
  "fsharp",
  "gitignore",
  "go",
  "graphql",
  "haskell",
  "html",
  "ini",
  "java",
  "javascript",
  "json",
  "kotlin",
  "lua",
  "make",
  "markdown",
  "markdown_inline",
  "objc",
  "objcpp",
  "perl",
  "php",
  "proto",
  "python",
  "query",
  "regex",
  "ruby",
  "rust",
  "scala",
  "scss",
  "sql",
  "swift",
  "toml",
  "tsx",
  "typescript",
  "vfp",
  "vim",
  "vimdoc",
  "vue",
  "xml",
  "yaml",
  "zig",
}

-- Formatters -----------------------------------------------------------------
M.formatters_by_ft = {
  astro = { "prettierd", "prettier" },
  bash = { "shfmt" },
  cs = { "csharpier" },
  css = { "prettierd", "prettier", "stylelint" },
  fsharp = { "fantomas" },
  go = { "gofumpt", "goimports" },
  haskell = { "ormolu" },
  html = { "prettierd", "prettier" },
  java = { "google-java-format" },
  javascript = { "prettierd", "prettier" },
  json = { "prettierd", "prettier", "jq" },
  kotlin = { "ktlint" },
  lua = { "stylua" },
  markdown = { "prettierd", "prettier" },
  php = { "php-cs-fixer" },
  python = { "black" },
  ruby = { "rubocop" },
  rust = { "rustfmt" },
  sql = { "sqlfluff", "sqlfmt" },
  -- swift = { "swiftformat" },
  toml = { "taplo" },
  typescript = { "prettierd", "prettier" },
  vue = { "prettierd", "prettier" },
  xml = { "xmlformatter" },
  yaml = { "prettierd", "prettier" },
}

-- Linters --------------------------------------------------------------------
M.linters_by_ft = {
  astro = { "eslint_d", "eslint" },
  bash = { "shellcheck" },
  css = { "stylelint" },
  fortran = { "fortls" },
  go = { "golangci-lint" },
  haskell = { "hlint" },
  html = { "eslint_d", "eslint" },
  java = { "checkstyle" },
  javascript = { "eslint_d", "eslint" },
  json = { "jsonlint" },
  kotlin = { "ktlint" },
  lua = { "luacheck" },
  markdown = { "markdownlint" },
  php = { "phpstan" },
  python = { "flake8" },
  ruby = { "rubocop" },
  sql = { "sqlfluff" },
  swift = { "swiftlint" },
  typescript = { "eslint_d", "eslint" },
  vue = { "eslint_d", "eslint" },
  yaml = { "yamllint" },
}

-- Mason packages --------------------------------------------------------------
local function collect_tools(map, add)
  for _, tools in pairs(map) do
    for _, tool in ipairs(tools) do
      add(tool)
    end
  end
end

local mason_extra = {
  "astro-language-server",
  "bash-language-server",
  "clangd",
  "css-lsp",
  "elixir-ls",
  "eslint-lsp",
  "fortls",
  "fsautocomplete",
  "gopls",
  "html-lsp",
  "intelephense",
  "jdtls",
  "json-lsp",
  "kotlin-language-server",
  "lemminx",
  "lua-language-server",
  "marksman",
  "omnisharp",
  "perlnavigator",
  "pyright",
  "rust-analyzer",
  "solargraph",
  -- "sourcekit",
  "sqls",
  "tailwindcss-language-server",
  "taplo",
  "typescript-language-server",
  "vue-language-server",
  "yaml-language-server",
  "zls",
}

M.mason_packages = {}
do
  local added = {}
  local function add(tool)
    if tool and not added[tool] then
      table.insert(M.mason_packages, tool)
      added[tool] = true
    end
  end

  for _, pkg in ipairs(mason_extra) do
    add(pkg)
  end

  collect_tools(M.formatters_by_ft, add)
  collect_tools(M.linters_by_ft, add)

  table.sort(M.mason_packages)
end

-- Plugin specs ---------------------------------------------------------------
function M.get_specs()
  return {
    -- conform.nvim
    {
      "stevearc/conform.nvim",
      version = false,
      event = "BufWritePre",
      opts = function(_, opts)
        opts.formatters_by_ft = vim.tbl_extend("force", opts.formatters_by_ft or {}, M.formatters_by_ft)
        return opts
      end,
    },

    -- nvim-lint
    {
      "mfussenegger/nvim-lint",
      version = false,
      event = "BufWritePost",
      opts = function(_, opts)
        opts.linters_by_ft = vim.tbl_extend("force", opts.linters_by_ft or {}, M.linters_by_ft)
        return opts
      end,
    },

    -- mason-tool-installer
    {
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      opts = function(_, opts)
        opts.ensure_installed = opts.ensure_installed or {}
        vim.list_extend(opts.ensure_installed, M.mason_packages)
        return opts
      end,
    },

    -- nvim-treesitter
    {
      "nvim-treesitter/nvim-treesitter",
      version = false,
      build = ":TSUpdate",
      opts = function(_, opts)
        opts.ensure_installed = opts.ensure_installed or {}
        vim.list_extend(opts.ensure_installed, M.ensure_installed)
        opts.highlight = { enable = true }
        opts.indent = { enable = true }
        opts.incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
          },
        }
        return opts
      end,
    },
  }
end

return M

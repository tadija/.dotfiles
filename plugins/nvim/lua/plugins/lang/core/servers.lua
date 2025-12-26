-- lua/plugins/lang/core/servers.lua
-- Language server configurations shared with nvim-lspconfig.

local util = require("lspconfig.util")

local M = {

  -- Bash / Shell
  bashls = {
    cmd = { "bash-language-server", "start" },
    filetypes = { "sh", "bash", "zsh" },
    root_dir = vim.fs.dirname(vim.fs.find(".git", { path = startpath, upward = true })[1]),
  },

  -- C / C++
  clangd = {
    cmd = { "clangd" },
    filetypes = { "c", "cpp", "objc", "objcpp" },
    root_dir = util.root_pattern("compile_commands.json", ".git"),
  },

  -- C# / .NET
  omnisharp = {
    cmd = { "OmniSharp" },
    root_dir = util.root_pattern("*.sln", "*.csproj", ".git"),
    enable_roslyn_analyzers = true,
    enable_import_completion = true,
    settings = {
      FormattingOptions = {
        EnableEditorConfigSupport = true,
        OrganizeImports = true,
      },
    },
  },

  -- Elixir
  elixirls = {},

  -- Fortran
  fortls = {},

  -- F#
  fsautocomplete = {},

  -- Go
  gopls = {},

  -- Java
  jdtls = {},

  -- Kotlin
  kotlin_language_server = {},

  -- Lua
  lua_ls = {
    settings = {
      Lua = {
        diagnostics = { globals = { "vim" } },
        workspace = { checkThirdParty = false },
        library = { vim.env.VIMRUNTIME },
      },
    },
  },

  -- Perl
  perlnavigator = {},

  -- PHP
  intelephense = {},

  -- Python
  pyright = {},

  -- Ruby
  solargraph = {},

  -- Rust
  rust_analyzer = {
    cmd = { "rust-analyzer" },
    root_dir = util.root_pattern("Cargo.toml", "rust-project.json", ".git"),
  },

  -- Scala
  metals = {},

  -- SQL
  sqls = {
    filetypes = { "sql", "mysql", "pgsql" },
    root_dir = util.root_pattern("schema.sql", "migrations", ".git"),
  },

  -- Swift / Objective-C
  sourcekit = {
    cmd = { "sourcekit-lsp" },
    filetypes = { "swift", "objective-c", "objective-cpp" },
    root_dir = util.root_pattern("Package.swift", "*.xcodeproj", ".git"),
  },

  -- Zig
  zls = {},

  -- JavaScript / TypeScript / React / React Native / Next.js / Vue
  ts_ls = {
    filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
    root_dir = util.root_pattern("package.json", "tsconfig.json", ".git"),
    init_options = {
      plugins = {
        {
          name = "@vue/typescript-plugin",
          location = vim.fn.stdpath("data") .. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
          languages = { "vue" },
        },
      },
    },
  },
  eslint = {},
  tailwindcss = {},

  -- Astro
  astro = {
    cmd = { "astro-ls", "--stdio" },
    filetypes = { "astro" },
    root_dir = util.root_pattern("astro.config.*", "package.json", ".git"),
  },

  -- Vue
  volar = {
    filetypes = { "vue" },
    root_dir = util.root_pattern("package.json", "tsconfig.json", ".git"),
    init_options = {
      vue = { hybridMode = false },
    },
  },

  vue_ls = false,

  -- HTML / CSS / JSON / Markdown / TOML / XML / YAML
  html = {},
  cssls = {},
  jsonls = {},
  lemminx = {},
  marksman = {},
  taplo = {},
  yamlls = {},
}

return M

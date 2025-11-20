-- lua/plugins/languages.lua
-- Treesitter, Formatters, Linters, Servers, Build, Test, Tasks, Plugins

local util = require("lspconfig.util")

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
  elixir = { "mix_format" },
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
  perl = { "perltidy" },
  php = { "php_cs_fixer" },
  python = { "black" },
  ruby = { "rubocop" },
  rust = { "rustfmt" },
  scala = { "scalafmt" },
  sql = { "sqlfluff", "sqlfmt" },
  swift = { "swiftformat" },
  toml = { "taplo" },
  typescript = { "prettierd", "prettier" },
  vue = { "prettierd", "prettier" },
  xml = { "xmllint" },
  yaml = { "prettierd", "prettier" },
  zig = { "zigfmt" },
}

-- Linters --------------------------------------------------------------------
M.linters_by_ft = {
  astro = { "eslint_d", "eslint" },
  bash = { "shellcheck" },
  css = { "stylelint" },
  elixir = { "credo" },
  fortran = { "fortls" },
  go = { "golangci_lint" },
  haskell = { "hlint" },
  html = { "eslint_d", "eslint" },
  java = { "checkstyle" },
  javascript = { "eslint_d", "eslint" },
  json = { "jsonlint" },
  kotlin = { "ktlint" },
  lua = { "luacheck" },
  markdown = { "markdownlint" },
  perl = { "perl" },
  php = { "phpstan" },
  python = { "flake8" },
  ruby = { "rubocop" },
  rust = { "clippy" },
  scala = { "scalac" },
  sql = { "sqlfluff" },
  swift = { "swiftlint" },
  toml = { "taplo" },
  typescript = { "eslint_d", "eslint" },
  vue = { "eslint_d", "eslint" },
  xml = { "xmllint" },
  yaml = { "yamllint" },
  zig = { "zig" },
}

-- Servers ----------------------------------------------------------------
M.servers = {

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
    cmd = { "omnisharp" },
    root_dir = util.root_pattern("*.sln", "*.csproj", ".git"),
    enable_roslyn_analyzers = true,
    organize_imports_on_format = true,
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

  -- HTML / CSS / JSON / Markdown / TOML / YAML
  html = {},
  cssls = {},
  jsonls = {},
  marksman = {},
  taplo = {},
  yamlls = {},

  -- XML
  lemminx = {
    filetypes = { "xml", "xsd", "xsl", "xslt", "svg" },
    root_dir = util.root_pattern("*.xml", "*.svg", ".git"),
    settings = {
      xml = {
        format = {
          splitAttributes = true,
          spaceBeforeEmptyCloseTag = true,
        },
      },
    },
  },
}

-- Build / Test helpers -------------------------------------------------------
local function resolve_root(root)
  if root and root ~= "" then
    return root
  end
  local workspaces = vim.lsp.buf.list_workspace_folders()
  if workspaces and workspaces[1] then
    return workspaces[1]
  end
  return vim.loop.cwd()
end

local function is_rails(root)
  root = resolve_root(root)
  return vim.fn.filereadable(root .. "/bin/rails") == 1
end

local function is_laravel(root)
  root = resolve_root(root)
  return vim.fn.filereadable(root .. "/artisan") == 1
end

local function js_helper(root, script)
  root = resolve_root(root)
  if vim.fn.filereadable(root .. "/package.json") == 1 then
    return "npm run " .. script
  elseif vim.fn.filereadable(root .. "/bun.lockb") == 1 then
    return "bun run " .. script
  elseif vim.fn.filereadable(root .. "/yarn.lock") == 1 then
    return "yarn " .. script
  end
end

-- Build command --------------------------------------------------------------
local function build_command(ctx)
  local ft = ctx.ft
  local fname = ctx.fname or ""
  local root = ctx.root

  if ft == "cs" or ft == "fsharp" then
    return "dotnet build"
  elseif ft == "elixir" then
    return "mix compile"
  elseif ft == "fortran" then
    return "gfortran " .. fname .. " -o out"
  elseif ft == "haskell" then
    return "stack build"
  elseif ft == "go" then
    return "go build ./..."
  elseif ft == "java" then
    return "javac " .. fname
  elseif ft == "javascript" or ft == "typescript" or ft == "astro" or ft == "vue" then
    return js_helper(root, "build")
  elseif ft == "kotlin" then
    return "kotlinc " .. fname .. " -d out.jar"
  elseif ft == "lua" then
    return "luacheck " .. fname
  elseif ft == "perl" then
    return "perl -c " .. fname
  elseif ft == "php" then
    if is_laravel(root) then
      return "php artisan test"
    end
    return "php -l " .. fname
  elseif ft == "python" then
    return "python3 -m py_compile " .. fname
  elseif ft == "ruby" then
    if is_rails(root) then
      return "bin/rails test"
    end
    return "ruby -c " .. fname
  elseif ft == "rust" then
    return "cargo build"
  elseif ft == "scala" then
    return "sbt compile"
  elseif ft == "sql" then
    return "sqlfluff lint --dialect tsql ."
  elseif ft == "swift" then
    if vim.fn.filereadable(root .. "/Package.swift") == 1 then
      return "swift build"
    elseif vim.fn.glob(root .. "/*.xcodeproj") ~= "" then
      return "xcodebuild -quiet"
    end
  elseif ft == "zig" then
    return "zig build"
  end
end

-- Test command ---------------------------------------------------------------
local function test_command(ctx)
  local ft = ctx.ft
  local fname = ctx.fname or ""
  local root = ctx.root

  if ft == "cs" or ft == "fsharp" then
    return "dotnet test"
  elseif ft == "elixir" then
    return "mix test"
  elseif ft == "fortran" then
    return "echo 'No standard test runner'"
  elseif ft == "haskell" then
    return "stack test"
  elseif ft == "go" then
    return "go test ./..."
  elseif ft == "java" then
    return "java " .. vim.fn.fnamemodify(fname, ":t:r")
  elseif ft == "javascript" or ft == "typescript" or ft == "astro" or ft == "vue" then
    return js_helper(root, "test")
  elseif ft == "kotlin" then
    return "kotlinc -script " .. fname
  elseif ft == "lua" then
    return "busted --filter " .. vim.fn.fnamemodify(fname, ":t:r")
  elseif ft == "perl" then
    return "prove --verbose"
  elseif ft == "php" then
    if is_laravel(root) then
      return "php artisan test"
    end
    return vim.fn.executable("phpunit") == 1 and "phpunit"
  elseif ft == "python" then
    return vim.fn.executable("pytest") == 1 and "pytest" or "python3 -m unittest"
  elseif ft == "ruby" then
    if is_rails(root) then
      return "bin/rails test"
    elseif vim.fn.filereadable(root .. "/Gemfile") == 1 then
      return "bundle exec rspec"
    elseif vim.fn.executable("rspec") == 1 then
      return "rspec"
    end
  elseif ft == "rust" then
    return "cargo test"
  elseif ft == "scala" then
    return "sbt test"
  elseif ft == "sql" then
    return "sqlfluff lint --dialect tsql ."
  elseif ft == "swift" then
    if vim.fn.filereadable(root .. "/Package.swift") == 1 then
      return "swift test"
    elseif vim.fn.glob(root .. "/*.xcodeproj") ~= "" then
      return "xcodebuild test -quiet"
    end
  elseif ft == "zig" then
    return "zig build test"
  end
end

-- Task Runner ----------------------------------------------------------------
local Task = {
  BUILD = "build",
  TEST = "test",
  LINT = "lint",
  FORMAT = "format",
}

local function elapsed(start)
  return string.format("%.2fs", (vim.loop.hrtime() - start) / 1e9)
end

local function notify_ok(task, duration)
  vim.notify(("✅ %s completed in %s"):format(task, duration), vim.log.levels.INFO)
end

local function notify_fail(task, msg)
  vim.notify(("❌ %s failed: %s"):format(task, msg or "unknown error"), vim.log.levels.ERROR)
end

local function buffer_name()
  local name = vim.api.nvim_buf_get_name(0)
  if name == "" then
    name = vim.fn.expand("%:p")
  end
  return name or ""
end

local function current_context(ft, fname, root)
  return {
    ft = ft or vim.bo.filetype,
    fname = fname or buffer_name(),
    root = resolve_root(root),
  }
end

local function run_task(kind)
  local start = vim.loop.hrtime()
  local ok, err = pcall(function()
    if kind == Task.LINT then
      require("lint").try_lint()
    elseif kind == Task.FORMAT then
      require("conform").format({ async = false, lsp_fallback = true })
    elseif kind == Task.BUILD then
      build_command(current_context())
    elseif kind == Task.TEST then
      test_command(current_context())
    end
  end)
  local duration = elapsed(start)
  if ok then
    notify_ok(kind, duration)
  else
    notify_fail(kind, err)
  end
end

local function register_task_commands()
  if M._tasks_registered then
    return
  end

  vim.api.nvim_create_user_command("LangTaskLint", function()
    run_task(Task.LINT)
  end, {})
  vim.api.nvim_create_user_command("LangTaskFormat", function()
    run_task(Task.FORMAT)
  end, {})
  vim.api.nvim_create_user_command("LangTaskBuild", function()
    run_task(Task.BUILD)
  end, {})
  vim.api.nvim_create_user_command("LangTaskTest", function()
    run_task(Task.TEST)
  end, {})

  M._tasks_registered = true
end

-- Plugin Registration --------------------------------------------------------
register_task_commands()

return {
  -- conform.nvim
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = function(_, opts)
      opts.formatters_by_ft = vim.tbl_extend("force", opts.formatters_by_ft or {}, M.formatters_by_ft)
      return opts
    end,
  },

  -- nvim-lint
  {
    "mfussenegger/nvim-lint",
    event = { "BufWritePost", "InsertLeave" },
    opts = function(_, opts)
      opts.linters_by_ft = vim.tbl_extend("force", opts.linters_by_ft or {}, M.linters_by_ft)
      return opts
    end,
  },

  -- nvim-lspconfig
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      for s, c in pairs(M.servers) do
        opts.servers[s] = c
      end
      opts.setup = {
        ["*"] = function(server, opts)
          local lsp = require("config.lsp")
          opts.on_attach = function(client, bufnr)
            lsp.on_attach(client, bufnr)
            if client.server_capabilities.inlayHintProvider then
              vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
            end
          end
          opts.capabilities = lsp.capabilities
          require("lspconfig")[server].setup(opts)
        end,
      }
      return opts
    end,
  },

  -- nvim-treesitter
  {
    "nvim-treesitter/nvim-treesitter",
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

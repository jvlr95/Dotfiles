-- ============================================================
-- BOOTSTRAP lazy.nvim
-- ============================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader      = " "
vim.g.maplocalleader = " "

-- ============================================================
-- PLUGINS
-- ============================================================
require("lazy").setup({

  -- Theme
  { "sainnhe/sonokai" },

  -- Icons (required by many plugins)
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- Treesitter (syntax highlight moderno)
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter").setup({
        ensure_install = {
          "lua", "vim", "vimdoc", "bash", "json", "yaml",
          "python", "go", "java", "terraform", "hcl",
          "dockerfile", "markdown", "toml", "regex",
        },
        auto_install = true,
      })
      vim.opt.foldmethod = "indent"
      vim.opt.foldlevel  = 99
    end,
  },

  -- File explorer (substitui NERDTree)
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFindFile", "NvimTreeFocus" },
    config = function()
      require("nvim-tree").setup({
        view = { width = 30 },
        renderer = {
          group_empty = true,
          icons = { show = { git = true, folder = true, file = true } },
        },
        filters = {
          dotfiles = true,
          custom = {
            "\\.git", "\\.svn", "\\.hg", "\\.DS_Store",
            "__pycache__", "\\.terraform", "\\.pyc",
            "\\.terragrunt-cache",
          },
        },
        git = { enable = true, ignore = false },
        diagnostics = { enable = false },
      })
    end,
  },

  -- Statusline (substitui statusline manual)
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    config = function()
      require("lualine").setup({
        options = {
          theme = "auto",
          globalstatus = true,
          component_separators = { left = "", right = "" },
          section_separators   = { left = "", right = "" },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { { "filename", path = 1 } },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end,
  },

  -- Bufferline (abas de buffer como LunarVim)
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    config = function()
      require("bufferline").setup({
        options = {
          numbers = "none",
          diagnostics = "nvim_lsp",
          show_buffer_close_icons = true,
          show_close_icon = false,
          separator_style = "thin",
        },
      })
    end,
  },

  -- Telescope (substitui FZF)
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
    keys = {
      { "<C-f>d", "<cmd>Telescope find_files<cr>" },
      { "<C-f>t", "<cmd>Telescope live_grep<cr>" },
      { "<C-f>b", "<cmd>Telescope buffers<cr>" },
      { "<C-f>s", "<cmd>Telescope lsp_document_symbols<cr>" },
    },
    config = function()
      require("telescope").setup({
        defaults = {
          layout_strategy = "horizontal",
          file_ignore_patterns = { ".git/", "__pycache__/", ".terraform/" },
        },
      })
    end,
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls", "jsonls", "yamlls", "bashls",
          "pyright", "dockerls", "terraformls", "gopls", "marksman",
        },
        automatic_enable = true,
      })

      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- API nova (Neovim 0.11+)
      vim.lsp.config("*", { capabilities = capabilities })

      vim.lsp.config("lua_ls", {
        settings = { Lua = { diagnostics = { globals = { "vim" } } } },
      })

      vim.lsp.enable({
        "lua_ls", "jsonls", "yamlls", "bashls",
        "pyright", "dockerls", "gopls", "terraformls", "marksman",
      })
    end,
  },

  -- Completion (substitui CoC)
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local cmp     = require("cmp")
      local luasnip = require("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"]      = cmp.mapping.confirm({ select = true }),
          ["<Tab>"]     = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
            else fallback() end
          end, { "i", "s" }),
          ["<S-Tab>"]   = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then luasnip.jump(-1)
            else fallback() end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },

  -- Formatting (substitui ALE formatters)
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    config = function()
      require("conform").setup({
        format_on_save = { timeout_ms = 500, lsp_fallback = true },
        formatters_by_ft = {
          json      = { "jq" },
          python    = { "isort", "black" },
          sh        = { "shfmt" },
          terraform = { "terraform_fmt" },
          tf        = { "terraform_fmt" },
          hcl       = { "terraform_fmt" },
          lua       = { "stylua" },
          yaml      = { "prettier" },
          yml       = { "prettier" },
        },
      })
    end,
  },

  -- Linting (substitui ALE linters)
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufWritePost" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        sh         = { "shellcheck" },
        python     = { "pylint" },
        dockerfile = { "hadolint" },
        yaml       = { "yamllint" },
        ansible    = { "ansible_lint" },
      }
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost" }, {
        callback = function() lint.try_lint() end,
      })
    end,
  },

  -- Git signs (substitui vim-gitgutter)
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("gitsigns").setup({
        signs = {
          add          = { text = "▎" },
          change       = { text = "▎" },
          delete       = { text = "" },
          topdelete    = { text = "" },
          changedelete = { text = "▎" },
        },
        on_attach = function(bufnr)
          local gs  = package.loaded.gitsigns
          local map = vim.keymap.set
          local o   = { buffer = bufnr, silent = true }
          map("n", "]h", gs.next_hunk, o)
          map("n", "[h", gs.prev_hunk, o)
          map("n", "<leader>hp", gs.preview_hunk, o)
          map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, o)
        end,
      })
    end,
  },

  -- Git (fugitive — mantido)
  { "tpope/vim-fugitive", cmd = { "Git", "Gvdiffsplit", "Gclog" } },

  -- Comments (substitui nerdcommenter)
  {
    "numToStr/Comment.nvim",
    keys = { "gc", "gb", { "gc", mode = "v" }, { "gb", mode = "v" } },
    config = function() require("Comment").setup() end,
  },

  -- Auto pairs (substitui jiangmiao/auto-pairs)
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local autopairs = require("nvim-autopairs")
      autopairs.setup({ check_ts = true })
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },

  -- Indent guides (substitui IndentLine)
  {
    "lukas-reineke/indent-blankline.nvim",
    version = "3.*",
    event = "BufReadPost",
    main = "ibl",
    opts = {
      indent = { char = "│" },
      scope  = { enabled = true },
    },
  },

  -- Which-key (mostra atalhos disponíveis)
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      local wk = require("which-key")
      wk.setup()
      wk.add({
        { "<leader>b", group = "Buffers" },
        { "<leader>g", group = "Git" },
        { "<leader>l", group = "LSP" },
        { "<leader>s", group = "Search" },
      })
    end,
  },

  -- Notifications bonitas
  {
    "rcarriga/nvim-notify",
    lazy = true,
    config = function()
      vim.notify = require("notify")
    end,
  },

  -- Language support
  { "hashivim/vim-terraform",   ft = { "hcl", "terraform", "tf" } },
  { "towolf/vim-helm",          ft = "helm" },
  { "pearofducks/ansible-vim",  ft = "ansible" },
  { "fatih/vim-go",             ft = "go" },
  { "chr4/nginx.vim",           ft = "nginx" },
  { "ekalinin/Dockerfile.vim",  ft = "dockerfile" },
  { "plasticboy/vim-markdown",  ft = { "markdown", "md" } },

  -- Markdown render inline no buffer
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ft = { "markdown", "md" },
    config = function()
      require("render-markdown").setup({
        render_modes = { "n", "c" },
        heading = { enabled = true },
        code = { enabled = true, style = "full" },
        bullet = { enabled = true },
        checkbox = { enabled = true },
        table = { enabled = true },
      })
    end,
  },
  { "andrewstuart/vim-kubernetes", ft = { "yaml", "yml" } },

}, {
  ui = { border = "rounded" },
})

-- ============================================================
-- CLIPBOARD (OSC52 — funciona em SSH + tmux + Wayland/Konsole)
-- ============================================================
vim.g.clipboard = {
  name = "OSC52",
  copy = {
    ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
    ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
  },
  paste = {
    ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
    ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
  },
}

-- ============================================================
-- OPTIONS
-- ============================================================
vim.opt.termguicolors  = true
vim.opt.background     = "dark"
vim.opt.title          = true
vim.opt.encoding       = "utf-8"
vim.opt.mouse          = "a"
vim.opt.clipboard      = "unnamedplus"
vim.opt.hidden         = true
vim.opt.confirm        = true
vim.opt.splitbelow     = true
vim.opt.splitright     = true
vim.opt.path           = { ".", "**" }
vim.opt.swapfile       = false
vim.opt.backup         = false
vim.opt.undofile       = true
vim.opt.undodir        = vim.fn.expand("~/.config/nvim/undodir")

vim.opt.wrap           = false
vim.opt.linebreak      = true
vim.opt.list           = false
vim.opt.listchars      = { tab = "›-", space = "·", trail = "◀", eol = "↲" }

vim.opt.number         = true
vim.opt.relativenumber = true
vim.opt.scrolloff      = 4
vim.opt.cursorline     = true

vim.opt.autoindent     = true
vim.opt.smartindent    = true
vim.opt.expandtab      = true
vim.opt.tabstop        = 4
vim.opt.softtabstop    = 4
vim.opt.shiftwidth     = 4

vim.opt.smartcase      = true
vim.opt.ignorecase     = true
vim.opt.incsearch      = true
vim.opt.hlsearch       = true
vim.opt.completeopt    = { "menu", "menuone", "noselect" }
vim.opt.shortmess:append("c")

vim.opt.spelllang      = { "pt_br", "en" }
vim.opt.spell          = false
vim.opt.showmode       = false
vim.opt.laststatus     = 3

vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20"

vim.opt.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
  pattern = "*",
  command = "checktime",
})

-- ============================================================
-- THEME
-- ============================================================
vim.g.sonokai_style                     = "andromeda"
vim.g.sonokai_enable_italic             = 1
vim.g.sonokai_disable_italic_comment    = 0
vim.g.sonokai_diagnostic_line_highlight = 1
vim.g.sonokai_current_word              = "bold"
vim.cmd("colorscheme sonokai")

vim.cmd([[
  highlight Normal      guibg=NONE ctermbg=NONE
  highlight EndOfBuffer guibg=NONE ctermbg=NONE
]])

-- ============================================================
-- PLUGIN SETTINGS
-- ============================================================

-- Terraform / HCL
vim.g.terraform_align       = 1
vim.g.terraform_fmt_on_save = 1
vim.g.hcl_align             = 1

-- Ansible
vim.g.ansible_unindent_after_newline = 1
vim.g.ansible_attribute_highlight    = "ob"
vim.g.ansible_name_highlight         = "d"

-- Markdown
vim.g.vim_markdown_folding_disabled = 1

-- ============================================================
-- AUTOCMDS
-- ============================================================
local ag = vim.api.nvim_create_augroup
local au = vim.api.nvim_create_autocmd

ag("autosourcing", { clear = true })
au("BufWritePost", { group = "autosourcing", pattern = "init.lua", command = "source %" })

au("FileType", {
  pattern = { "terraform", "tf", "hcl", "helm", "yaml", "yml", "dockerfile", "go", "python", "ansible" },
  callback = function()
    local ft = vim.bo.filetype
    local map = {
      terraform = "# %s", tf = "# %s", hcl = "# %s",
      helm = "# %s", yaml = "# %s", yml = "# %s",
      dockerfile = "# %s", python = "# %s", ansible = "# %s",
      go = "// %s",
    }
    if map[ft] then vim.bo.commentstring = map[ft] end
  end,
})

-- ============================================================
-- KEYMAPS (LunarVim defaults)
-- ============================================================
local map  = vim.keymap.set
local opts = { silent = true }

-- Desabilita Space no modo normal (vira leader)
map("n", "<Space>", "<Nop>", opts)

-- Navegação entre janelas (Ctrl+hjkl)
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Redimensionar janelas
map("n", "<C-Up>",    "<cmd>resize -2<CR>",          opts)
map("n", "<C-Down>",  "<cmd>resize +2<CR>",          opts)
map("n", "<C-Left>",  "<cmd>vertical resize -2<CR>", opts)
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", opts)

-- Navegação entre buffers (Shift+h/l como LunarVim)
map("n", "<S-l>", "<cmd>BufferLineCycleNext<CR>", opts)
map("n", "<S-h>", "<cmd>BufferLineCyclePrev<CR>", opts)

-- Mover linhas no visual mode
map("v", "<A-j>", ":m .+1<CR>==",        opts)
map("v", "<A-k>", ":m .-2<CR>==",        opts)
map("x", "J",     ":move '>+1<CR>gv=gv", opts)
map("x", "K",     ":move '<-2<CR>gv=gv", opts)

-- Manter seleção após indentar
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- Colar sem sobrescrever o register
map("v", "p", '"_dP', opts)

-- Clear search highlight
map("n", "<leader>h", "<cmd>nohlsearch<CR>", opts)

-- Salvar / sair
map("n", "<C-s>", "<cmd>w<CR>", opts)
map("i", "<C-s>", "<Esc><cmd>w<CR>", opts)

-- Terminal
map("n", "<leader>\\", "<cmd>below terminal<CR>", opts)
map("t", "<Esc>",      "<C-\\><C-n>",             opts)

-- File explorer
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>",   opts)
map("n", "<leader>E", "<cmd>NvimTreeFindFile<CR>", opts)

-- Buffer
map("n", "<leader>c",  "<cmd>bdelete<CR>",                         opts)
map("n", "<leader>bf", "<cmd>Telescope buffers<CR>",               opts)
map("n", "<leader>bp", "<cmd>BufferLineCyclePrev<CR>",             opts)
map("n", "<leader>bn", "<cmd>BufferLineCycleNext<CR>",             opts)
map("n", "<leader>bh", "<cmd>BufferLineCloseLeft<CR>",             opts)
map("n", "<leader>bl", "<cmd>BufferLineCloseRight<CR>",            opts)
map("n", "<leader>bc", "<cmd>BufferLinePickClose<CR>",             opts)
map("n", "<leader>bj", "<cmd>BufferLinePick<CR>",                  opts)

-- Search (Telescope) — <leader>s
map("n", "<leader>sf", "<cmd>Telescope find_files<CR>",            opts)
map("n", "<leader>st", "<cmd>Telescope live_grep<CR>",             opts)
map("n", "<leader>sb", "<cmd>Telescope buffers<CR>",               opts)
map("n", "<leader>sh", "<cmd>Telescope help_tags<CR>",             opts)
map("n", "<leader>sk", "<cmd>Telescope keymaps<CR>",               opts)
map("n", "<leader>sr", "<cmd>Telescope oldfiles<CR>",              opts)
map("n", "<leader>sc", "<cmd>Telescope commands<CR>",              opts)
map("n", "<leader>sd", "<cmd>Telescope diagnostics<CR>",           opts)

-- Atalhos rápidos de busca (mantidos)
map("n", "<leader>f",  "<cmd>Telescope find_files<CR>",            opts)
map("n", "<leader>F",  "<cmd>Telescope live_grep<CR>",             opts)

-- LSP — <leader>l
map("n", "<leader>la", vim.lsp.buf.code_action,                    opts)
map("n", "<leader>ld", "<cmd>Telescope diagnostics bufnr=0<CR>",   opts)
map("n", "<leader>lf", function() vim.lsp.buf.format({ async = true }) end, opts)
map("n", "<leader>li", "<cmd>LspInfo<CR>",                         opts)
map("n", "<leader>lj", vim.diagnostic.goto_next,                   opts)
map("n", "<leader>lk", vim.diagnostic.goto_prev,                   opts)
map("n", "<leader>lr", vim.lsp.buf.rename,                         opts)
map("n", "<leader>ls", vim.lsp.buf.signature_help,                 opts)
map("n", "<leader>lS", "<cmd>Telescope lsp_document_symbols<CR>",  opts)

-- LSP navigation (padrão vim/lvim)
map("n", "gd", vim.lsp.buf.definition,      opts)
map("n", "gD", vim.lsp.buf.declaration,     opts)
map("n", "gy", vim.lsp.buf.type_definition, opts)
map("n", "gi", vim.lsp.buf.implementation,  opts)
map("n", "gr", vim.lsp.buf.references,      opts)
map("n", "K",  vim.lsp.buf.hover,           opts)
map("n", "[d", vim.diagnostic.goto_prev,    opts)
map("n", "]d", vim.diagnostic.goto_next,    opts)

-- Git — <leader>g
map("n", "<leader>gg", "<cmd>Git<CR>",                             opts)
map("n", "<leader>gd", "<cmd>Gvdiffsplit<CR>",                     opts)
map("n", "<leader>gl", "<cmd>Gclog<CR>",                           opts)
map("n", "<leader>gj", function() require("gitsigns").next_hunk() end, opts)
map("n", "<leader>gk", function() require("gitsigns").prev_hunk() end, opts)
map("n", "<leader>gp", function() require("gitsigns").preview_hunk() end, opts)
map("n", "<leader>gb", function() require("gitsigns").blame_line({ full = true }) end, opts)
map("n", "<leader>gs", function() require("gitsigns").stage_hunk() end, opts)
map("n", "<leader>gr", function() require("gitsigns").reset_hunk() end, opts)
map("n", "<leader>gu", function() require("gitsigns").undo_stage_hunk() end, opts)
map("n", "]h",         function() require("gitsigns").next_hunk() end, opts)
map("n", "[h",         function() require("gitsigns").prev_hunk() end, opts)

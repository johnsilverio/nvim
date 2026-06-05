-- You can also add or configure plugins by creating files in this `plugins/` folder

---@type LazySpec
return {

  {
    "RRethy/vim-illuminate",
    opts = {
      providers = { "lsp", "regex" },
    },
  },

  -- Flexoki colorscheme (kepano/flexoki port)
  {
    "nuvic/flexoki-nvim",
    name = "flexoki",
    lazy = false,
    priority = 1000,
  },

  -- Cyberdream colorscheme
  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = false,
      italic_comments = true,
      hide_fillchars = false,
      borderless_pickers = true,
      terminal_colors = true,
    },
  },

  -- Tokyo Dark colorscheme (disponível, mas não default)
  {
    "tiagovla/tokyodark.nvim",
    opts = {
      transparent_background = false,
      gamma = 1.00,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        identifiers = { italic = true },
        functions = { italic = true },
        variables = { italic = true },
      },
      terminal_colors = true,
    },
  },

  -- Aerial: desabilita backend treesitter (incompatível com Neovim recente)
  {
    "stevearc/aerial.nvim",
    opts = {
      backends = { "lsp", "markdown", "asciidoc", "man" },
    },
  },

  -- Oxocarbon: tema oficial do nyoom-engineering (IBM Carbon design) — DEFAULT
  {
    "nyoom-engineering/oxocarbon.nvim",
    lazy = false,
    priority = 1000,
    init = function() vim.opt.background = "dark" end,
  },

  -- vim-be-good game plugin for Vim practice
  {
    "ThePrimeagen/vim-be-good",
    cmd = "VimBeGood",
  },

  -- == Examples of Adding Plugins ==

  "andweeb/presence.nvim",
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function()
      require("lsp_signature").setup {
        -- Não abrir a janela flutuante de assinatura automaticamente
        -- (aquele box com "(*values: object, sep: str ...)" ao digitar print().
        floating_window = false,
        -- Sem hint de texto virtual inline também.
        hint_enable = false,
        -- Abra/feche a assinatura manualmente com <C-k> quando precisar.
        toggle_key = "<C-k>",
      }
    end,
  },

  -- == Examples of Overriding Plugins ==

  -- customize dashboard options
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = table.concat({
            "███    ██ ██    ██ ██ ███    ███",
            "████   ██ ██    ██ ██ ████  ████",
            "██ ██  ██ ██    ██ ██ ██ ████ ██",
            "██  ██ ██  ██  ██  ██ ██  ██  ██",
            "██   ████   ████   ██ ██      ██",
          }, "\n"),
        },
      },
    },
  },

  -- You can disable default plugins as follows:
  { "max397574/better-escape.nvim", enabled = false },

  -- You can also easily customize additional setup of plugins that is outside of the plugin's setup call
  {
    "L3MON4D3/LuaSnip",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.luasnip"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom luasnip configuration such as filetype extend or custom snippets
      local luasnip = require "luasnip"
      luasnip.filetype_extend("javascript", { "javascriptreact" })
    end,
  },

  {
    "windwp/nvim-autopairs",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.nvim-autopairs"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom autopairs configuration such as custom rules
      local npairs = require "nvim-autopairs"
      local Rule = require "nvim-autopairs.rule"
      local cond = require "nvim-autopairs.conds"
      npairs.add_rules(
        {
          Rule("$", "$", { "tex", "latex" })
            -- don't add a pair if the next character is %
            :with_pair(cond.not_after_regex "%%")
            -- don't add a pair if  the previous character is xxx
            :with_pair(
              cond.not_before_regex("xxx", 3)
            )
            -- don't move right when repeat character
            :with_move(cond.none())
            -- don't delete if the next character is xx
            :with_del(cond.not_after_regex "xx")
            -- disable adding a newline when you press <cr>
            :with_cr(cond.none()),
        },
        -- disable for .vim files, but it work for another filetypes
        Rule("a", "a", "-vim")
      )
    end,
  },
}

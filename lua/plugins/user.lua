-- You can also add or configure plugins by creating files in this `plugins/` folder

---@type LazySpec
return {

  -- Cyberdream colorscheme with transparency
  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true,
      italic_comments = true,
      hide_fillchars = false,
      borderless_pickers = true,
      terminal_colors = true,
    },
  },

  -- Tokyo Dark colorscheme totalmente transparente
  {
    "tiagovla/tokyodark.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      transparent_background = true,
      gamma = 1.00,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        identifiers = { italic = true },
        functions = { italic = true },
        variables = { italic = true },
      },
      terminal_colors = true,
      custom_highlights = function(highlights, palette)
        local transparent = { bg = "NONE" }
        local subtle_split = { fg = "#222222", bg = "NONE" }
        return {
          -- principais
          Normal = transparent,
          NormalNC = transparent,
          SignColumn = transparent,
          LineNr = transparent,
          CursorLine = transparent,
          CursorLineNr = transparent,
          LineNrAbove = transparent,
          LineNrBelow = transparent,
          FoldColumn = transparent,
          EndOfBuffer = transparent,
          StatusLine = transparent,
          StatusLineNC = transparent,
          WinBar = transparent,
          WinBarNC = transparent,
          TabLine = transparent,
          TabLineFill = transparent,
          TabLineSel = transparent,
          -- divisórias
          WinSeparator = subtle_split,
          VertSplit = subtle_split,
          Separator = subtle_split,
          -- Neo-tree
          NeoTreeNormal = transparent,
          NeoTreeNormalNC = transparent,
          NeoTreeWinSeparator = subtle_split,
          NeoTreeVertSplit = subtle_split,
          NeoTreeFloatBorder = subtle_split,
          NeoTreeEndOfBuffer = transparent,
          -- Nvim-tree
          NvimTreeNormal = transparent,
          NvimTreeWinSeparator = subtle_split,
          -- Bufferline
          BufferLineSeparator = subtle_split,
          BufferLineFill = transparent,
          BufferLine = transparent,
          -- Float/Popup
          NormalFloat = transparent,
          FloatBorder = subtle_split,
          -- Terminal
          TermNormal = transparent,
          TermNormalNC = transparent,
          TermCursor = transparent,
        }
      end,
    },
    config = function(_, opts)
      require("tokyodark").setup(opts)
      vim.cmd [[colorscheme tokyodark]]
      local function set_transparent_separators()
        local subtle_split = { fg = "#222222", bg = "NONE" }
        local transparent = { bg = "NONE" }
        local groups_split = {
          "WinSeparator", "VertSplit", "Separator",
          "NeoTreeWinSeparator", "NeoTreeVertSplit", "NeoTreeFloatBorder",
          "NvimTreeWinSeparator", "BufferLineSeparator", "FloatBorder"
        }
        for _, group in ipairs(groups_split) do
          vim.api.nvim_set_hl(0, group, subtle_split)
        end
        local groups_transparent = {
          "Normal", "NormalNC", "SignColumn", "LineNr", "CursorLine", "CursorLineNr", "LineNrAbove", "LineNrBelow", "FoldColumn", "EndOfBuffer", "StatusLine", "StatusLineNC", "WinBar", "WinBarNC", "TabLine", "TabLineFill", "TabLineSel", "NeoTreeNormal", "NeoTreeNormalNC", "NeoTreeEndOfBuffer", "NvimTreeNormal", "BufferLineFill", "BufferLine", "NormalFloat", "TermNormal", "TermNormalNC", "TermCursor"
        }
        for _, group in ipairs(groups_transparent) do
          vim.api.nvim_set_hl(0, group, transparent)
        end
      end
      set_transparent_separators()
      vim.api.nvim_create_autocmd({ "ColorScheme", "WinNew", "BufWinEnter", "VimResized", "User" }, {
        pattern = { "*", "Neotree*" },
        callback = set_transparent_separators,
        desc = "Força divisórias transparentes após eventos de janela/tema",
      })
      -- Cursor em bloco branco no normal, piscando no insert
      vim.opt.guicursor = "n-v-c:block-Cursor,i-ci-ve:blinkwait700-blinkon400-blinkoff250-block-Cursor"
      -- Remova qualquer highlight manual do grupo Cursor/lCursor
      -- Se estiver usando Neovide ou Goneovim, pode definir highlight:
      if vim.g.neovide or vim.g.goneovim then
        vim.api.nvim_set_hl(0, "Cursor", { bg = "#ffffff", fg = "#222222" })
      end
    end,
  },

  -- Oxocarbon colorscheme (dark, modern aesthetic similar to nyoom)
  {
    "nyoom-engineering/oxocarbon.nvim",
    priority = 1000,
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
    config = function() require("lsp_signature").setup() end,
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

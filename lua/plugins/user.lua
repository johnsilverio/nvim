-- You can also add or configure plugins by creating files in this `plugins/` folder

---@type LazySpec
return {

  -- vim-illuminate desativado: no Neovim 0.12 ele não acompanha mais a API LSP
  -- (faz a própria requisição via buf_request_all + str_byteindx, que mudaram/
  -- têm typo) e caía sempre no fallback regex, realçando só texto repetido, sem
  -- semântica. O realce de ocorrências agora vem do document highlight NATIVO
  -- do LSP, ligado no polish.lua (LspAttach + CursorHold/CursorMoved) — o mesmo
  -- mecanismo do Helix, que funciona no 0.12 sem depender deste plugin.
  { "RRethy/vim-illuminate", enabled = false },

  -- Flexoki colorscheme (kepano/flexoki port) — DEFAULT
  {
    "nuvic/flexoki-nvim",
    name = "flexoki",
    lazy = false,
    priority = 1000,
    init = function() vim.opt.background = "dark" end,
    opts = {
      variant = "auto", -- segue vim.o.background: dark=moon, light=dawn (toggle <Leader>ub)
      -- O port herda do rose-pine e deixa surface/_nc com tom roxo, que não é
      -- Flexoki (paleta neutra/sépia). Realinha pros tons base do tema (só o
      -- dark precisa: o dawn já é neutro).
      palette = {
        moon = {
          surface = "#1c1b1a", -- base-950, usado em floats/pmenu
          _nc = "#1c1b1a",
        },
      },
    },
  },

  -- Kanagawa (pro Kanagawa Dragon na galeria)
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
  },

  -- lush: motor de colorscheme exigido pelo zenbones.
  { "rktjmp/lush.nvim", lazy = true },

  -- Temas extras da galeria (colorschemes lua e vimscript). Cada um vira uma
  -- entrada no themery abaixo e, no tmux, um themes/<nome>.conf.
  { "zenbones-theme/zenbones.nvim", dependencies = "rktjmp/lush.nvim", lazy = false, priority = 1000 },
  { "morhetz/gruvbox", lazy = false, priority = 1000 },
  { "tahayvr/matteblack.nvim", lazy = false, priority = 1000 },
  { "wesgibbs/vim-irblack", lazy = false, priority = 1000 },
  { "vim-scripts/Relaxed-Green", lazy = false, priority = 1000 },
  { "deparr/tairiki.nvim", lazy = false, priority = 1000 },
  { "vague-theme/vague.nvim", lazy = false, priority = 1000 },
  { "djjcast/mirodark", lazy = false, priority = 1000 },
  { "jacekd/vim-iawriter", lazy = false, priority = 1000 },
  { "bluz71/vim-moonfly-colors", lazy = false, priority = 1000 },
  { "andbar-ru/vim-unicon", lazy = false, priority = 1000 },
  { "sainnhe/gruvbox-material", lazy = false, priority = 1000 },

  -- Themery: galeria de temas com preview ao vivo + persistência. Abre com
  -- <Leader>ft (remapeado em heirline.lua, sobre o "Find themes" nativo).
  -- A escolha persiste sozinha entre sessões. As particularidades (cursor,
  -- statusline sólida, transparência só no dark) valem pra qualquer tema da
  -- lista, pois vêm do highlights.init (astroui.lua) e do polish.lua.
  -- Pra adicionar um tema novo: declare o plugin do colorscheme e acrescente
  -- uma linha { name = "...", colorscheme = "..." } na lista abaixo.
  {
    "zaldih/themery.nvim",
    lazy = false,
    config = function()
      require("themery").setup {
        themes = {
          { name = "Flexoki Dark", colorscheme = "flexoki" },
          { name = "Oxocarbon", colorscheme = "oxocarbon" },
          { name = "Kanagawa Dragon", colorscheme = "kanagawa-dragon" },
          { name = "Cyberdream", colorscheme = "cyberdream" },
          { name = "Tokyo Dark", colorscheme = "tokyodark" },
          { name = "Zenbones", colorscheme = "zenbones" },
          { name = "Gruvbox", colorscheme = "gruvbox" },
          { name = "Matte Black", colorscheme = "matteblack" },
          { name = "IR Black", colorscheme = "ir_black" },
          { name = "Relaxed Green", colorscheme = "relaxedgreen" },
          { name = "Tairiki Dark", colorscheme = "tairiki-dark" },
          { name = "Vague", colorscheme = "vague" },
          { name = "Mirodark", colorscheme = "mirodark" },
          { name = "iA Writer", colorscheme = "iawriter" },
          { name = "Moonfly", colorscheme = "moonfly" },
          { name = "Unicon", colorscheme = "unicon" },
          { name = "Gruvbox Material", colorscheme = "gruvbox-material" },
        },
        livePreview = true,
      }
    end,
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

  -- Oxocarbon: tema do nyoom-engineering (IBM Carbon design) — alternativa
  {
    "nyoom-engineering/oxocarbon.nvim",
    lazy = false,
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

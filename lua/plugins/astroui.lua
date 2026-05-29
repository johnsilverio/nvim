-- Configuração da interface de usuário (UI)
-- Recomendado instalar o Lua Language Server para autocomplete e documentação.

---@type LazySpec
return {
  "AstroNvim/astroui",
  ---@type AstroUIOpts
  opts = {
    -- Tema do nyoom-engineering (IBM Carbon design)
    colorscheme = "oxocarbon",
    status = {
      attributes = {
        mode = { bold = true },
      },
      icon_highlights = {
        file_icon = {
          statusline = false,
        },
      },
      separators = {
        -- separadores arredondados/suaves para um visual mais clean
        left = { "", " " },
        right = { " ", "" },
      },
    },
    highlights = {
      init = {},
      -- Polimento "clean" em cima da paleta do oxocarbon.
      -- As cores são derivadas dos grupos já carregados pelo tema,
      -- então acompanham a paleta sem hex chumbado.
      oxocarbon = function()
        local function hl(name) return vim.api.nvim_get_hl(0, { name = name, link = false }) end
        local function hex(v) return v and ("#%06x"):format(v) or nil end

        local normal = hl "Normal"
        local bg = hex(normal.bg) or "#161616"
        local fg = hex(normal.fg) or "#dde1e6"
        local base01 = hex(hl("CursorLine").bg) or "#262626" -- realce sutil de fundo
        local base02 = hex(hl("Visual").bg) or "#393939" -- bordas / seleção
        local base03 = hex(hl("LineNr").fg) or "#525252" -- comentários / texto apagado

        -- acentos da paleta oxocarbon
        local blue = "#78a9ff"
        local cyan = "#3ddbd9"
        local pink = "#ee5396"
        local green = "#42be65"
        local purple = "#be95ff"

        return {
          -- Janelas flutuantes sem fundo destoante; borda fina e discreta
          NormalFloat = { fg = fg, bg = bg },
          FloatBorder = { fg = base02, bg = bg },
          FloatTitle = { fg = blue, bg = bg, bold = true },

          -- Separadores de janela bem sutis
          WinSeparator = { fg = base02, bg = bg },
          VertSplit = { fg = base02, bg = bg },

          -- Números de linha e cursor
          CursorLineNr = { fg = blue, bold = true },
          LineNr = { fg = base03, bg = bg },

          -- Comentários em itálico, discretos
          Comment = { fg = base03, italic = true },

          -- Menu de autocomplete
          Pmenu = { fg = fg, bg = base01 },
          PmenuSel = { fg = fg, bg = base02, bold = true },
          PmenuSbar = { bg = base01 },
          PmenuThumb = { bg = base02 },

          -- Telescope com visual em dois tons (clean)
          TelescopeNormal = { fg = fg, bg = bg },
          TelescopeBorder = { fg = base02, bg = bg },
          TelescopePromptNormal = { fg = fg, bg = base01 },
          TelescopePromptBorder = { fg = base01, bg = base01 },
          TelescopePromptTitle = { fg = bg, bg = pink, bold = true },
          TelescopePromptPrefix = { fg = pink, bg = base01 },
          TelescopeResultsNormal = { fg = fg, bg = bg },
          TelescopeResultsBorder = { fg = bg, bg = bg },
          TelescopeResultsTitle = { fg = bg, bg = blue, bold = true },
          TelescopePreviewNormal = { fg = fg, bg = bg },
          TelescopePreviewBorder = { fg = bg, bg = bg },
          TelescopePreviewTitle = { fg = bg, bg = green, bold = true },
          TelescopeSelection = { bg = base02, bold = true },
          TelescopeMatching = { fg = cyan, bold = true },

          -- Palavras realçadas pelo vim-illuminate (bem sutil)
          IlluminatedWordText = { bg = base01 },
          IlluminatedWordRead = { bg = base01 },
          IlluminatedWordWrite = { bg = base01 },

          -- Realces de busca e parênteses
          Search = { fg = bg, bg = purple },
          IncSearch = { fg = bg, bg = pink },
          MatchParen = { fg = cyan, bold = true, underline = true },
        }
      end,
    },
    icons = {
      LSPLoading1 = "⠋",
      LSPLoading2 = "⠙",
      LSPLoading3 = "⠹",
      LSPLoading4 = "⠸",
      LSPLoading5 = "⠼",
      LSPLoading6 = "⠴",
      LSPLoading7 = "⠦",
      LSPLoading8 = "⠧",
      LSPLoading9 = "⠇",
      LSPLoading10 = "⠏",
    },
  },
}

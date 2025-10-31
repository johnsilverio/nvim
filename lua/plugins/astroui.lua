-- Configuração da interface de usuário (UI)
-- Recomendado instalar o Lua Language Server para autocomplete e documentação.

---@type LazySpec
return {
  "AstroNvim/astroui",
  ---@type AstroUIOpts
  opts = {
    colorscheme = "cyberdream",
    status = {
      attributes = {
        mode = { bold = true },
      },
      icon_highlights = {
        file_icon = {
          statusline = false,
        },
      },
    },
    highlights = {
      init = {
        Normal = { bg = "NONE" },
        NormalFloat = { bg = "NONE" },
        NormalNC = { bg = "NONE" },
        SignColumn = { bg = "NONE" },
        LineNr = { bg = "NONE" },
        LineNrAbove = { bg = "NONE" },
        LineNrBelow = { bg = "NONE" },
        CursorLineNr = { bg = "NONE" },
        NeoTreeNormal = { bg = "NONE" },
        NeoTreeNormalNC = { bg = "NONE" },
        NeoTreeEndOfBuffer = { bg = "NONE" },
        NeoTreeVertSplit = { bg = "NONE", fg = "NONE" },
        NeoTreeWinSeparator = { bg = "NONE", fg = "NONE" },
        VertSplit = { bg = "NONE", fg = "NONE" },
        WinSeparator = { bg = "NONE", fg = "NONE" },
        TabLine = { bg = "NONE" },
        TabLineFill = { bg = "NONE" },
        WinBar = { bg = "NONE", fg = "NONE" },
        WinBarNC = { bg = "NONE", fg = "NONE" },
        EndOfBuffer = { bg = "NONE", fg = "NONE" },
        FloatBorder = { bg = "NONE", fg = "NONE" },
      },
      astrodark = {},
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

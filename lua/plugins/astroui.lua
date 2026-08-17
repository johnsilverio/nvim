-- Configuração da interface de usuário (UI)
-- Recomendado instalar o Lua Language Server para autocomplete e documentação.

---@type LazySpec
return {
  "AstroNvim/astroui",
  ---@type AstroUIOpts
  opts = {
    -- Flexoki (kepano) — variante moon (dark)
    colorscheme = "flexoki",
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
      -- `init` roda pra TODO colorscheme (o AstroNvim aplica os módulos na
      -- ordem { "init", colors_name }). É aqui que ficam as minhas 3
      -- particularidades, derivadas do tema ativo, pra valerem em qualquer
      -- tema da galeria (themery): transparência só no dark, statusline sólida
      -- e CursorLine suave. O resto (acentos, Telescope, etc.) fica a cargo de
      -- cada tema. O cursor é tratado no polish.lua.
      init = function()
        local function hl(name) return vim.api.nvim_get_hl(0, { name = name, link = false }) end
        local function hex(v) return v and ("#%06x"):format(v) or nil end
        -- Mistura dois hex "#rrggbb" com fator t (0 = só a, 1 = só b).
        local function blend(a, b, t)
          local function comp(s, i) return tonumber(s:sub(i, i + 1), 16) end
          local function mix(x, y) return math.floor(x + (y - x) * t + 0.5) end
          return ("#%02x%02x%02x"):format(
            mix(comp(a, 2), comp(b, 2)),
            mix(comp(a, 4), comp(b, 4)),
            mix(comp(a, 6), comp(b, 6))
          )
        end

        local dark = vim.o.background == "dark"
        local bg = hex(hl("Normal").bg) or (dark and "#000000" or "#ffffff")
        local fg = hex(hl("Normal").fg) or (dark and "#ffffff" or "#000000")
        -- Transparência: vale só no dark E quando ligada. Ligada, o blur do
        -- compositor (Blur my Shell) aparece atrás do código. No light o fundo é
        -- sempre sólido (texto escuro sobre blur fica ilegível). O estado é
        -- alternado por <Leader>uT (polish.lua) e persiste; aqui só é lido — na
        -- 1ª vez carrega o valor salvo (default ligado).
        if vim.g.transparent_bg == nil then
          local f = io.open(vim.fn.stdpath "state" .. "/transparent_bg", "r")
          vim.g.transparent_bg = (not f) or (f:read "*l" ~= "0")
          if f then f:close() end
        end
        local transparent = (dark and vim.g.transparent_bg) and "NONE" or bg

        -- CursorLine suave: blend do fundo base com a CursorLine do tema, pra
        -- dar a sensação de "menos opaca" sobre o fundo transparente.
        local cursorline = blend(bg, hex(hl("CursorLine").bg) or bg, 0.7)

        -- Realce das ocorrências do símbolo sob o cursor (document highlight do
        -- LSP, no estilo do Helix): fundo sutil derivado da seleção (Visual) do
        -- tema, suavizado contra o fundo base pra NÃO se confundir com uma
        -- seleção real. O 0.55 é o ponto de calibração: sobe em direção a 1.0
        -- pra destacar mais, desce pra deixar mais discreto. Deriva do tema
        -- ativo, então vale pra qualquer um da galeria. Fallback (temas que
        -- fazem o Visual via reverse, sem bg próprio): mistura neutra fundo+texto.
        local visual = hex(hl("Visual").bg) or blend(bg, fg, 0.25)
        local reference_bg = blend(bg, visual, 0.55)

        -- Preserva o grupo do tema (fg + atributos) e só troca o bg. Assim a
        -- transparência não apaga as cores que cada tema define.
        local function keep(name, new_bg)
          local g = hl(name)
          g.bg = new_bg
          return g
        end

        local result = {
          Normal = keep("Normal", transparent),
          NormalNC = keep("NormalNC", transparent),
          SignColumn = keep("SignColumn", transparent),
          EndOfBuffer = keep("EndOfBuffer", transparent),
          FoldColumn = keep("FoldColumn", transparent),
          MsgArea = keep("MsgArea", transparent),
          LineNr = keep("LineNr", transparent),
          WinSeparator = keep("WinSeparator", transparent),
          VertSplit = keep("VertSplit", transparent),
          CursorLine = { bg = cursorline },
          -- Statusline no tom BASE (escuro) do tema, não no surface. Assim ela
          -- fica escura e harmoniza com a barra do tmux (que também usa o base),
          -- em vez de destoar mais clara.
          StatusLine = { fg = fg, bg = bg },
          StatusLineNC = { fg = hex(hl("Comment").fg) or fg, bg = bg },
          -- Ocorrências do símbolo sob o cursor (document highlight nativo do
          -- LSP, estilo Helix). Só o bg: o texto mantém a cor de syntax por baixo.
          LspReferenceText = { bg = reference_bg },
          LspReferenceRead = { bg = reference_bg },
          LspReferenceWrite = { bg = reference_bg },
        }
        -- Guarda o base sólido pro heirline (statusline) ler no render — imune à
        -- ordem dos autocmds de ColorScheme e ao Normal transparente.
        vim.g.statusline_bg = bg

        -- Itálico nas palavras-chave (if/for/return/etc.), genérico e
        -- preservando a cor de cada tema. Cobre syntax tradicional e treesitter.
        -- Requer fonte com itálico de verdade (JetBrainsMono Nerd Font tem, e o
        -- kitty.conf declara a face Medium Italic explicitamente).
        for _, k in ipairs {
          "Keyword", "Conditional", "Repeat", "Statement", "Exception",
          "@keyword", "@keyword.function", "@keyword.return",
          "@keyword.conditional", "@keyword.repeat", "@keyword.operator",
          "@keyword.import", "@keyword.exception",
        } do
          local g = hl(k)
          g.italic = true
          result[k] = g
        end

        return result
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

-- This will run last in the setup process.
-- This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

-- Formato do cursor (guicursor):
--   - Demais modos (normal/visual/command): bloco SÓLIDO com o grupo Cursor,
--     pinado no set_insert_cursor abaixo. O sufixo "-Cursor" é o que faz o
--     Neovim emitir a cor (OSC 12) pro terminal; SEM ele o cursor cairia na
--     cor default do terminal e não mudaria entre dark/light.
--   - Modo insert/command-insert: barra vertical magra (ver25) PISCANDO com cor
--     REBAIXADA (grupo InsertCursor). A cor mais apagada dá a impressão de
--     "transparência" e a barra fina diferencia o insert do bloco do modo
--     normal num relance.
-- Os parâmetros blinkwait/blinkon/blinkoff são em milissegundos: espera antes
-- de começar a piscar, tempo aceso e tempo apagado. Valores menores = piscada
-- mais rápida (aqui ~140ms aceso/apagado, mais ágil que o padrão).
local blink = "blinkwait250-blinkon140-blinkoff140"
vim.opt.guicursor = {
  "n-v-c-sm:block-Cursor",
  "i-ci-ve:ver25-" .. blink .. "-InsertCursor",
  "r-cr-o:hor20",
}

-- Define o grupo InsertCursor: uma versão levemente "rebaixada" (~90%) da cor
-- do cursor normal, misturada com o fundo da janela. Como terminais não
-- suportam alpha real no cursor, essa mistura com o fundo é o que simula a
-- opacidade reduzida. O 0.90 abaixo é o ponto calibrado pra este monitor (a
-- diferença tem que ser sutil) — aumente em direção a 1.0 pra deixar igual ao
-- cursor normal, ou diminua pra deixar mais translúcido. Derivado dos grupos
-- do tema (Cursor/Normal), então acompanha a paleta.
local function set_insert_cursor()
  local function hl(name) return vim.api.nvim_get_hl(0, { name = name, link = false }) end
  -- Cor do cursor por modo, genérica pra qualquer tema da galeria:
  --   - dark: bloco claro fixo #d0d0d0 (a cor que eu gosto), glifo escuro.
  --   - light: bloco = cor do texto do tema (escura), glifo = fundo do tema
  --     (claro). Deriva do Normal, então acompanha o tema ativo.
  -- O InsertCursor abaixo deriva daqui, então normal e insert ficam coerentes.
  local normal = hl "Normal"
  local light_bg = vim.o.background == "light"
  local block, glyph
  if light_bg then
    block = (normal.fg and ("#%06x"):format(normal.fg)) or "#100f0f"
    glyph = (normal.bg and ("#%06x"):format(normal.bg)) or "#fffcf0"
  else
    block, glyph = "#d0d0d0", "#161616"
  end
  vim.api.nvim_set_hl(0, "Cursor", { fg = glyph, bg = block })
  local cursor = hl "Cursor"
  local cur_bg = cursor.bg or 0xd0d0d0 -- cor do bloco no modo normal
  local win_bg = normal.bg or 0x161616 -- fundo da janela
  local function blend(a, b, alpha)
    local function ch(c, shift) return math.floor(c / shift) % 256 end
    local function mix(x, y) return math.floor(x * alpha + y * (1 - alpha) + 0.5) end
    return ("#%02x%02x%02x"):format(
      mix(ch(a, 65536), ch(b, 65536)),
      mix(ch(a, 256), ch(b, 256)),
      mix(a % 256, b % 256)
    )
  end
  vim.api.nvim_set_hl(0, "InsertCursor", {
    fg = cursor.fg and ("#%06x"):format(cursor.fg) or nil,
    bg = blend(cur_bg, win_bg, 0.90),
  })
end
set_insert_cursor()
-- Reaplica ao trocar de tema (o ColorScheme reseta highlights customizados).
-- O toggle dark/light (<Leader>ub) muda vim.o.background; o Neovim re-sourcea
-- o colorscheme sozinho na troca, e como variant="auto" o flexoki segue o
-- background. Esse re-source dispara ColorScheme, então este callback (e os
-- highlights do astroui) re-renderizam na variante certa. Não precisa de um
-- autocmd OptionSet manual — ele só brigaria com o re-source do core.
vim.api.nvim_create_autocmd("ColorScheme", {
  desc = "Reaplica a cor do cursor de insert ao trocar de tema",
  callback = set_insert_cursor,
})

-- Document highlight: realça as ocorrências do símbolo sob o cursor, no estilo
-- do Helix. Substitui o vim-illuminate (desligado no user.lua), que no Neovim
-- 0.12 não acompanha mais a API LSP e caía sempre no fallback regex (realçava
-- só texto repetido, sem semântica). Aqui usamos o método nativo
-- vim.lsp.buf.document_highlight, o MESMO que o Helix usa: o language server
-- responde com as referências e o Neovim pinta os grupos LspReference* (cor
-- calibrada no astroui.lua). O guard supports_method só liga isto em buffers
-- cujo LSP de fato implementa o método. updatetime baixo é só pra o CursorHold
-- disparar rápido (~250ms parado) em vez dos 4s do default; some ao mover.
vim.opt.updatetime = 250
vim.api.nvim_create_autocmd("LspAttach", {
  desc = "Liga o document highlight nos buffers cujo LSP suporta",
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client or not client:supports_method "textDocument/documentHighlight" then return end
    local group = vim.api.nvim_create_augroup("doc_highlight_" .. args.buf, { clear = true })
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      group = group,
      buffer = args.buf,
      desc = "Realça as ocorrências do símbolo sob o cursor",
      callback = function() vim.lsp.buf.document_highlight() end,
    })
    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "BufLeave" }, {
      group = group,
      buffer = args.buf,
      desc = "Limpa o realce ao mover o cursor",
      callback = function() vim.lsp.buf.clear_references() end,
    })
  end,
})

-- Toggle do fundo transparente (afeta só o dark — no light o fundo é sempre
-- sólido, pra texto escuro não brigar com o blur). O estado persiste em
-- stdpath('state')/transparent_bg e é lido pelo highlights.init (astroui.lua);
-- aqui invertemos, salvamos e reaplicamos o tema pra re-renderizar. <Leader>uT.
local function toggle_transparent_bg()
  vim.g.transparent_bg = not (vim.g.transparent_bg ~= false)
  local f = io.open(vim.fn.stdpath "state" .. "/transparent_bg", "w")
  if f then
    f:write(vim.g.transparent_bg and "1" or "0")
    f:close()
  end
  if vim.g.colors_name then vim.cmd.colorscheme(vim.g.colors_name) end
  vim.notify("Fundo transparente: " .. (vim.g.transparent_bg and "ON" or "OFF"))
end
vim.keymap.set("n", "<Leader>uT", toggle_transparent_bg, { desc = "Toggle fundo transparente" })

-- Tabline sempre escondida (showtabline=0). Assim o neo-tree e os arquivos
-- ficam sempre colados na barra do tmux, sem aquela barra de abas full-width
-- no topo empurrando tudo pra baixo. (A tabline em si é desabilitada no
-- heirline.lua; este autocmd é a rede de segurança caso algo — snacks
-- dashboard, etc. — tente voltar showtabline para 2.)
-- Realce da linha do cursor: ligado (cursorline já vem true do AstroNvim), mas
-- no editor só o NÚMERO da linha atual acende, sem a faixa cheia, que ali era
-- redundante. Definido aqui no polish, e não no astrocore.lua, porque aquele
-- arquivo está inerte pelo guard "if true then return {}" do template.
vim.opt.cursorlineopt = "number"

-- Já nas janelas de navegação, a faixa cheia é o que mostra qual item está
-- selecionado, então reativamos "line" só nelas. Acrescente filetypes à lista
-- conforme usar (aerial, Outline, lazy, etc.).
vim.api.nvim_create_autocmd("FileType", {
  desc = "Faixa da CursorLine só em janelas de navegação, não no editor",
  pattern = { "neo-tree", "qf" },
  callback = function()
    vim.opt_local.cursorline = true
    vim.opt_local.cursorlineopt = "line"
  end,
})

vim.opt.showtabline = 0
local hide_tabline = vim.api.nvim_create_augroup("hide_tabline", { clear = true })
vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter", "WinNew", "WinClosed", "BufEnter" }, {
  group = hide_tabline,
  desc = "Mantém a tabline sempre escondida",
  callback = function()
    vim.schedule(function()
      if vim.o.showtabline ~= 0 then
        vim.o.showtabline = 0
        vim.cmd "redraw"
      end
    end)
  end,
})

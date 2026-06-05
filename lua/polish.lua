-- This will run last in the setup process.
-- This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

-- Formato do cursor (guicursor):
--   - Demais modos (normal/visual/command): bloco SÓLIDO, cor cheia (grupo
--     Cursor padrão do tema).
--   - Modo insert/command-insert: bloco PISCANDO com cor REBAIXADA (grupo
--     InsertCursor), em vez da barra vertical (ver25) padrão do Neovim. A cor
--     mais apagada dá a impressão de "transparência" e diferencia o insert do
--     modo normal num relance.
-- Os parâmetros blinkwait/blinkon/blinkoff são em milissegundos: espera antes
-- de começar a piscar, tempo aceso e tempo apagado. Valores menores = piscada
-- mais rápida (aqui ~140ms aceso/apagado, mais ágil que o padrão).
local blink = "blinkwait250-blinkon140-blinkoff140"
vim.opt.guicursor = {
  "n-v-c-sm:block",
  "i-ci-ve:block-" .. blink .. "-InsertCursor",
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
  local cursor = hl "Cursor"
  local normal = hl "Normal"
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
vim.api.nvim_create_autocmd("ColorScheme", {
  desc = "Reaplica a cor do cursor de insert ao trocar de tema",
  callback = set_insert_cursor,
})

-- Tabline sempre escondida (showtabline=0). Assim o neo-tree e os arquivos
-- ficam sempre colados na barra do tmux, sem aquela barra de abas full-width
-- no topo empurrando tudo pra baixo. (A tabline em si é desabilitada no
-- heirline.lua; este autocmd é a rede de segurança caso algo — snacks
-- dashboard, etc. — tente voltar showtabline para 2.)
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

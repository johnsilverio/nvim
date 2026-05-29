-- This will run last in the setup process.
-- This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

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

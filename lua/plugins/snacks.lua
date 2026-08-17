-- Snacks picker: as buscas mostram arquivos do .gitignore e ocultos por padrão.
-- Mesmo motivo do neo-tree — o .gitignore é sobre o que não sobe pro repo, não
-- sobre o que você precisa encontrar e abrir. Dentro do picker, as teclas "i"
-- (ignored) e "h"/"H" (hidden) alternam isso na hora, se quiser filtrar num caso.
---@type LazySpec
return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        files = { hidden = true, ignored = true },
        grep = { hidden = true, ignored = true },
      },
    },
  },
}

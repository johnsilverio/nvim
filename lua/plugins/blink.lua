-- Override do blink.cmp (motor de completion do AstroNvim v5)
-- Objetivo: desligar o autocomplete automático. O menu de sugestões,
-- a janela de documentação e o ghost text só aparecem ao apertar uma tecla.

---@type LazySpec
return {
  "Saghen/blink.cmp",
  opts = {
    completion = {
      -- O menu de sugestões CONTINUA aparecendo automaticamente ao digitar
      -- (auto_show fica no padrão = true). É o que faz ruff + pyright valerem a pena.

      -- O box grande de documentação (assinaturas/docs do item selecionado)
      -- não abre automático; só ao pedir com <C-Space> dentro do menu.
      documentation = { auto_show = false },

      -- Desliga o texto-fantasma inline (aquele "values: object" estilo Copilot).
      ghost_text = { enabled = false },
    },

    -- Não abrir a janela de assinatura da função automaticamente
    -- ao digitar dentro dos parênteses (ex.: print()).
    signature = { enabled = false },
  },
}

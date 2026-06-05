-- Visualizacao de markdown renderizada dentro do proprio buffer do Neovim.
-- Renderiza titulos, blocos de codigo, tabelas, checkboxes, etc. sem sair do editor.
---@type LazySpec
return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  ft = { "markdown", "markdown_inline" },
  opts = {
    -- renderiza em TODOS os modos = "modo view" persistente (estilo VS Code).
    -- A linha onde o cursor esta fica em texto cru automaticamente (anti_conceal),
    -- entao da pra editar sem precisar sair do view. Use <leader>mv pra alternar
    -- entre VIEW (renderizado) e EDIT (texto cru).
    render_modes = true,
    anti_conceal = { enabled = true },
    code = {
      sign = false,
      width = "block",
      right_pad = 1,
    },
    heading = {
      sign = false,
    },
  },
  keys = {
    -- alterna entre modo VIEW (renderizado) e EDIT (texto cru)
    { "<leader>mv", "<cmd>RenderMarkdown toggle<cr>", desc = "Markdown: alternar View/Edit", ft = "markdown" },
  },
}

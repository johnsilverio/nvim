-- Neo-tree: mostra tudo, inclusive arquivos ignorados pelo git e dotfiles.
-- O .gitignore decide o que NÃO sobe pro repositório, não o que você pode ver e
-- editar localmente (.env, builds, configs locais). O único escondido de
-- propósito é a pasta .git, que é metadado interno e só faz ruído na árvore.
---@type LazySpec
return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      filtered_items = {
        visible = false, -- sem o modo "mostra os filtrados em cinza"; aqui nada é filtrado
        hide_dotfiles = false, -- mostra .env, .gitignore, .github, etc
        hide_gitignored = false, -- mostra o que está no .gitignore
        never_show = { ".git" }, -- exceto a pasta .git, puro ruído
      },
    },
  },
}

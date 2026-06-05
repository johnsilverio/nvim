return {
  "rebelot/heirline.nvim",
  opts = function(_, opts)
    local status = require("astroui.status")
    opts.statusline = {
      hl = { fg = "fg", bg = "bg" },
      status.component.mode({
        mode_text = { padding = { left = 1, right = 1 } },
      }),
      status.component.git_branch(),
      status.component.file_info(),
      status.component.git_diff(),
      status.component.diagnostics(),
      status.component.fill(),
      status.component.cmd_info(),
      status.component.fill(),
      status.component.lsp(),
      status.component.virtual_env(),
      status.component.treesitter(),
      status.component.nav(),
    }
    opts.winbar = nil
    opts.tabline = nil -- desabilita a barra de abas (tabline) — fica tudo colado no topo
  end,
  -- Com a tabline desabilitada acima, os atalhos padrão de "buffer da tabline"
  -- (<Leader>bb/bd/b\/b|) quebram com E5108: eles chamam buffer_picker, que tenta
  -- indexar require("heirline").tabline (que é nil). Remapeamos para alternativas
  -- que não dependem da tabline.
  specs = {
    {
      "AstroNvim/astrocore",
      ---@param opts AstroCoreOpts
      opts = function(_, opts)
        opts.mappings = opts.mappings or {}
        local maps = opts.mappings
        maps.n = maps.n or {}
        maps.n["<Leader>bb"] = {
          function() require("snacks").picker.buffers() end,
          desc = "Buscar/trocar buffer",
        }
        maps.n["<Leader>bd"] = {
          function() require("astrocore.buffer").close() end,
          desc = "Fechar buffer atual",
        }
        maps.n["<Leader>b\\"] = { function() vim.cmd.split() end, desc = "Split horizontal" }
        maps.n["<Leader>b|"] = { function() vim.cmd.vsplit() end, desc = "Split vertical" }
      end,
    },
  },
}

if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE
-- Customize Treesitter
---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  opts = {
    ensure_installed = {
      "lua",
      "vim",
      "python",
      "markdown",
      "markdown_inline",
    },
    highlight = {
      enable = true,
      disable = function(_, buf) return vim.bo[buf].filetype == "markdown" end,
    },
  },
}

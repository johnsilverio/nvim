return {
  "Pocco81/auto-save.nvim",
  event = { "InsertLeave", "TextChanged" },
  opts = {
    enabled = true,
    execution_message = {
      message = function() return "AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S") end,
      dim = 0.18,
      cleaning_interval = 1250,
    },
    debounce_delay = 2000, -- delay in ms (2s)
    condition = function(buf)
      local fn = vim.fn
      local utils = require("auto-save.utils.data")
      if fn.getbufvar(buf, "&modifiable") == 1 and fn.getbufvar(buf, "&buftype") == "" then
        return true
      end
      return false
    end,
    -- Marca ponto de undo antes do autosave
    callbacks = {
      before_saving = function()
        vim.cmd("silent! normal! mZ")
      end,
    },
  },
}

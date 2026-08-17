-- Pyright em monorepo (Django dentro de um repo que também tem o frontend).
--
-- Dois ajustes, e os dois existem porque o pyright sozinho erra:
--   1. Ele NÃO descobre virtualenv. Usa o `python` do $PATH e os site-packages
--      dele, então sem venv ativado no shell todo import de Django vira
--      "could not be resolved".
--   2. O root_dir default aceita `.git` com o mesmo peso dos marcadores Python.
--      Num monorepo isso ancora o workspace na raiz, junto do node_modules, e
--      os imports absolutos do backend param de resolver.

local uv = vim.uv

local function venv_python(dir)
  for _, name in ipairs { ".venv", "venv", "env" } do
    local python = dir .. "/" .. name .. "/bin/python"
    if uv.fs_stat(python) then return python end
  end
end

local function resolve_python(root)
  if vim.env.VIRTUAL_ENV then return vim.env.VIRTUAL_ENV .. "/bin/python" end
  local dir = root
  while dir and dir ~= "/" and dir ~= vim.env.HOME do
    local python = venv_python(dir)
    if python then return python end
    -- Para no topo do repositório: herdar um venv de fora dele é sempre acidente.
    if uv.fs_stat(dir .. "/.git") then break end
    dir = vim.fs.dirname(dir)
  end
  local system = vim.fn.exepath "python3"
  return system ~= "" and system or "python3"
end

local root_files = {
  "pyrightconfig.json",
  "pyproject.toml",
  "manage.py",
  "setup.py",
  "setup.cfg",
  "requirements.txt",
  "Pipfile",
}

---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    config = {
      pyright = {
        -- O .git só depois do resto, como último recurso.
        root_dir = function(fname) return vim.fs.root(fname, root_files) or vim.fs.root(fname, ".git") end,
        -- on_new_config e não before_init: aqui o client ainda não foi criado,
        -- então trocar a tabela settings inteira vale. Em before_init o client
        -- já copiou a referência antiga e a troca é descartada em silêncio.
        on_new_config = function(new_config, root_dir)
          new_config.settings = vim.tbl_deep_extend("force", new_config.settings or {}, {
            python = { pythonPath = resolve_python(root_dir) },
          })
        end,
      },
    },
  },
}

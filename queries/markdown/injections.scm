; Sobrescreve a query de injection do markdown do nvim-treesitter (branch master, arquivado),
; que usa o diretivo custom (#set-lang-from-info-string!) e quebra no Neovim 0.12
; com: "attempt to call method 'range' (a nil value)".
; Esta versao usa @injection.language padrao (igual a do runtime do Neovim) e nao quebra.

(fenced_code_block
  (info_string
    (language) @injection.language)
  (code_fence_content) @injection.content)

((html_block) @injection.content
  (#set! injection.language "html")
  (#set! injection.combined)
  (#set! injection.include-children))

((minus_metadata) @injection.content
  (#set! injection.language "yaml")
  (#offset! @injection.content 1 0 -1 0)
  (#set! injection.include-children))

((plus_metadata) @injection.content
  (#set! injection.language "toml")
  (#offset! @injection.content 1 0 -1 0)
  (#set! injection.include-children))

([
  (inline)
  (pipe_table_cell)
] @injection.content
  (#set! injection.language "markdown_inline"))

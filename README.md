# my neovim config

![Screenshot](./preview/Screenshot%202025-10-31%20002540.png)

this is my custom neovim configuration, based on astro nvim, with full transparency, modern ui, and custom keybindings.

![Screenshot](./preview/Screenshot%202025-10-31%20001556.png)

## features
- full window transparency
- beautiful statusline and tabline
- custom colorschemes (tokyodark, cyberdream, oxocarbon)
- modern lsp and completion setup
- neotree file explorer
- integrated terminal
- easy plugin management with lazy.nvim

## keybindings reference

| keybinding         | mode | description                       |
|-------------------|------|-----------------------------------|
| ]b                | n    | next buffer                       |
| [b                | n    | previous buffer                   |
| <leader>bd        | n    | close buffer from tabline         |
| gD                | n    | go to declaration of symbol       |
| <leader>uY        | n    | toggle lsp semantic highlight     |
| :VimBeGood        | cmd  | start vim-be-good game            |
| <leader>ff        | n    | find files (telescope/fzf)        |
| <leader>fg        | n    | live grep (telescope/fzf)         |
| <leader>e         | n    | open neotree file explorer        |
| <leader>tt        | n    | open integrated terminal          |
| <leader>q         | n    | quit neovim                       |
| <leader>w         | n    | write/save file                   |
| <leader>rn        | n    | rename symbol (lsp)               |
| <leader>ca        | n    | code action (lsp)                 |
| <leader>gd        | n    | go to definition (lsp)            |
| <leader>gr        | n    | go to references (lsp)            |
| <leader>gi        | n    | go to implementation (lsp)        |
| <leader>f         | n    | format file (lsp/none-ls)         |

add your own screenshot above and update the table as you add more keybindings.

## credits
- based on [astro nvim](https://github.com/AstroNvim/AstroNvim)
- see each plugin's repo for more details
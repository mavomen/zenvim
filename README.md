# ZenVim

Minimal, modular Neovim configuration focused on clarity and speed.

- Lua‑only configuration
- Plugin management via lazy.nvim
- Modular architecture (`zen/core`, `zen/plugins`, `zen/keys`)
- Clean UI with lualine statusline and tabline
- Navigation‑first keymap design
- LSP via native Neovim 0.11 APIs
- File management with oil.nvim
- Fast startup and minimal dependencies
- Even Quieter with zenmode.nvim
- Modular LSP configuration for more functionality & customization

Clone it in `~/.config/` or dotfiles repository then symlink/stow to `.config/` direrctory.
Run with if you want to keep your main cnf: `NVIM_APPNAME=zenvim nvim`

# config.nvim

My personal Neovim configuration files on macOS (apple silicon).

This setup is mainly used for taking notes and writing documents in LaTeX.
For the useful snippets (of mathematics, especially algebraic geometry)
see [mysnippets]

## Installation

### macOS

1. Install `Homebrew`:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

2. Install `kitty` and a `Nerd Font`:

```bash
brew install --cask kitty
brew tap homebrew/cask-fonts
brew install font-codicon font-jetbrains-mono-nerd-font font-symbols-only-nerd-font
```

3. Install `Neovim` (Head):

```bash
brew install neovim --HEAD
```

4. Install some dependencies:

```bash
brew install fd lazygit node ripgrep
```

5. Clone this repository:

```bash
git clone --depth 1 https://github.com/mathjiajia/nvim_tex.git ~/.config/nvim
```

5. Install `MacTeX` (we don't need the GUI version).
   We postpone this step since `MacTeX` file is too large:

```bash
brew install --cask mactex-no-gui
```

### Windows

1. Install WSL2

```bash
wsl --install
```

## Structure

```txt
├── README.md
├── after
│   └── ftplugin
│       ├── lua.lua
│       └── tex.lua
├── init.lua
├── lazy-lock.json
└── lua
    ├── config
    │   ├── autocmds.lua
    │   ├── keymaps.lua
    │   └── options.lua
    └── plugins
        ├── coding.lua
        ├── editor.lua
        ├── formatting.lua
        ├── lang.lua
        ├── lsp.lua
        └── ui.lua
```

- `init.lua` -- entrance of the configuration
- `lua/config` -- configuration files
- `lua/plugins` -- submodules for different plugins
- `after/ftplugin` -- individual file type settings

[mysnippets]: https://github.com/mathjiajia/mySnippets

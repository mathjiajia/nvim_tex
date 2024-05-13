# config.nvim

My personal Neovim configuration files on macOS (apple silicon).

This setup is mainly used for taking notes and writing documents in LaTeX.
For the useful snippets (of mathematics, especially algebraic geometry)
see [mysnippets]

## Installation

### macOS

1. Install `Homebrew`:

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

1. Install `kitty` and a `Nerd Font`:

```sh
brew install --cask kitty
brew tap homebrew/cask-fonts
brew install font-codicon font-jetbrains-mono-nerd-font font-symbols-only-nerd-font
```

1. Install `Neovim` (Head):

```sh
brew install neovim --HEAD
```

1. Install some dependencies:

```sh
brew install fd lazygit node ripgrep gnu-sed tree-sitter
brew install --cask sioyek skim
```

1. Clone this repository:

```sh
git clone --depth 1 https://github.com/mathjiajia/nvim_tex.git ~/.config/nvim
```

1. Install `MacTeX` (we don't need the GUI version).
   We postpone this step since `MacTeX` file is too large:

```bash
brew install --cask mactex-no-gui
```

### Windows

1. Install `WSL2`:

```sh
wsl --install
```

1. Install `Neovim`:

```sh
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt update
sudo apt install neovim
```

1. Install some dependencies:

```sh
sudo apt install zathura ripgrep cargo fswatch unzip
cargo install tree-sitter-cli
echo 'export PATH=~/.cargo/bin' >> ~/.bashrc
```

1. Clone this repository:

```sh
git clone --depth 1 https://github.com/mathjiajia/nvim_tex.git ~/.config/nvim
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

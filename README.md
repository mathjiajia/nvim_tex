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

1. Install some dependencies and some `Nerd Fonts`:

```sh
brew install fd lazygit node ripgrep gnu-sed tree-sitter
brew install --cask kitty sioyek skim font-codicon font-jetbrains-mono-nerd-font font-symbols-only-nerd-font
```

1. Clone `kitty` config:

```sh
git clone --depth 1 https://github.com/mathjiajia/config.kitty.git ~/.config/kitty
```

1. Install `Neovim` (Head):

```sh
brew install neovim --HEAD
```

1. Clone `nvim` config:

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
sudo apt install zathura ripgrep fd-find node fswatch unzip
```

1. Update `node.js` to install `tree-sitter`:

```sh
sudo npm cache clean -f
sudo npm install -g n
sudo n stable
sudo npm install --global tree-sitter-cli
```

1. Clone `nvim` config:

```sh
git clone --depth 1 https://github.com/mathjiajia/nvim_tex.git ~/.config/nvim
```

1. Install `lazygit`:

```sh
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin
```

1. Install `texlive`:

```sh
sudo apt install texlive-full
```

If it stops with `Pregenerating ConTeXt MarkIV format. This may take some time...`,
then press `Enter`.

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

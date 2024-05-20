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

1. Install `Neovim`, some dependencies and some `Nerd Fonts`:

```sh
brew install neovim fd node ripgrep gnu-sed tree-sitter
brew install --cask kitty sioyek font-codicon font-jetbrains-mono-nerd-font font-symbols-only-nerd-font
```

1. Clone `kitty` config:

```sh
git clone --depth 1 https://github.com/mathjiajia/config.kitty.git ~/.config/kitty
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

1. Install `Neovim`
   (here we use pre-built archives since `nvim-0.10` is not available on `apt`):

```sh
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux64.tar.gz
echo 'export PATH="$PATH:/opt/nvim-linux64/bin"' >> ~/.bashrc
```

If the network is not stable, then download this [file](https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz)
directly.

1. Install some dependencies:

```sh
sudo apt update && sudo apt upgrade
sudo apt install fd-find fswatch npm ripgrep unzip
```

1. Update `node.js` to install `tree-sitter`:

```sh
sudo npm cache clean -f
sudo npm install -g n
sudo n stable
sudo npm install --global tree-sitter-cli
```

1. Install `sioyek` PDF reader:

```sh
curl -LO https://github.com/ahrm/sioyek/releases/download/v2.0.0/sioyek-release-linux-portable.zip
unzip sioyek-release-linux-portable.zip
sudo mkdir -p opt/sioyek
sudo mv Sioyek-x86_64.AppImage opt/sioyek/sioyek
echo 'export PATH="$PATH:/opt/sioyek"' >> ~/.bashrc
```

1. Clone `nvim` config:

```sh
git clone --depth 1 https://github.com/mathjiajia/nvim_tex.git ~/.config/nvim
```

1. Download some nerd fonts and use it in `Windows Terminal`:

1. Set `latexmkrc`:

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
├── lua
│   ├── config
│   │   ├── autocmds.lua
│   │   ├── keymaps.lua
│   │   └── options.lua
│   └── plugins
│       ├── coding.lua
│       ├── editor.lua
│       ├── formatting.lua
│       ├── lang.lua
│       ├── lsp.lua
│       └── ui.lua
└── luasnippets
```

- `init.lua` -- entrance of the configuration
- `lua/config` -- configuration files
- `lua/plugins` -- submodules for different plugins
- `after/ftplugin` -- individual file type settings
- `luasnippets` -- many useful snippets, especially for for `LaTeX`

[mysnippets]: https://github.com/mathjiajia/mySnippets

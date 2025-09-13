# CRUSH.md for nvim_tex

## Linting

- **Lua files:** Use `luacheck` for linting Lua code. Configuration is typically found in `.luacheckrc`.

## Code Style Guidelines

- **General Lua:**
    - Use `local` for local variables and functions.
    - Prefer `snake_case` for variables and function names.
    - Indent with 2 spaces.
- **Neovim Specific:**
    - Use `vim.o` for `set opt` (options), `vim.g` for `let g:var` (global variables).
    - Use `require()` for loading modules.
    - Organize configuration files logically within `lua/` and `after/ftplugin/`.
- **Imports:**
    - Use `require("module.submodule")` for importing Lua modules.
    - Place imports at the top of the file.
- **Error Handling:**
    - Utilize `pcall` for protected calls when interacting with external functions or when an operation might fail.
    - Log errors appropriately.

## Testing

- Testing of Neovim configurations is primarily manual. Verify functionality by opening Neovim and testing features directly.

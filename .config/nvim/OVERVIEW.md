# Neovim Configuration Overview

> **Namespace:** `dudzie` · **Plugin manager:** [lazy.nvim](https://github.com/folke/lazy.nvim) · **Primary focus:** Python development (+ C++ support)

---

## Quick Reference

### LSP

| Key | Action |
| --- | --- |
| `gd` | Telescope definitions |
| `gD` | Peek declaration / definition |
| `gr` | Telescope references |
| `gi` | Telescope implementations |
| `K` | Hover documentation |
| `<leader>ca` | Code action |
| `<leader>rn` | Rename symbol |
| `gl` / `[d` / `]d` | Line diagnostics / previous / next |
| `<leader>oi` | Ruff organize imports |
| `<leader>fix` | Ruff fix all |

### DAP

| Key | Action |
| --- | --- |
| `<F5>` | Continue |
| `<F10>` | Step over |
| `<F11>` | Step into |
| `<F12>` | Step out |
| `<leader>b` | Toggle breakpoint |
| `<F1>` | Toggle left DAP sidebar |
| `<leader>db` | Toggle bottom DAP tray |
| `<leader>dc` | Open floating console |

### Completion

| Key | Action |
| --- | --- |
| `<C-Space>` | Show completion / toggle docs |
| `<C-e>` | Hide completion menu |
| `<C-d>` / `<C-f>` | Scroll completion docs up / down |
| `<CR>` | Accept completion |
| `<Tab>` / `<S-Tab>` | Next / previous item or snippet jump |

### Navigation

| Key | Action |
| --- | --- |
| `<leader>sf` | Telescope find files |
| `<leader>sg` | Telescope git files |
| `<leader>st` | Telescope grep string |
| `<leader>a` | Harpoon add file |
| `<leader>of` | Open `mini.files` |
| `<A-Left/Down/Up/Right>` | Move across Vim / tmux panes |
| `<leader>gs` | Open Fugitive `:Git` |

---

## Table of Contents

1. [Quick Reference](#quick-reference)
2. [Directory Layout](#directory-layout)
3. [Plugin Inventory](#plugin-inventory)
   - [LSP & Formatting](#lsp-formatting)
   - [Debugging (DAP)](#debugging-dap)
   - [Completion & AI](#completion-ai)
   - [Appearance & UI](#appearance-ui)
   - [Navigation & Search](#navigation-search)
   - [Version Control](#version-control)
   - [Miscellaneous](#miscellaneous)
4. [Implemented & Working](#implemented-working)
5. [Known Pain Points & TODOs](#known-pain-points-todos)
6. [Redundant / Outdated](#redundant-outdated)
7. [Ideas & Wishlist](#ideas-wishlist)

---

## Directory Layout

```
~/.config/nvim/
├── init.lua                        # Lazy.nvim bootstrap + plugin spec imports
├── OVERVIEW.md                     # This file
├── lazy-lock.json                  # Locked plugin versions
├── lazyvim.json
├── lsp/                            # Per-server LSP configuration files
│   ├── clangd.lua
│   ├── lua_ls.lua
│   ├── ruff.lua
│   ├── ty.lua
│   └── pyrefly.lua
├── after/
│   └── ftplugin/
│       └── python.lua              # Python-specific filetype overrides
└── lua/dudzie/
    ├── set/
    │   ├── keymaps.lua             # Global keymaps
    │   └── set.lua                 # vim.opt editor settings
    ├── lsp/
    │   ├── init.lua                # Diagnostic config, LspStart/Stop/Restart/Log/Info commands
    │   ├── plugins/
    │   │   ├── mason.lua           # Mason package manager (auto-installs tools)
    │   │   └── conform.lua         # Autoformatting (conform.nvim)
    │   └── utils/
    │       ├── on_attach.lua       # Shared LSP keymaps applied on attach
    │       ├── capabilities.lua    # blink.cmp capabilities advertised to servers
    │       ├── venv.lua            # Python virtual-environment detection
    │       ├── definition.lua      # Go-to-definition utility wrapper
    │       └── workspace_diagnostic.lua
    ├── debugging/
    │   ├── nvim-dap.lua            # Core DAP setup + breakpoint sign/highlight config
    │   ├── nvim-dap-ui.lua         # dapui layouts, floating elements, keymaps
    │   ├── nvim-dap-python.lua     # Python debug adapter via debugpy (Mason)
    │   ├── nvim-dap-cpp.lua        # C++ debug adapter setup
    │   ├── nvim-dap-virtual-text.lua
    │   ├── cpp.lua
    │   └── trouble.lua             # Trouble.nvim diagnostics list
    ├── text_editing/
    │   ├── blink.lua               # blink.cmp completion engine
    │   ├── copilot.lua             # copilot.lua (suggestion/panel disabled; used via blink)
    │   ├── codecompanion.lua       # CodeCompanion AI chat (Copilot adapter, history ext.)
    │   ├── nvim-treesitter.lua     # Treesitter parser config
    │   ├── indent_blankline.lua    # Indent guides
    │   └── undotree.lua            # Undo history visualiser
    ├── appearance/
    │   ├── gruvbox.lua             # gruvbox-material colorscheme
    │   ├── lualine.lua             # Status line (Copilot status + CodeCompanion spinner)
    │   ├── snacks.lua              # snacks.nvim (dashboard, bigfile, scope, words, quickfile)
    │   ├── noice.lua               # Noice UI (cmdline, messages, popupmenu override)
    │   ├── nvim-notify.lua         # nvim-notify backend
    │   └── todo.lua                # todo-comments (TODO/FIXME/NOTE highlighting)
    ├── search_navigation/
    │   ├── telescope.lua           # Telescope fuzzy finder + fzf-native
    │   ├── harpoon.lua             # Harpoon quick file marks
    │   ├── mini-files.lua          # mini.files file manager
    │   ├── which-key.lua           # which-key keybinding hints
    │   └── vim-tmux-navigator.lua  # <C-hjkl> split/pane navigation across vim & tmux
    ├── version_control/
    │   └── fugitive.lua            # vim-fugitive Git integration
    ├── misc/
    │   ├── hardtime.lua            # hardtime.nvim (bad-habit detection)
    │   ├── typr.lua                # Typing practice mini-game
    │   └── cellular-automaton.lua  # Fun eye-candy
    ├── components/
    │   ├── codecompanion_spinner.lua  # lualine component: CodeCompanion activity spinner
    │   └── lazydev.lua               # lazydev.nvim (Lua LSP dev helpers)
    └── plugins/
        └── copilot.lua             # ⚠️ Possibly duplicate of text_editing/copilot.lua
```

---

## Plugin Inventory

### LSP & Formatting

**LSP architecture:** `lsp/init.lua` sets diagnostic UI defaults (custom signs, rounded floats, `update_in_insert = false`, severity sorting), defines `:LspStart`, `:LspStop [name]`, `:LspRestart`, `:LspLog`, and `:LspInfo`, applies shared defaults via `vim.lsp.config["*"]`, and auto-enables `ruff`, `lua_ls`, `ty`, and `clangd`.

| Server / Tool | Status | Purpose | Key configuration / behavior |
|---|---|---|---|
| `ruff` | enabled | Python linting, fixes, import sorting, formatting support | Runs `ruff server --preview`; `diagnosticMode = "workspace"`; preview lint/format enabled; `on_attach` disables Ruff hover so another Python server can provide docs; adds `<leader>oi` and `<leader>fix`. |
| `ty` | enabled | Python type checking | Runs `ty server`; `diagnosticMode = "workspace"`; ignores `possibly-missing-attribute`; rooted by `pyproject.toml` / `.git`; enabled directly, not Mason-managed here. |
| `lua_ls` | enabled | Lua / Neovim config language support | Runs `lua-language-server`; treats `vim` as a global; telemetry disabled. |
| `clangd` | enabled | C / C++ / Objective-C / CUDA LSP | Rooted by clang config / compilation DB files; custom `get_language_id`; requests `editsNearCursor`; negotiates `offsetEncoding`; adds buffer-local `:LspClangdSwitchSourceHeader` and `:LspClangdShowSymbolInfo`. |
| `pyrefly` | configured, not enabled | Experimental / alternate Python LSP | Runs `pyrefly lsp`, but it is not listed in `vim.lsp.enable(...)` and is not ensured by Mason. |
| `conform.nvim` | configured, disabled | External formatter orchestration | Maps `lua -> stylua`, `python -> ruff_format`, `cpp -> clang_format`; `format_on_save = { timeout_ms = 500, lsp_fallback = false }`; plugin spec is currently `enabled = false`. |
| `mason.nvim` | enabled | Tool installer for the LSP stack | `ensure_installed = { "basedpyright", "ruff", "lua-language-server", "clangd", "clang-format" }`; notable mismatch: `ty` is enabled but not ensured, while `basedpyright` is ensured but not enabled. |

**Shared `on_attach` keymaps**

| Mode | Key | Action | Notes |
|---|---|---|---|
| `n` | `gD` | Peek declaration / definition in a floating window | Uses `dudzie.lsp.utils.definition.get_def()` rather than the default jump. |
| `n` | `gd` | Telescope definitions | `:Telescope lsp_definitions` |
| `n` | `gi` | Telescope implementations | `:Telescope lsp_implementations` |
| `n` | `gr` | Telescope references | `:Telescope lsp_references` |
| `n` | `K` | Hover docs | Single border, max height 30, max width 120. |
| `n` | `<leader>sh` | Signature help | Native `vim.lsp.buf.signature_help` |
| `n` | `<leader>ls` | Document symbols | `:Telescope lsp_document_symbols` |
| `n` | `<leader>lS` | Workspace symbols | `:Telescope lsp_dynamic_workspace_symbols` |
| `n` | `<leader>ca` | Code action | Native LSP code actions |
| `n` | `<leader>rn` | Rename symbol | Native rename |
| `n` | `<leader>lh` | Toggle inlay hints | Per-buffer toggle via `vim.lsp.inlay_hint` |
| `n` | `<leader>ll` | Run CodeLens | `vim.lsp.codelens.run` |
| `n` | `gl` | Line diagnostics float | `vim.diagnostic.open_float` |
| `n` | `[d` | Previous diagnostic | Opens float on jump |
| `n` | `]d` | Next diagnostic | Opens float on jump |
| `n` | `<leader>dq` | Diagnostics to loclist | `vim.diagnostic.setloclist` |
| `n` | `<leader>dv` | Toggle diagnostic virtual text | Flips `vim.diagnostic.config().virtual_text` |
| `n` | `<leader>oi` | Ruff organize imports | Ruff only; applies `source.organizeImports.ruff` |
| `n` | `<leader>fix` | Ruff fix all | Ruff only; applies `source.fixAll.ruff` |

**Shared capabilities / behavior**
- Starts from `vim.lsp.protocol.make_client_capabilities()` and merges `blink_cmp.sources.lsp.capabilities()` when available.
- Adds folding support via `textDocument.foldingRange = { dynamicRegistration = false, lineFoldingOnly = true }`.
- `on_attach` sets `omnifunc` / `tagfunc` when supported, disables semantic tokens globally, and shows an `LSP attached: <client>` notification.
- There is still a `basedpyright` formatting-disable branch in `on_attach`, but `basedpyright` is not currently enabled.

**Python venv detection (`venv.lua`)**
- Finds the project root from `.git` or `pyproject.toml`.
- Looks for `<root>/.venv`.
  - If `.venv` is a directory, it uses that environment directly.
  - If `.venv` is a file, it reads the first line and expands it to `~/.virtualenvs/<name>`.
- `setup()` prepends `<venv>/bin` to the original `PATH`, sets `VIRTUAL_ENV`, caches the active env, and avoids reapplying the same environment.
- No current call site was found, so this helper appears present but not wired into buffer/LSP startup.

**`workspace_diagnostic.lua`**
- Builds a workspace file list from `git ls-files`, filters unreadable files, skips ignored binary / asset extensions, detects filetypes, and sends synthetic `textDocument/didOpen` notifications so compatible clients can publish diagnostics for more than the current buffer.
- It runs once per client and only if the client supports open/close sync, diagnostics, and declares `filetypes`.
- No current call site was found in this config, so it currently looks unused.

**Python ftplugin extras**
- `after/ftplugin/python.lua` clears `keywordprg` and adds buffer-local `<leader>cR`.
- `<leader>cR` runs `ruff check --output-format=json .`, aggregates affected files into quickfix items, and tries to open both Trouble diagnostics and a Trouble quickfix pane.
- That helper still contains multiple `DEBUG` notifications / `print()` calls, so it reads like active tooling plus leftover debugging instrumentation.

| Plugin | Purpose | Key Bindings |
|--------|---------|--------------|
| `mason-org/mason.nvim` | Package manager for LSP servers, linters, formatters | `:Mason` |
| `stevearc/conform.nvim` | Autoformatting on save | `<leader>f` (via LSP format fallback) |
| `ruff` (LSP) | Python linting + fast formatting | auto-attached |
| `ty` (LSP) | Astral ty Python type checker | auto-attached |
| `lua_ls` | Lua language server | auto-attached |
| `clangd` | C/C++ language server | auto-attached |
| `lazydev.nvim` | Neovim Lua API completions for config editing | auto |

**Shared LSP keymaps (on_attach):** documented in the table above.

**Diagnostic config:** floating rounded borders, `update_in_insert = false`, severity sort enabled.

**User commands:** `LspStart`, `LspStop [name]`, `LspRestart`, `LspLog`, `LspInfo`

---

### Debugging (DAP)

- No `dap.listeners` hooks are defined in these debugging files, so there is no automatic DAP UI open/close on `event_initialized`, `event_terminated`, or `event_exited`.
- `<F1>` is mapped to `require("dapui").toggle({ layout = 1 })` only. So the "opens too much" behavior is **not** caused by auto-hooks here and **not** because all three layouts are opened; layout 1 itself is a multi-pane left sidebar containing scopes, breakpoints, stacks, and watches.
- `nvim-dap-virtual-text` calls bare `require("nvim-dap-virtual-text").setup()`, so it uses plugin defaults only; no custom options are set in this repo.
- `trouble.nvim` is only configured for diagnostics navigation in its default mode: `[t` previous item, `]t` next item, `<leader>xx` toggles `Trouble diagnostics`.
- The C++ setup is split across two files: `nvim-dap-cpp.lua` only ensures Mason installs `cpptools`, while `cpp.lua` defines the `cppdbg` adapter plus two C++ configurations (`Launch file`, `Attach to gdbserver :1234`).
- Python debugging is set up through Mason-managed `debugpy`; this file does not define custom `dap.configurations.python`, but it exposes helpers to debug the current test class, test method, or visual selection.

| Plugin | Purpose |
|--------|---------|
| `mfussenegger/nvim-dap` | Core Debug Adapter Protocol client |
| `rcarriga/nvim-dap-ui` | UI panels (scopes, breakpoints, stacks, watches, REPL, console) |
| `mfussenegger/nvim-dap-python` | Python debugger (debugpy) |
| `Mason cpptools` + local `cpp.lua` | C++ installer + `cppdbg` adapter/config |
| `theHamsta/nvim-dap-virtual-text` | Inline virtual text for variable values |
| `folke/trouble.nvim` | Diagnostics, quickfix, LSP references list |

**DAP Keymaps:**

| Key | Action |
|-----|--------|
| `<F5>` | Continue |
| `<F10>` | Step over |
| `<F11>` | Step into |
| `<F12>` | Step out |
| `<leader>b` | Toggle breakpoint |
| `<F1>` | Toggle DAP UI layout 1 (left sidebar: scopes/breakpoints/stacks/watches) |
| `<leader>db` | Toggle DAP UI layout 2 (bottom: REPL + console) |
| `<leader>dp` | Toggle DAP UI layout 3 (left: console 70% / REPL 30%) |
| `<leader>dr` | Reset DAP UI layout |
| `<leader>dc` | Floating console |
| `<leader>ds` | Floating scopes |
| `<leader>dt` | Floating REPL |
| `<leader>de` | Evaluate expression (n/v) |
| `<leader>duc` | Debug unittest class (Python) |
| `<leader>dum` | Debug unittest method (Python) |
| `<leader>dus` | Debug selection (Python, visual) |

**DAP UI Layouts:**
- Layout 1 (left, 20% width): scopes, breakpoints, stacks, watches
- Layout 2 (bottom, 30% height): REPL, console
- Layout 3 (left, 30% width): console (70%) + REPL (30%)

**Detailed layout analysis:**
- **Layout 1** — opened by `<F1>` via `dapui.toggle({ layout = 1 })`; left sidebar, `size = 0.2`; elements are `scopes`, `breakpoints`, `stacks`, `watches`. This is why `<F1>` can feel like it opens "too much": it opens one layout with four stacked sections.
- **Layout 2** — opened by `<leader>db` via `dapui.toggle({ layout = 2 })`; bottom tray, `size = 0.3`; elements are `repl` and `console`.
- **Layout 3** — opened by `<leader>dp` via `dapui.toggle({ layout = 3 })`; left sidebar, `size = 0.30`; it splits `console` (70%) above `repl` (30%) inside the same sidebar.
- **Reset behavior** — `<leader>dr` calls `dapui.open({ reset = true })` without a layout index, so it is the only DAP UI keymap here that is not limited to a single layout.

---

### Completion & AI

- **blink.cmp sources:** default = `lsp`, `path`, `snippets`, `buffer`, `copilot`; `per_filetype.codecompanion = { 'codecompanion' }`, so CodeCompanion buffers replace the normal source stack instead of merging with it.
- **Explicit provider settings:** `buffer.min_keyword_length = 1`; `path.min_keyword_length = 0`; `copilot = { module = 'blink-cmp-copilot', score_offset = 100, async = true }`. No custom `score_offset` / `min_keyword_length` / `async` settings are defined for `lsp`, `snippets`, or `codecompanion`, so those use plugin defaults.
- **LuaSnip wiring:** `snippets.expand = require('luasnip').lsp_expand`; `snippets.active(filter)` uses `luasnip.jumpable(filter.direction)` when a direction is supplied, otherwise `luasnip.in_snippet()`; `snippets.jump(direction)` calls `luasnip.jump(direction)`. Friendly-snippets are loaded via `luasnip.loaders.from_vscode().lazy_load()`.
- **`<Tab>` / `<S-Tab>` behavior:** the custom handlers check `cmp.is_visible()` first, then fall back to `luasnip.locally_jumpable(±1)`, then to Blink fallback. Result: if the completion menu is open while inside a snippet, Tab/Shift-Tab move the completion selection instead of jumping snippet nodes. In the current config this is fixable by reordering the checks to prefer snippet jumps before menu navigation (or by explicitly testing snippet activity first).
- **Docs popup behavior:** `completion.documentation.auto_show = false` with `auto_show_delay_ms = 0`; docs are therefore manual-only despite the zero delay. `<C-Space>` is bound to `show`, `show_documentation`, `hide_documentation`, so documentation must be explicitly toggled. This likely avoids popup noise, but it also means completion items never reveal docs automatically.
- **Ghost text vs Copilot:** Blink ghost text is enabled (`completion.ghost_text.enabled = true`), but the active Copilot spec in `text_editing/copilot.lua` sets `suggestion.enabled = false` and `panel.enabled = false`. That means Copilot inline suggestions are intentionally disabled, so Blink's ghost text is the only inline UI and the usual Blink-vs-Copilot ghost-text conflict is mostly avoided.
- **Copilot ranking impact:** `score_offset = 100` gives the Copilot source a large ranking boost, so Copilot candidates are very likely to float above LSP/buffer/path items whenever they are present.
- **Which Copilot spec loads:** `init.lua` imports `dudzie.text_editing`, but there is no import of `dudzie.plugins`; repo-wide grep only found the duplicate spec at `lua/dudzie/plugins/copilot.lua`, not any loader for that directory. So `lua/dudzie/plugins/copilot.lua` appears to be dead/unused, while `lua/dudzie/text_editing/copilot.lua` is the active Copilot config.
- **CodeCompanion prompts:** `lua/dudzie/text_editing/prompts/pydoc.md` exists (the `find` command returns only this file). It defines slash command `/pydoc`, `interaction: inline`, adapter `copilot` with model `gpt-4.1`, visual mode only, and a prompt for Google-style Python docstrings with modern Python 3.12+ typing.
- **CodeCompanion keymaps:** plugin-local keymap only: visual `<leader>cp` → `<cmd>CodeCompanion /pydoc<CR>`. Repo-wide search found no additional global `CodeCompanion` or Copilot keymaps outside this spec; the history extension separately uses `gh` inside chat buffers.
- **Other completion UI details:** completion menu auto-shows, rounded borders are used for both menu/docs, preselect is disabled, and `auto_insert = false`, so items are not inserted just by moving selection.

| Plugin | Purpose |
|--------|---------|
| `saghen/blink.cmp` | Completion engine (replaces nvim-cmp) |
| `L3MON4D3/LuaSnip` | Snippet engine |
| `rafamadriz/friendly-snippets` | Pre-built VSCode-style snippet collection |
| `zbirenbaum/copilot.lua` | GitHub Copilot integration (inline suggestion backend) |
| `giuxtaposition/blink-cmp-copilot` | Copilot source for blink.cmp |
| `olimorris/codecompanion.nvim` | AI chat/assistant (Copilot adapter) |
| `ravitemer/codecompanion-history.nvim` | Persistent chat history for CodeCompanion |

**Completion sources (default):** `lsp`, `path`, `snippets`, `buffer`, `copilot`
**Completion sources (codecompanion buffers):** `codecompanion`

**Completion Keymaps:**

| Key | Action |
|-----|--------|
| `<C-Space>` | Show completion / show/hide docs |
| `<C-e>` | Hide completion menu |
| `<C-d>` | Scroll docs up |
| `<C-f>` | Scroll docs down |
| `<CR>` | Accept completion |
| `<Tab>` | Next item (if menu visible) / LuaSnip jump forward |
| `<S-Tab>` | Prev item (if menu visible) / LuaSnip jump backward |

**AI / CodeCompanion Keymaps:**

| Key | Action |
|-----|--------|
| `<leader>cp` | Generate Python docstring (visual, CodeCompanion) |

---

### Appearance & UI

- **gruvbox-material:** forced dark variant via `vim.o.background = "dark"`; contrast preset is `gruvbox_material_background = "hard"`; `gruvbox_material_transparent_background = 1` keeps window backgrounds transparent. Bold, italics, and `gruvbox_material_better_performance = 1` are also enabled.
- **lualine layout:** `lualine_a = { 'mode' }`, `lualine_b = { 'branch', 'diff', 'diagnostics' }`, `lualine_c = { 'filename' }`, `lualine_x = { spinner?, Copilot, 'encoding', 'fileformat', 'filetype' }`, `lualine_y = { 'progress' }`, `lualine_z = { 'location' }`.
- **Copilot lualine component:** renders icon `` only when `vim.lsp.get_clients({ name = "copilot", bufnr = 0 })` finds an attached client for the current buffer. Colour logic maps `copilot.api.status.data.status` as `InProgress` → orange, `Warning` → red, everything else → green. Edge case: unhandled states still look healthy/green, while "not attached yet" and "disabled" both render as nothing.
- **CodeCompanion spinner:** `lua/dudzie/components/codecompanion_spinner.lua` extends `lualine.component`, cycles braille frames `⠋…⠏`, and is prepended to `lualine_x` only if `require('dudzie.components.codecompanion_spinner')` succeeds. It creates augroup `CodeCompanionLualineHooks` and listens to `User` autocmds matching `CodeCompanionRequest*`, toggling on `CodeCompanionRequestStarted` and off on `CodeCompanionRequestFinished`.
- **snacks.nvim:** enabled modules are `bigfile`, `dashboard`, `quickfile`, `scope`, and `words`; disabled modules are `animate`, `explorer`, `indent`, `input`, `picker`, `notifier`, `scroll`, and `statuscolumn`. Based on the rest of the config, the disabled set appears intentional: `explorer` overlaps with `mini.files`, `picker` with Telescope, `indent` with `indent-blankline`, `notifier` with Noice + nvim-notify, and `input` would overlap with Noice's command/input takeover.
- **noice.nvim:** overrides `vim.lsp.util.convert_input_to_markdown_lines` and `vim.lsp.util.stylize_markdown`, enables presets `bottom_search`, `command_palette`, `long_message_to_split`, and `lsp_doc_border`, and leaves `inc_rename = false`. It customizes `cmdline_popup` to row 20 / centered / 50% width and customizes `popupmenu` with auto sizing, rounded borders, and `FloatBorder = DiagnosticInfo`. Routes skip bare `written` messages and `msg_show` events of kind `codelldb.debug`, which is the only explicit DAP/noice conflict mitigation in this repo.
- **nvim-notify:** the local config only sets `background_colour = "#000000"`. `timeout`, `render`, and `max_width` are not overridden here, so runtime behaviour falls back to plugin defaults (`timeout = 5000`, `render = "default"`, `max_width = nil`). Because Noice keeps its default `notify`-based message/notification views and `nvim-notify` is installed, `nvim-notify` is the active notification renderer behind Noice's `notify` view in the current stack.
- **todo-comments:** `opts = {}` means the default keyword families remain in effect: `FIX` (`FIXME`, `BUG`, `FIXIT`, `ISSUE`), `TODO`, `HACK`, `WARN` (`WARNING`, `XXX`), `PERF` (`OPTIM`, `PERFORMANCE`, `OPTIMIZE`), `NOTE` (`INFO`), and `TEST` (`TESTING`, `PASSED`, `FAILED`). Highlight/search patterns also stay default: `.*<(KEYWORDS)\s*:` for highlighting and `\b(KEYWORDS):` for ripgrep search. No custom comment types or patterns are added.
- **indent-blankline / ibl:** this config only defines custom rainbow highlight groups and passes them as `indent.highlight`. It does **not** override the plugin's structural defaults, so the indent char remains `▎`, scope highlighting stays enabled, and trailing blank-line guides are still handled by the default whitespace setting `remove_blankline_trail = true`. There is no local override for the older `show_trailing_blankline_indent`-style behaviour.
- **If switching from nvim-notify to snacks.notifier:** enable `notifier = { enabled = true }` in `snacks.lua`, wire `vim.notify` to Snacks, and then rework Noice away from its `notify` view (for example, use `mini`/`split` views for messages or disable Noice's notify routing). As written, `snacks.notifier` is **not** a drop-in replacement because Noice currently assumes a notify-style backend while `nvim-notify` is the only one installed/configured for that role.

| Plugin | Purpose |
|--------|---------|
| `sainnhe/gruvbox-material` | Colorscheme |
| `nvim-lualine/lualine.nvim` | Status line |
| `folke/snacks.nvim` | Dashboard, bigfile handling, scope highlight, word highlight, quickfile |
| `folke/noice.nvim` | Replaces cmdline, messages, popupmenu UI |
| `rcarriga/nvim-notify` | Notification backend |
| `folke/todo-comments.nvim` | Highlights TODO/FIXME/NOTE/HACK etc. |
| `lukas-reineke/indent-blankline.nvim` | Indent guides |

**Snacks modules enabled:** `bigfile`, `dashboard`, `quickfile`, `scope`, `words`
**Snacks modules disabled:** `animate`, `explorer`, `indent`, `input`, `picker`, `notifier`, `scroll`, `statuscolumn`

---

### Navigation & Search


| Plugin | Purpose | Key Bindings / Settings |
|--------|---------|-------------------------|
| `nvim-telescope/telescope.nvim` | Fuzzy finder | `<leader>sf` `find_files()`, `<leader>sg` `git_files()`, `<leader>st` prompts for `grep_string()` input |
| `nvim-telescope/telescope-fzf-native.nvim` | Native fzf sorter for Telescope | Built with `make`; no direct keymap |
| `ThePrimeagen/harpoon` | Quick file marks | `<leader>a` add current file, `<C-e>` toggle quick menu, `<C-h>` next mark, `<C-t>` previous mark; no direct `1/2/3/4` slot keymaps configured |
| `nvim-mini/mini.files` | File explorer | `<leader>of` → `MiniFiles.open()`; `setup()` uses defaults only |
| `folke/which-key.nvim` | Keybinding hint popup | `timeout = true`, `timeoutlen = 300`, `setup{}` defaults only; no registered groups for `<leader>s`, `<leader>d`, etc. |
| `christoomey/vim-tmux-navigator` | Navigate between Neovim splits and tmux panes | Default plugin mappings disabled via `vim.g.tmux_navigator_no_mappings = 1`; custom normal-mode maps: `<A-Left>`, `<A-Down>`, `<A-Up>`, `<A-Right>` |

**Telescope configuration:** `file_ignore_patterns` skips `.git/`, `miniconda3/`, `.cache`, common build/binary/media files (`%.o`, `%.a`, `%.out`, `%.class`, `%.pdf`, `%.mkv`, `%.jpg`, `%.png`, `%.mp4`, `%.opsf`, `%.mhd`, `%.zip`), Python caches, and imaging/data outputs (`__pycache__`, `.npy`, `.nrrd`, `.nii.gz`, `.nii`).

**Keymap audit:** no normal-mode collisions inside this navigation/settings scope. The only overlaps are cross-mode (`<C-e>`, `<C-d>`, `<C-f>` in blink insert-mode vs normal-mode navigation/editing). Harpoon's `<C-h>` does **not** clash with vim-tmux-navigator because that plugin's defaults are explicitly disabled.

**Global keymaps (`keymaps.lua`):**

| Mode | Key | Action | Description / Notes |
|------|-----|--------|---------------------|
| `n` | `<leader><leader>x` | `:source %` | Reload current file; no `desc` set |
| `n` | `<leader>=` | `:Neoformat` | **Stale**: Neoformat is not installed |
| `n` | `<C-l>` | `:nohl<CR><C-l>:echo "Search Cleared"<CR>` | Clear search highlight, redraw, echo status; no `desc` |
| `x` | `<leader>p` | `"_dP` | Paste over selection without yanking replaced text |
| `n,v` | `<leader>y` | `"+y` | Yank to system clipboard |
| `n` | `<leader>Y` | `"+Y` | Yank current line to system clipboard |
| `n` | `J` | `mzJ\`z` | Join lines while restoring cursor position |
| `n` | `<C-d>` | `<C-d>zz` | Half-page down, recenter |
| `n` | `<C-u>` | `<C-u>zz` | Half-page up, recenter |
| `n` | `n` | `nzzzv` | Next search result, recenter, reopen folds |
| `n` | `N` | `Nzzzv` | Previous search result, recenter, reopen folds |
| `n` | `<S-Up>` | `:m-2<CR>==` | Move current line up |
| `n` | `<S-Down>` | `:m+<CR>==` | Move current line down |
| `i` | `<S-Up>` | `<Esc>:m-2<CR>==gi` | Move current line up and return to insert mode |
| `i` | `<S-Down>` | `<Esc>:m+<CR>==gi` | Move current line down and return to insert mode |
| `v` | `<S-Up>` | `:m '<-2<CR>gv=gv` | Move selection up and reindent |
| `v` | `<S-Down>` | `:m '>+1<CR>gv=gv` | Move selection down and reindent |
| `n` | `Q` | `<nop>` | Disable Ex-mode entry |
| `n` | `<C-f>` | `silent !tmux neww tmux-sessionizer` | Open `tmux-sessionizer` in a new tmux window |
| `n` | `<leader>f` | `vim.lsp.buf.format` | Manual format via built-in LSP API; no `desc` |
| `n` | `<leader>qr` | `:%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI` | `[Q]uick [R]eplace` scaffold for word under cursor |
| `n` | `<leader>x` | `!chmod +x %` | `Make e[X]ecutable` |

**Core editor settings (`set.lua`):**

| Option | Value | Notes |
|--------|-------|-------|
| `number` | `true` | Absolute line numbers |
| `relativenumber` | `true` | Relative line numbers enabled |
| `tabstop` / `softtabstop` / `shiftwidth` | `4` | Python-friendly 4-space indentation |
| `expandtab` | `true` | Tabs become spaces |
| `smartindent` | `true` | Auto-indent new lines |
| `wrap` | `false` | No soft wrapping |
| `swapfile` / `backup` | `false` | Disable swap + backup files |
| `undodir` | `$HOME/.vim/undodir` | Persistent undo directory |
| `undofile` | `true` | Persistent undo enabled |
| `hlsearch` | `false` | Search matches not persistently highlighted |
| `incsearch` | `true` | Incremental search enabled |
| `showmatch` | `true` | Briefly jump to matching bracket |
| `termguicolors` | `true` | 24-bit color UI |
| `scrolloff` | `8` | Keep context around cursor |
| `signcolumn` | `"yes"` | Always show sign column |
| `isfname += "@-@"` | appended | Treat `@-@` as filename chars |
| `updatetime` | `50` | Aggressive update interval |
| `colorcolumn` | `"120"` | 120-column guide |

**Python save hook:** `BufWritePre *.py` runs `vim.lsp.buf.code_action()` with `source.fixAll.ruff` and `apply = true`, so Ruff fix-alls are attempted automatically before saving Python files.

---

### Version Control

**vim-fugitive keymaps / commands**

| Key | Mode | Command | Description |
|-----|------|---------|-------------|
| `<leader>gs` | `n` | `:Git` | Opens Fugitive's main Git status / command interface (`[G]it [S]tart`). |

_No additional Fugitive commands are explicitly configured in this repo; the rest comes from Fugitive defaults inside its own buffers._

| Plugin | Purpose | Key Bindings |
|--------|---------|--------------|
| `tpope/vim-fugitive` | Git integration | `<leader>gs` → `:Git` |

---

### Miscellaneous

**Detailed configuration**

| Item | Trigger / Scope | Configuration | Notes |
|------|-----------------|---------------|-------|
| `nvim-treesitter/nvim-treesitter` | auto; `:TSUpdate` build step | `ensure_installed = { c, cpp, lua, vim, vimdoc, query, markdown, markdown_inline, python, json, yaml }`; `auto_install = false`; `highlight.enable = true`; large files over 100 KB disable Treesitter highlighting; `additional_vim_regex_highlighting = false` | Good core coverage for Python/C++ source files, but not comprehensive for adjacent tooling such as `cmake`, `bash`, `toml`, `rst`, `diff`, or `gitcommit`. No `indent`, `incremental_selection`, or `textobjects` modules are configured. |
| `mbbill/undotree` | `<leader>ut` | `:UndotreeToggle` | Default setup only; no additional options beyond the toggle keymap. |
| `m4xshen/hardtime.nvim` | eager spec (`lazy = false`) but disabled | `enabled = false`, `opts = {}`, depends on `nui.nvim` | Intended to discourage inefficient repetitive movement / edit habits via plugin defaults, but it currently cannot interfere with DAP, Trouble, Fugitive, or other workflows because it never loads. No custom excluded filetypes or workflows are configured. |
| `nvzone/typr` | `:Typr`, `:TyprStats` | `opts = {}`; depends on `nvzone/volt` | Command-triggered typing practice extra; no keymaps. Non-essential/fun utility. |
| `Eandrju/cellular-automaton.nvim` | `<leader>fml` | `:CellularAutomaton make_it_rain` | Pure visual effect / fun extra; not essential to editing. |
| `folke/lazydev.nvim` | any Lua buffer (`ft = "lua"`) | Adds Lua LSP helper libraries: `luvit-meta/library` when `vim.uv` is referenced, plus typed definitions for `nvim-dap-ui`; companion plugin `Bilal2453/luvit-meta` is lazy-loaded | Filetype-scoped rather than path-scoped, so it is not limited to this Neovim config; it activates in any Lua buffer. |
| `dudzie.components.codecompanion_spinner` | statusline component in `lualine_x` | Extends `lualine.component`; returns empty status if `codecompanion` is unavailable; creates augroup `CodeCompanionLualineHooks`; listens for `User` autocmds matching `CodeCompanionRequest*`; sets `processing = true` on `CodeCompanionRequestStarted` and `false` on `CodeCompanionRequestFinished`; cycles 10 braille spinner glyphs in `update_status()` | `appearance/lualine.lua` inserts this component at index 1 of `lualine_x`, before Copilot/encoding/fileformat/filetype, so the spinner only appears while CodeCompanion is actively processing. |
| `after/ftplugin/python.lua` | Python buffers only | Clears `keywordprg`; defines buffer-local `<leader>cR` to run asynchronous `ruff check --output-format=json .`, aggregate results by file, populate quickfix, and open Trouble (diagnostics bottom split + quickfix left split) or native quickfix fallback | Does not conflict with LSP hover because `K` is provided by `lsp/utils/on_attach.lua`; it complements LSP with a workspace-level Ruff scan. Main caveats are leftover `DEBUG` notifications/prints and reliance on external `ruff` CLI + `trouble.nvim`. |

| Plugin | Purpose |
|--------|---------|
| `nvim-treesitter/nvim-treesitter` | Syntax highlighting, code navigation |
| `mbbill/undotree` | Visualise undo history |
| `lukas-reineke/indent-blankline.nvim` | Indent guides (also in Appearance) |
| `m4xshen/hardtime.nvim` | Disabled bad-habit trainer (inactive) |
| `nvzone/typr` | In-editor typing speed practice |
| `Eandrju/cellular-automaton.nvim` | Fun screen animation (`make_it_rain`) |
| `folke/lazydev.nvim` | Lua LSP type annotations for Neovim config |

---

## Implemented & Working

### LSP / language support

- **Shared LSP foundation:** `vim.lsp.config["*"]` centralizes `on_attach`, blink-enhanced capabilities, diagnostic UI defaults, and user commands such as `LspStart`, `LspStop`, `LspRestart`, `LspLog`, and `LspInfo`.
- **Daily LSP workflow is well covered:** Telescope-backed definitions / implementations / references, hover, rename, code actions, CodeLens, inlay-hint toggling, and diagnostic navigation are all already wired.
- **Language coverage matches the stated focus:** Python (`ruff` + `ty`), Lua (`lua_ls`), and C/C++ (`clangd`) auto-attach, with extra clangd helpers for switching source/header files and showing symbol info.
- **Python-specific workflows exist today:** `BufWritePre *.py` triggers Ruff `source.fixAll`, and buffer-local `<leader>cR` runs a workspace Ruff scan and pushes results into Trouble / quickfix.

### Debugging

- **Python DAP is usable out of the box:** `nvim-dap-python` is set up through Mason-managed `debugpy`, including helpers for unittest class, method, and visual-selection debugging.
- **C++ DAP is wired end to end:** `nvim-dap-cpp.lua` ensures `cpptools` is installed, while `cpp.lua` defines the `cppdbg` adapter plus `Launch file` and `Attach to gdbserver :1234` configurations.
- **The DAP UI is explicit and manual:** three named layouts are available (`<F1>`, `<leader>db`, `<leader>dp`), plus floating console / scopes / REPL helpers.
- **Debug visibility is strong:** inline variable values come from `nvim-dap-virtual-text`, and Trouble is available for diagnostics navigation with `<leader>xx`, `[t`, and `]t`.

### Completion / AI

- **Completion stack is modern:** `blink.cmp` is the primary engine with `lsp`, `path`, `snippets`, `buffer`, and `copilot` sources, plus ghost text and manual documentation controls.
- **Snippets are integrated:** LuaSnip and friendly-snippets are loaded, and `<Tab>` / `<S-Tab>` support both completion navigation and snippet jumps.
- **AI tooling is coherent:** CodeCompanion uses the Copilot adapter, stores history, exposes a custom `/pydoc` prompt on `<leader>cp`, and shows a dedicated lualine spinner while requests are running.
- **Copilot UI conflicts are intentionally avoided:** the active Copilot config disables Copilot's own inline suggestion UI and panel so Blink remains the single visible inline completion surface.

### Navigation / UI / editor experience

- **Navigation is fast and conflict-light:** Telescope + `fzf-native`, Harpoon, `mini.files`, and custom `<A-Left/Down/Up/Right>` tmux-navigation mappings coexist without any hard normal-mode key collisions.
- **The UI stack is cohesive:** gruvbox-material, lualine, Noice, and `nvim-notify` already work together, with quieter messaging thanks to filtered `written` and `codelldb.debug` noise.
- **Core editor defaults are sensible for Python-heavy work:** 4-space indentation, persistent undo, relative numbers, `scrolloff = 8`, `signcolumn = "yes"`, and `colorcolumn = "120"` make the base editing experience predictable.
- **Supporting tools are in place:** snacks dashboard modules, Treesitter highlighting, todo-comments, Fugitive (`<leader>gs`), Undotree (`<leader>ut`), lazydev for Lua buffers, and optional extras like `:Typr` and `<leader>fml` are all wired and available.

---

## Known Pain Points & TODOs

### Formatting and Python workflow gaps

- **Formatting is inconsistent on paper vs runtime:** `conform.nvim` is configured for Lua / Python / C++ but the plugin spec is `enabled = false`, so the real active path is manual `vim.lsp.buf.format` plus Ruff fix-alls on Python save.
- **Python environment activation still looks unwired:** no call site was found for `venv.lua`, so `PATH` / `VIRTUAL_ENV` switching may never happen before Python LSP clients start.
- **Python LSP setup still depends on outside state:** `ty` is enabled but not Mason-managed, so the current Python server stack is not fully self-provisioning.
- **The Python ftplugin needs a cleanup pass:** `<leader>cR` is useful, but `after/ftplugin/python.lua` still contains `DEBUG` notifications / `print()` calls around Trouble loading and fallback handling.

### DAP behavior

- **`<F1>` feels bigger than its label suggests:** it only toggles layout 1, but that single layout already stacks scopes, breakpoints, stacks, and watches into one 20%-width left sidebar.
- **There are no DAP auto-open/close listeners in the current debug files:** if panels seem to appear too aggressively, `<leader>dr` (`dapui.open({ reset = true })`) is the more likely culprit than hidden `dap.listeners` hooks.
- **`nvim-dap-virtual-text` is still running on defaults only:** if inline values feel too noisy or not informative enough, the next step is explicit plugin options rather than hunting for missing local config.

### Completion ergonomics

- **Blink snippet jumping is awkward when completion is visible:** `<Tab>` checks `cmp.is_visible()` before LuaSnip, so active snippet jumps lose to the completion menu unless you hide it first.
- **Completion docs are fully manual right now:** `completion.documentation.auto_show = false` means `<C-Space>` is required to see item docs.
- **Copilot suggestions are heavily prioritized:** `providers.copilot.score_offset = 100` makes Copilot candidates dominate ranking more often than local LSP / snippet / buffer matches.

### UI integration rough edges

- **Notification startup is inconsistent:** Noice loads on `VeryLazy`, and `nvim-notify.lua` does not assign `vim.notify` early, so very early notifications can still use stock `vim.notify`.

---

## Redundant / Outdated

### Config leftovers worth pruning or renaming

- **`lua/dudzie/debugging/nvim-dap-cpp.lua`** is named like a full C++ DAP setup file, but in practice it only ensures `cpptools`; the actual `cppdbg` adapter/configuration lives in `cpp.lua`.

### Thin or intentionally inactive wrappers

- **`m4xshen/hardtime.nvim`** is present but explicitly disabled, so it is inactive weight unless it will be re-enabled.
- **`lua/dudzie/appearance/nvim-notify.lua`** is a very thin wrapper that only overrides `background_colour`.
- **Disabled Snacks replacements** (`explorer`, `picker`, `indent`, `notifier`) are intentionally dormant because this config already chose `mini.files`, Telescope, ibl, and Noice + `nvim-notify` for those roles.

### ✅ Already resolved (2026-05)

The following issues from the initial review have been fixed:
- `lua/dudzie/plugins/copilot.lua` — deleted (was dead duplicate)
- `lua/dudzie/lsp/utils/workspace_diagnostic.lua` — deleted (was basedpyright helper, never called)
- `lua/dudzie/lsp/utils/venv.lua` — deleted (was basedpyright helper, never called)
- `lsp/pyrefly.lua` — deleted (never enabled or Mason-managed)
- `<leader>=` → `:Neoformat` keymap — removed (Neoformat not installed)
- `basedpyright` in Mason `ensure_installed` — removed; `ty`, `stylua`, `prettier`, `debugpy` added
- Dead `basedpyright` handler block in `on_attach.lua` — removed
- Noisy LSP-connected notification in `on_attach.lua` — removed
- `DEBUG:` print/notify calls in `after/ftplugin/python.lua` — removed
- Inert `auto_trigger`/`hide_during_completion` in `text_editing/copilot.lua` — removed
- `blink.cmp` Tab/S-Tab now prioritize active LuaSnip jump over menu navigation
- `blink.cmp` documentation auto-show enabled (500ms delay)
- `conform.nvim` enabled with `json` + `markdown` → `prettier` formatters added

---

## Ideas & Wishlist

### Workflow polish

- Give `mini.files` a stronger daily-driver setup: reveal-current-file, hidden-file toggles, split / vsplit targets, and a few custom window mappings.
- Allow searching of files hidden by .gitignore (but still not .venv)
- Add explicit top-level CodeCompanion chat / actions / history keymaps beyond the current visual-only `<leader>cp` docstring helper.
- Consider `vim.opt.clipboard = "unnamedplus"` if system clipboard access should feel native instead of mapping-driven.

### Debugging and testing

- Easier opening/closing. F1 shouldn't open the whole thing because of the stacked windows.
- Add named `dap.configurations.python` entries for repeatable file / module / pytest launches.

### Ecosystem additions

- Add `gitsigns.nvim` for inline gutter diff markers alongside Fugitive.
- Add `telescope-ui-select` if replacing `vim.ui.select` with Telescope would be useful.
- Expand Treesitter parser coverage for tooling files such as `cmake`, `toml`, `bash`, `rst`, `diff`, `gitcommit`, and `dockerfile`.

### UI / maintenance direction

- Restrict lazydev by project root/path so it does not activate in every Lua buffer.
- Decide on one scope-highlighting source (`snacks.scope` vs ibl) and one long-term notification story (`nvim-notify` vs `snacks.notifier`).
- Expand the Copilot lualine indicator so it distinguishes ready, disabled, offline, and unknown states more clearly.
- If hardtime is ever re-enabled, add explicit exclusions for DAP, Trouble, quickfix, Fugitive, TelescopePrompt, and Undotree buffers first.

---

*This document is auto-generated from a review of the config as of 2026-05. It should be updated as the config evolves.*

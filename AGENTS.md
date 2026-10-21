# AGENTS.md

Repo-specific guidance for coding agents working in this repository.

## What This Repo Is

Personal dotfiles repository for macOS. Manages configuration for: zsh, Ghostty terminal, Neovim, Claude Code, OpenAI Codex CLI, Pi, VS Code, and iTerm2. Muse reads the Claude Code instructions on its own.

## Installation

```bash
./install.sh
```

This creates symlinks from `$HOME` into this repo. Existing non-symlink files are backed up to `~/.dotfiles_backup/<timestamp>/`.

iTerm2 is not symlinked — it syncs via its own preferences mechanism. The plist is stored here for reference.

## Symlink Map

| Repo path | Symlink target |
|---|---|
| `zshrc` | `~/.zshrc` |
| `p10k.zsh` | `~/.p10k.zsh` |
| `ghostty/` | `~/.config/ghostty` |
| `nvim/` | `~/.config/nvim` |
| `agents/AGENTS.md` | `~/.claude/CLAUDE.md` |
| `claude/settings.json` | `~/.claude/settings.json` |
| `claude/statusline.sh` | `~/.claude/statusline.sh` |
| `agents/skills/profile-python/SKILL.md` | `~/.claude/skills/profile-python/SKILL.md` |
| `claude/rules/*.md` | `~/.claude/rules/*.md` |
| `agents/AGENTS.md` | `~/.codex/AGENTS.md` |
| `codex/rules/safety.rules` | `~/.codex/rules/safety.rules` |
| `agents/AGENTS.md` | `~/.pi/agent/AGENTS.md` |
| `agents/skills/profile-python/SKILL.md` | `~/.pi/agent/skills/profile-python/SKILL.md` |
| `vscode/settings.json` | `~/Library/Application Support/Code/User/settings.json` |
| `vscode/keybindings.json` | `~/Library/Application Support/Code/User/keybindings.json` |

## Key Conventions

- **`agents/AGENTS.md`** is the global instructions file for every harness: Claude Code (`~/.claude/CLAUDE.md`), Codex (`~/.codex/AGENTS.md`), Pi (`~/.pi/agent/AGENTS.md`), and Muse (which falls back to `~/.claude/CLAUDE.md`). Keep it tool-agnostic. This repo's root `AGENTS.md` (this file) is repo-specific.
- **`agents/`** holds everything shared across harnesses; **`claude/`** and **`codex/`** hold tool-specific config (e.g., `claude/statusline.sh` reads Claude Code's status line JSON).
- **`claude/rules/`** holds domain-specific rules. Claude Code loads `~/.claude/rules/*.md` automatically, so they don't need to be referenced from the instructions file. Other harnesses don't read them.
- Config files are the source of truth — edit them here, then run `install.sh` or rely on existing symlinks.
- **`nvim/`** is the Neovim configuration (used with Neovide GUI). Uses lazy.nvim for plugin management, Tokyo Night theme, LSP via Mason, Telescope, nvim-tree, and Treesitter. Leader key is Space.
- **`ghostty/config`** is the Ghostty terminal configuration. It defines keybindings for macOS-style copy/paste, tab/split-pane management, font size, scrolling, and word/line navigation (Option+arrows and Cmd+arrows send escape sequences to the shell).

## When Adding New Dotfiles

1. Add the config file to this repo
2. Add a `link` call in `install.sh` (or `mkdir -p` + `link` for nested paths)
3. For Claude Code files, individual files are linked (not the whole `~/.claude` directory) to preserve session data
4. A `post-commit` git hook (in `hooks/`) auto-runs `install.sh` after each commit, so new symlinks are picked up automatically

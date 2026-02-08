# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

Personal dotfiles repository for macOS. Manages configuration for: zsh, Ghostty terminal, Claude Code, VS Code, Emacs, and iTerm2.

## Installation

```bash
./install.sh
```

This creates symlinks from `$HOME` into this repo. Existing non-symlink files are backed up to `~/.dotfiles_backup/<timestamp>/`. The emacs.d directory is special-cased: if `~/.emacs.d` has its own git repo, install.sh prints a manual copy command instead of symlinking.

iTerm2 is not symlinked — it syncs via its own preferences mechanism. The plist is stored here for reference.

## Symlink Map

| Repo path | Symlink target |
|---|---|
| `zshrc` | `~/.zshrc` |
| `p10k.zsh` | `~/.p10k.zsh` |
| `ghostty/` | `~/.config/ghostty` |
| `claude/CLAUDE.md` | `~/.claude/CLAUDE.md` |
| `claude/settings.json` | `~/.claude/settings.json` |
| `claude/statusline.sh` | `~/.claude/statusline.sh` |
| `claude/agents/shipit.md` | `~/.claude/agents/shipit.md` |
| `claude/skills/profile-python/SKILL.md` | `~/.claude/skills/profile-python/SKILL.md` |
| `claude/rules/` | `~/.claude/rules/` |
| `vscode/settings.json` | `~/Library/Application Support/Code/User/settings.json` |
| `vscode/keybindings.json` | `~/Library/Application Support/Code/User/keybindings.json` |

## Key Conventions

- **`claude/CLAUDE.md`** is the global Claude Code instructions file (applies to all projects via `~/.claude/CLAUDE.md`). This repo's `CLAUDE.md` (this file) is repo-specific. Domain-specific rules live in `claude/rules/` (see @claude/rules for details).
- **`claude/agents/shipit.md`** is a custom Claude Code agent for the full git commit/push/PR workflow. It uses `git add -u` only (never `git add .`), never force-pushes, and stops on conflicts.
- Config files are the source of truth — edit them here, then run `install.sh` or rely on existing symlinks.
- **`ghostty/config`** is the Ghostty terminal configuration. It defines keybindings for macOS-style copy/paste, tab/split-pane management, font size, scrolling, and word/line navigation (Option+arrows and Cmd+arrows send escape sequences to the shell).
- The Emacs config (`emacs.d/`) is a modular setup with `init.el` loading individual `lisp/init-*.el` feature files. It may have its own git history at `~/.emacs.d`.

## When Adding New Dotfiles

1. Add the config file to this repo
2. Add a `link` call in `install.sh` (or `mkdir -p` + `link` for nested paths)
3. For Claude Code files, individual files are linked (not the whole `~/.claude` directory) to preserve session data
4. A `post-commit` git hook (in `hooks/`) auto-runs `install.sh` after each commit, so new symlinks are picked up automatically

# Claude Code One-Click Installer

One-command installer that sets up a complete Claude Code development environment on macOS and Windows. Run one line in a terminal, get everything you need installed, no clicks, no prompts.

Designed for non-technical users, students, and anyone who just wants to start using Claude Code without manually wiring up Git, Node, VS Code, and npm.

## Quick Start

### macOS

Open Terminal and paste:

```bash
curl -fsSL https://raw.githubusercontent.com/peleg-jpg/claude-code-installer/main/mac/install.sh | bash
```

### Windows

Open **PowerShell as Administrator** and paste:

```powershell
irm "https://raw.githubusercontent.com/peleg-jpg/claude-code-installer/main/windows/install.bat" -OutFile install.bat; .\install.bat
```

## What Gets Installed

| Tool                                    | Purpose                                            |
| --------------------------------------- | -------------------------------------------------- |
| **Xcode Command Line Tools** (mac only) | Required by Homebrew, git, compilers               |
| **Homebrew** (mac only)                 | macOS package manager                              |
| **Git**                                 | Version control                                    |
| **VS Code**                             | Code editor, pre-configured with sensible defaults |
| **Claude Code VS Code Extension**       | Anthropic's official IDE integration               |
| **nvm** / **nvm-windows**               | Node version manager                               |
| **Node.js (LTS)** + latest **npm**      | JavaScript runtime                                 |
| **Claude Code**                         | Installed globally via npm                         |
| **Bun**                                 | Fast JS runtime, useful for Claude Code workflows  |
| **GitHub CLI** (`gh`)                   | GitHub from the terminal                           |

The installer also writes opinionated VS Code settings (auto-save, format-on-save, no minimap, larger terminal font) and Git defaults (default branch `main`, VS Code as editor, sane rebase + credential helpers per OS).

## Design Goals

- **Zero prompts** — fully automatic
- **Idempotent** — safe to run multiple times, skips what is already installed
- **Smart detection** — version checks before reinstalling
- **Visible progress** — colored step counters and `[OK]` / `[SKIP]` / `[FAIL]` markers
- **Debug mode** — pass `--debug` (mac) or `-debug` (windows) for verbose output

## After Installation

1. Open a **new terminal window** so PATH updates take effect.
2. Run `code` to open VS Code.
3. Open VS Code's integrated terminal (`` Ctrl+` `` on Windows, `` Cmd+` `` on Mac).
4. Run `claude` to start Claude Code.
5. Authenticate on first run.

## Verify

```bash
code --version
git --version
node --version
npm --version
bun --version
gh --version
claude --version
```

## Troubleshooting

- **macOS:** if a dialog appears asking you to install Command Line Tools, click `Install` and wait. Homebrew may ask for your login password.
- **Apple Silicon (M1/M2/M3) and Intel** are both supported.
- **Windows:** if `winget` is unavailable, the installer falls back to direct downloads. Run from elevated PowerShell.
- **Debug mode:**
  - mac: `curl -fsSL ...install.sh | bash -s -- --debug`
  - win: `install.bat -debug`

## Uninstall

### macOS

```bash
curl -fsSL https://raw.githubusercontent.com/peleg-jpg/claude-code-installer/main/mac/uninstall.sh | bash
```

### Windows

```powershell
irm "https://raw.githubusercontent.com/peleg-jpg/claude-code-installer/main/windows/uninstall.bat" -OutFile uninstall.bat; .\uninstall.bat
```

> The macOS uninstaller intentionally keeps Xcode Command Line Tools installed (other system tools depend on them).

## Platform Details

- [macOS README](mac/README.md)
- [Windows README](windows/README.md)

## How It Works

Each platform has the same structure:

```
mac/
  install.sh           # thin launcher (detects local vs. piped-curl mode)
  uninstall.sh         # full uninstaller
  src/
    installer.sh       # actual installation logic
    config.json        # versions, extensions, settings

windows/
  install.bat          # thin launcher
  uninstall.bat
  src/
    installer.ps1
    uninstaller.ps1
    config.json
```

The launcher checks whether `src/installer.*` exists next to it. If yes, it runs locally. If no (the user piped `curl ... | bash`), it downloads `installer.*` and `config.json` to a temp dir and runs them there. This means one command works whether you cloned the repo or pasted a one-liner.

## License

MIT - see [LICENSE](LICENSE).

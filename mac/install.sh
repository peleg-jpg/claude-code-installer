#!/bin/bash
# Claude Code One-Click Installer - macOS Launcher
# Automatically detects local vs remote installation mode
#
# Usage:
#   bash install.sh                    (from cloned repo)
#   bash install.sh --debug            (enable debug output)
#   curl -fsSL "...install.sh" | bash  (single command)

set -euo pipefail

REPO_BASE="https://raw.githubusercontent.com/peleg-jpg/claude-code-installer/main/mac"
DEBUG_MODE=false

# Parse arguments
for arg in "$@"; do
    case "$arg" in
        --debug|-debug) DEBUG_MODE=true ;;
    esac
done

export DEBUG_MODE

echo "========================================"
echo "   Claude Code One-Click Installer"
echo "========================================"
echo ""

# Determine script directory (works for both local and piped execution)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}" 2>/dev/null || echo ".")" && pwd)"

# Check if local files exist
if [[ -f "$SCRIPT_DIR/src/installer.sh" && -f "$SCRIPT_DIR/src/config.json" ]]; then
    echo "Local installation files detected - using cloned repository"
    [[ "$DEBUG_MODE" == "true" ]] && echo "[DEBUG] Local mode, script dir: $SCRIPT_DIR"
    bash "$SCRIPT_DIR/src/installer.sh" "$@"
else
    echo "Downloading installer files..."
    TEMP_DIR=$(mktemp -d)
    trap "rm -rf $TEMP_DIR" EXIT

    mkdir -p "$TEMP_DIR/src"

    [[ "$DEBUG_MODE" == "true" ]] && echo "[DEBUG] Temp dir: $TEMP_DIR"
    [[ "$DEBUG_MODE" == "true" ]] && echo "[DEBUG] Downloading from: $REPO_BASE"

    # raw.githubusercontent.com and codeload both rate-limit unauthenticated
    # IPs (HTTP 429). jsDelivr is an independent CDN and git clone uses yet
    # another endpoint, so chain them: raw -> jsDelivr -> archive -> clone.
    CDN_BASE="https://cdn.jsdelivr.net/gh/peleg-jpg/claude-code-installer@main/mac"

    fetch_file() { # $1 = path relative to mac/, $2 = destination
        curl -fsSL "$REPO_BASE/$1" -o "$2" 2>/dev/null \
            || curl -fsSL "$CDN_BASE/$1" -o "$2" 2>/dev/null
    }

    download_from_archive() {
        echo "Direct downloads failed (GitHub may be rate-limiting). Trying repository archive..."
        curl -fsSL "https://github.com/peleg-jpg/claude-code-installer/archive/main.tar.gz" \
            | tar -xz -C "$TEMP_DIR" 2>/dev/null \
            || git clone -q --depth 1 "https://github.com/peleg-jpg/claude-code-installer" \
                "$TEMP_DIR/claude-code-installer-main" 2>/dev/null \
            || return 1
        cp "$TEMP_DIR/claude-code-installer-main/mac/src/config.json" "$TEMP_DIR/src/config.json" \
            && cp "$TEMP_DIR/claude-code-installer-main/mac/src/installer.sh" "$TEMP_DIR/src/installer.sh"
    }

    if ! { fetch_file "src/config.json" "$TEMP_DIR/src/config.json" \
        && fetch_file "src/installer.sh" "$TEMP_DIR/src/installer.sh"; }; then
        download_from_archive || {
            echo "ERROR: Failed to download installer files from GitHub"
            echo "Please check your internet connection and try again."
            exit 1
        }
    fi

    echo "Files downloaded successfully!"
    echo ""
    # Re-attach a TTY to stdin when piped via curl | bash, so sudo (and any
    # interactive prompts) can read the user's input.
    if [[ ! -t 0 && -e /dev/tty ]]; then
        bash "$TEMP_DIR/src/installer.sh" "$@" < /dev/tty
    else
        bash "$TEMP_DIR/src/installer.sh" "$@"
    fi
fi

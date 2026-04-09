#!/bin/bash
# Install claude-switch
# Works both from a git clone and via: curl -fsSL https://raw.githubusercontent.com/Mamdouh66/claude-switch/main/install.sh | bash
set -e

REPO="Mamdouh66/claude-switch"
BRANCH="main"
INSTALL_DIR="$HOME/.claude-switch"
BIN_DIR="$HOME/.local/bin"
ZSHRC="$HOME/.zshrc"
BASHRC="$HOME/.bashrc"

# Colors
GREEN='\033[0;32m'
DIM='\033[2m'
BOLD='\033[1m'
NC='\033[0m'

echo ""
echo -e "${BOLD}claude-switch${NC} installer"
echo ""

# Detect if running from a local clone or via curl
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}" 2>/dev/null)" 2>/dev/null && pwd)"
if [ -f "$SCRIPT_DIR/claude-switch" ] && [ -f "$SCRIPT_DIR/claude-switch.zsh" ]; then
    MODE="local"
    SOURCE_DIR="$SCRIPT_DIR"
    echo -e "${DIM}Installing from local clone...${NC}"
else
    MODE="remote"
    SOURCE_DIR="$INSTALL_DIR"
    echo -e "${DIM}Downloading from github.com/${REPO}...${NC}"

    mkdir -p "$INSTALL_DIR"
    BASE_URL="https://raw.githubusercontent.com/${REPO}/${BRANCH}"
    curl -fsSL "$BASE_URL/claude-switch"     -o "$INSTALL_DIR/claude-switch"
    curl -fsSL "$BASE_URL/claude-switch.zsh" -o "$INSTALL_DIR/claude-switch.zsh"
    echo -e "  Downloaded to ${DIM}${INSTALL_DIR}${NC}"
fi

# Install binary
mkdir -p "$BIN_DIR"
chmod +x "$SOURCE_DIR/claude-switch"

if [ "$MODE" = "local" ]; then
    ln -sf "$SOURCE_DIR/claude-switch" "$BIN_DIR/claude-switch"
    echo -e "  ${GREEN}Linked${NC} claude-switch → $BIN_DIR/"
else
    cp "$SOURCE_DIR/claude-switch" "$BIN_DIR/claude-switch"
    echo -e "  ${GREEN}Installed${NC} claude-switch → $BIN_DIR/"
fi

# Ensure ~/.local/bin is in PATH
if ! echo "$PATH" | tr ':' '\n' | grep -qx "$BIN_DIR"; then
    echo ""
    echo -e "  ${DIM}Note: $BIN_DIR is not in your PATH.${NC}"
    echo -e "  ${DIM}Add this to your shell config:${NC}"
    echo -e "  ${DIM}  export PATH=\"\$HOME/.local/bin:\$PATH\"${NC}"
fi

# Shell integration
SOURCE_LINE="source $SOURCE_DIR/claude-switch.zsh"

add_shell_integration() {
    local rc_file="$1"
    local shell_name="$2"
    if [ -f "$rc_file" ] || [ "$shell_name" = "zsh" ]; then
        if grep -qF "claude-switch.zsh" "$rc_file" 2>/dev/null; then
            echo -e "  Shell integration already in ${DIM}${rc_file}${NC}"
        else
            {
                echo ""
                echo "# Claude Code profile switcher"
                echo "$SOURCE_LINE"
            } >> "$rc_file"
            echo -e "  ${GREEN}Added${NC} shell integration to ${DIM}${rc_file}${NC}"
        fi
    fi
}

add_shell_integration "$ZSHRC" "zsh"
[ -f "$BASHRC" ] && add_shell_integration "$BASHRC" "bash"

echo ""
echo -e "${GREEN}Done!${NC} Restart your shell or run:"
echo -e "  ${DIM}source ~/.zshrc${NC}"
echo ""
echo "Quick start:"
echo -e "  ${DIM}# Save your current Claude login as a profile${NC}"
echo "  claude-switch save work"
echo ""
echo -e "  ${DIM}# Log into another account, then save it too${NC}"
echo "  claude auth logout && claude auth login"
echo "  claude-switch save personal"
echo ""
echo -e "  ${DIM}# Now switch anytime${NC}"
echo "  c work"
echo "  c personal"
echo "  c status"
echo ""

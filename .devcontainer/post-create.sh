#!/usr/bin/env bash
#
# Amplifier quickstart devcontainer post-create script.
# Runs once after the container is created. It performs everything in the
# Amplifier QuickStart up to (but not including) running `claude`:
#   1. Clone Amplifier (amplifier-claude branch)
#   2. make install  (creates .venv via uv, installs Node deps via pnpm)
#   3. Configure new terminals so the student only needs to type `claude`
#
set -euo pipefail

# Persist logs for troubleshooting (see Amplifier DISCOVERIES.md guidance).
LOG_FILE="/tmp/devcontainer-post-create.log"
exec > >(tee -a "$LOG_FILE") 2>&1

AMPLIFIER_DIR="amplifier"
AMPLIFIER_REPO="https://github.com/microsoft/amplifier.git"
AMPLIFIER_BRANCH="amplifier-claude"

echo "========================================="
echo "Amplifier quickstart post-create  $(date)"
echo "========================================="

# Ensure the persisted ~/.claude volume is writable by the container user.
# Named volumes can mount as root-owned on first creation.
if [ -d "$HOME/.claude" ]; then
  sudo chown -R "$(id -u):$(id -g)" "$HOME/.claude" 2>/dev/null || true
fi

# pnpm needs SHELL set to configure its global bin dir, otherwise `pnpm setup`
# fails with ERR_PNPM_UNKNOWN_SHELL (see Amplifier DISCOVERIES.md).
echo ""
echo "🔧  Configuring pnpm..."
export SHELL="${SHELL:-/bin/bash}"
pnpm setup >/dev/null 2>&1 || true
export PNPM_HOME="${PNPM_HOME:-$HOME/.local/share/pnpm}"
export PATH="$PNPM_HOME:$PATH"
echo "    ✅ pnpm configured"

# Clone Amplifier if it is not already present (idempotent across rebuilds).
echo ""
if [ ! -d "$AMPLIFIER_DIR/.git" ]; then
  echo "⬇️   Cloning Amplifier ($AMPLIFIER_BRANCH branch)..."
  git clone --depth 1 --branch "$AMPLIFIER_BRANCH" "$AMPLIFIER_REPO" "$AMPLIFIER_DIR"
  echo "    ✅ Cloned into ./$AMPLIFIER_DIR"
else
  echo "ℹ️   Amplifier already present; skipping clone."
fi

# Install dependencies. Run from inside the repo so the Makefile sees the
# expected working directory.
echo ""
echo "📦  Running 'make install' (this can take several minutes)..."
( cd "$AMPLIFIER_DIR" && make install )
echo "    ✅ Dependencies installed"

# Make every new terminal land in the Amplifier directory with the virtual
# environment activated, so the student only needs to type `claude`.
echo ""
echo "🔧  Configuring shell so 'claude' works immediately..."
BASHRC="$HOME/.bashrc"
MARKER="# >>> amplifier-quickstart >>>"
if ! grep -qF "$MARKER" "$BASHRC" 2>/dev/null; then
  AMPLIFIER_ABS="$(cd "$AMPLIFIER_DIR" && pwd)"
  {
    echo ""
    echo "$MARKER"
    echo "if [ -d \"$AMPLIFIER_ABS\" ]; then"
    echo "  cd \"$AMPLIFIER_ABS\" || true"
    echo "  [ -f .venv/bin/activate ] && source .venv/bin/activate"
    echo "fi"
    echo "# <<< amplifier-quickstart <<<"
  } >> "$BASHRC"
  echo "    ✅ ~/.bashrc updated"
else
  echo "    ℹ️   ~/.bashrc already configured"
fi

echo ""
echo "========================================="
echo "✅  Ready!  Installed tool versions:"
echo "  • Python : $(python3 --version 2>&1 | cut -d' ' -f2)"
echo "  • uv     : $(uv --version 2>&1)"
echo "  • Node   : $(node --version)"
echo "  • pnpm   : $(pnpm --version)"
echo "  • Git    : $(git --version | cut -d' ' -f3)"
echo "  • Make   : $(make --version 2>&1 | head -n1 | grep -oE '[0-9]+(\.[0-9]+)+' | head -n1)"
echo "  • Claude : $(claude --version 2>&1 || echo 'NOT INSTALLED')"
echo "========================================="
echo ""
echo "👉  Open a NEW terminal, then type:   claude"
echo "    (On first run you'll be prompted to sign in.)"
echo ""
echo "💡  Logs saved to: $LOG_FILE"

#!/usr/bin/env bash
#
# Amplifier クイックスタート用 devcontainer post-create スクリプト。
# コンテナ作成後に一度だけ実行される。Amplifier クイックスタートのうち、
# `claude` を実行する直前までを自動で行う:
#   1. Amplifier (amplifier-claude ブランチ) を clone
#   2. make install (uv で .venv 作成、pnpm で Node 依存を導入)
#   3. 新しいターミナルで `claude` と打つだけで済むようシェルを設定
#
set -euo pipefail

# トラブルシュート用にログを残す (Amplifier の DISCOVERIES.md の指針を参照)。
LOG_FILE="/tmp/devcontainer-post-create.log"
exec > >(tee -a "$LOG_FILE") 2>&1

AMPLIFIER_DIR="amplifier"
AMPLIFIER_REPO="https://github.com/microsoft/amplifier.git"
AMPLIFIER_BRANCH="amplifier-claude"

echo "========================================="
echo "Amplifier quickstart post-create  $(date)"
echo "========================================="

# 永続化した ~/.claude ボリュームをコンテナユーザーが書き込めるようにする。
# 名前付きボリュームは初回作成時に root 所有でマウントされることがある。
if [ -d "$HOME/.claude" ]; then
  sudo chown -R "$(id -u):$(id -g)" "$HOME/.claude" 2>/dev/null || true
fi

# pnpm はグローバル bin ディレクトリ設定に SHELL が必要。未設定だと `pnpm setup`
# が ERR_PNPM_UNKNOWN_SHELL で失敗する (Amplifier の DISCOVERIES.md 参照)。
# さらに make install の `pnpm add -g @anthropic-ai/claude-code` は $PNPM_HOME/bin が
# PATH にないと "global bin directory is not in PATH" で失敗するため、
# pnpm setup の前に PNPM_HOME と PATH（…/bin を含む）を確定させておく。
echo ""
echo "🔧  Configuring pnpm..."
export SHELL="${SHELL:-/bin/bash}"
export PNPM_HOME="${PNPM_HOME:-$HOME/.local/share/pnpm}"
mkdir -p "$PNPM_HOME/bin"
export PATH="$PNPM_HOME:$PNPM_HOME/bin:$PATH"   # $PNPM_HOME/bin も通すのが要点
pnpm setup >/dev/null 2>&1 || true
# 対話シェル（新しいターミナル）でも pnpm のグローバル bin を通す（冪等追記）。
PNPM_MARKER="# >>> pnpm-home >>>"
if ! grep -qF "$PNPM_MARKER" "$HOME/.bashrc" 2>/dev/null; then
  {
    echo ""
    echo "$PNPM_MARKER"
    echo "export PNPM_HOME=\"$PNPM_HOME\""
    echo "export PATH=\"\$PNPM_HOME:\$PNPM_HOME/bin:\$PATH\""
    echo "# <<< pnpm-home <<<"
  } >> "$HOME/.bashrc"
fi
echo "    ✅ pnpm configured"

# Amplifier が未取得の場合のみ clone する (再ビルドしても安全な冪等処理)。
echo ""
if [ ! -d "$AMPLIFIER_DIR/.git" ]; then
  echo "⬇️   Cloning Amplifier ($AMPLIFIER_BRANCH branch)..."
  git clone --depth 1 --branch "$AMPLIFIER_BRANCH" "$AMPLIFIER_REPO" "$AMPLIFIER_DIR"
  echo "    ✅ Cloned into ./$AMPLIFIER_DIR"
else
  echo "ℹ️   Amplifier already present; skipping clone."
fi

# 依存関係をインストールする。Makefile が想定する作業ディレクトリで動くよう
# リポジトリ内に入って実行する。
echo ""
echo "📦  Running 'make install' (this can take several minutes)..."
( cd "$AMPLIFIER_DIR" && make install )
echo "    ✅ Dependencies installed"

# 新しいターミナルが毎回 Amplifier ディレクトリに入り、仮想環境を有効化した
# 状態になるようにする。これで学生は `claude` と打つだけで済む。
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

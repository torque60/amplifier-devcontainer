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
# また `make install` の `pnpm add -g` は、pnpm のグローバル bin ($PNPM_HOME/bin)
# が PATH に入っていないと失敗するため、これを PATH に通す。
# ただし claude-code は devcontainer feature が nvm 配下に正規インストール済みで、
# `claude` はそちらを使う。pnpm が入れる claude はビルドスクリプト未実行で壊れて
# いるため、PNPM_HOME を PATH 末尾に追加して feature 版を優先させる（先頭に置くと
# 壊れた pnpm 版が feature 版を覆い隠してしまう）。
echo ""
echo "🔧  Configuring pnpm..."
export SHELL="${SHELL:-/bin/bash}"
export PNPM_HOME="${PNPM_HOME:-$HOME/.local/share/pnpm}"
mkdir -p "$PNPM_HOME/bin"
export PATH="$PATH:$PNPM_HOME:$PNPM_HOME/bin"
pnpm setup >/dev/null 2>&1 || true
# 対話シェル・後続処理でも有効になるよう ~/.bashrc に明示追記（冪等）。末尾追加。
PNPM_MARKER="# >>> pnpm-home >>>"
if ! grep -qF "$PNPM_MARKER" "$HOME/.bashrc" 2>/dev/null; then
  {
    echo ""
    echo "$PNPM_MARKER"
    echo "export PNPM_HOME=\"$PNPM_HOME\""
    echo 'export PATH="$PATH:$PNPM_HOME:$PNPM_HOME/bin"'
    echo "# <<< pnpm-home <<<"
  } >> "$HOME/.bashrc"
fi
# pnpm v10+ は依存のビルドスクリプト(postinstall)を既定で未承認扱いにし、未承認だと
# `strictDepBuilds`(既定 true) によりインストールがエラー終了する。非対話の
# postCreate ではさらに承認プロンプトでハングし得る。ここでは警告に留めて続行させる
# (claude-code 本体は devcontainer feature が別途インストール済み)。
pnpm config set strictDepBuilds false >/dev/null 2>&1 || true
echo "    ✅ pnpm configured (PNPM_HOME=$PNPM_HOME)"

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
# pnpm のビルドスクリプト承認プロンプトで停止しないようにする。
#  - CI=1            : CI 環境としてプロンプト抑止のヒントを与える
#  - </dev/null      : stdin を非 TTY にし、対話ピッカー自体を起動不能にする（決め手）
#                      (Codespaces の postCreate は TTY を持つため CI=1 だけでは
#                       承認ピッカーが起動してハングする)
# 未承認のビルドスクリプトは strictDepBuilds=false により警告扱いで続行される。
# 一時的なネットワーク不調などに備え、最大 3 回まで再試行する。失敗が続く場合は
# ここは依存導入の要なので明確なメッセージを出して終了する。
INSTALL_MAX_ATTEMPTS=3
install_attempt=1
while true; do
  if ( cd "$AMPLIFIER_DIR" && CI=1 make install </dev/null ); then
    echo "    ✅ Dependencies installed"
    break
  fi
  if [ "$install_attempt" -ge "$INSTALL_MAX_ATTEMPTS" ]; then
    echo "" >&2
    echo "❌  'make install' が ${INSTALL_MAX_ATTEMPTS} 回連続で失敗しました。" >&2
    echo "    多くの場合は一時的なネットワーク不調が原因です。次のいずれかで再試行してください:" >&2
    echo "      1) F1 → 'Codespaces: Rebuild Container' でコンテナを再ビルド" >&2
    echo "      2) もしくはこのコンテナ内で再実行:  bash .devcontainer/post-create.sh" >&2
    echo "    詳細ログ: $LOG_FILE" >&2
    exit 1
  fi
  echo "    ⚠️  make install に失敗しました (試行 ${install_attempt}/${INSTALL_MAX_ATTEMPTS})。10 秒後に再試行します..." >&2
  install_attempt=$((install_attempt + 1))
  sleep 10
done

# make install 内の `pnpm add -g @anthropic-ai/claude-code` は、pnpm が
# ビルドスクリプト(postinstall)をスキップするため「ネイティブバイナリ未取得」の
# 壊れた claude を $PNPM_HOME/bin に残す。これがシェルによっては feature 版より先に
# PATH に乗り、`claude` が "native binary not installed" で起動してしまう。
# PATH 順序に依存せず確実にするため、壊れた pnpm 版 claude を削除する。
# `claude` は devcontainer feature が nvm 配下に正規インストールした版を使う（動作確認済み）。
echo ""
echo "🔧  Removing broken pnpm-global claude (use the feature-installed one)..."
rm -f "$PNPM_HOME/bin/claude" "$PNPM_HOME/bin/claude.exe" "$PNPM_HOME/claude" 2>/dev/null || true
hash -r 2>/dev/null || true
echo "    ✅ claude now resolves to: $(command -v claude || echo 'NOT FOUND')"

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

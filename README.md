# Amplifier クイックスタート Dev Container

**AI に興味のある人・学生が、環境構築でつまずかずに [Amplifier](https://github.com/microsoft/amplifier/tree/amplifier-claude) を試すための Dev Container キットです。**

Dev Containerを開くだけで、Amplifier のクイックスタート前提条件のインストールが**自動**で完了します。あなたがやることは、開いた後にターミナルで `claude` と打つことだけです。

---

## 🧭 どちらの方法で使う？

使う環境によって、最初の準備と開き方だけが異なります（**起動後の操作は完全に共通**です）。

| | 🅰️ GitHub Codespaces | 🅱️ ローカル（VS Code + Docker） |
|---|---|---|
| 必要なもの | GitHub アカウント + ブラウザ | Docker Desktop + VS Code + 拡張 + Git |
| 実行される場所 | GitHub のクラウド上 | あなたの PC 上 |
| インストール作業 | **不要**（PC に何も入れない） | Docker Desktop 等の導入が必要 |
| 向いている人 | とにかくすぐ試したい / PC に Docker を入れたくない | 自分の PC で動かしたい / オフライン重視 |
| 費用 | 無料枠あり（超過分は課金） | 無料 |

- 迷ったら → **🅰️ Codespaces**（最も手軽）
- 自分の環境で腰を据えて使うなら → **🅱️ ローカル**

手順は、共通の「テンプレートから自分のリポジトリを作る」→ 方法A または B、の順です。

---

## 🚀 まず：テンプレートから自分のリポジトリを作る（共通）

A・B どちらの方法でも、最初に**このキットを「テンプレート」として自分の GitHub リポジトリにコピー**します。

1. キットのリポジトリ（テンプレート）を GitHub で開く
2. 緑色の **「Use this template」** ボタン → **「Create a new repository」**
3. 自分のアカウントを選び、好きなリポジトリ名を付けて作成

> `Code` ボタンからの直接利用ではなく、テンプレートで**自分専用のコピー**を作ることで、設定変更や課題の保存を自分のリポジトリで自由に行えます。
> （配布者向け: この機能を使うには、キットのリポジトリ設定で **Template repository** を有効化しておく必要があります。詳細: [テンプレートリポジトリの作成](https://docs.github.com/ja/repositories/creating-and-managing-repositories/creating-a-template-repository)）

以降は、いま作った**自分のリポジトリ**に対して操作します。

---

## 🅰️ 方法A: GitHub Codespaces で使う

### 必要なもの
- **GitHub アカウント**
- **ブラウザ**（または GitHub Codespaces 拡張入りの VS Code）
- PC への Docker / VS Code のインストールは**不要**

### 手順

1. **作成した自分のリポジトリ**を GitHub で開く

2. **Codespace を作成する**
   - 緑色の **`<> Code`** ボタン → **`Codespaces`** タブ → **`Create codespace on main`**
   - クラウド上でコンテナが自動ビルドされ、[何が自動で行われるか](#-何が自動で行われるか両方共通) の処理がすべて走ります（初回は数分）

3. **`claude` を実行** → [▶ コンテナ起動後（両方共通）](#-コンテナ起動後両方共通claude-を実行) へ

> 公式手順: [リポジトリの codespace を作成する](https://docs.github.com/ja/codespaces/developing-in-a-codespace/creating-a-codespace-for-a-repository)

---

## 🅱️ 方法B: ローカル（VS Code + Docker）で使う

### 必要なもの（一度だけ）

1. **[Docker Desktop](https://www.docker.com/products/docker-desktop/)**（起動しておく）
   - Windows の場合は WSL2 バックエンドを有効化
2. **[Visual Studio Code](https://code.visualstudio.com/)**
3. VS Code 拡張 **[Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)**
4. **[Git](https://git-scm.com/downloads)**（自分のリポジトリを `git clone` するため）

> 初めての方は [VS Code Dev Containers チュートリアル](https://code.visualstudio.com/docs/devcontainers/tutorial) も参考にしてください。

### 手順

1. **作成した自分のリポジトリを取得して VS Code で開く**
   ```bash
   git clone <作成した自分のリポジトリの URL>
   cd <リポジトリ名>
   code .
   ```

2. **コンテナーで再度開く**
   - 右下に出る通知の **「コンテナーで再度開く (Reopen in Container)」** をクリック
   - 通知が出ない場合: `F1`（Mac は `Cmd+Shift+P`／Win・Linux は `Ctrl+Shift+P`）→ **Dev Containers: Reopen in Container**
   - 初回はイメージ取得と [自動処理](#-何が自動で行われるか両方共通) のため数分かかります（ターミナルにログが流れます）

3. **`claude` を実行** → [▶ コンテナ起動後（両方共通）](#-コンテナ起動後両方共通claude-を実行) へ

---

## ▶ コンテナ起動後（両方共通）：`claude` を実行

ビルドが完了したら、A・B どちらの方法でも操作は同じです。

1. **新しいターミナルを開く**
   - メニュー **「ターミナル（Terminal）」→「新しいターミナル（New Terminal）」**
   - ショートカット: 新規ターミナル `` Ctrl+Shift+` ``／パネルの表示・非表示の切り替え `` Ctrl+` ``（Mac も同じ）
   - 開くと自動で `amplifier` ディレクトリに入り、`.venv` が有効化されています
2. そのまま入力:
   ```bash
   claude
   ```
3. 初回はサインインを求められます。ブラウザでログインしてください。

これで Amplifier が使える状態です。たとえば次のように話しかけられます:
```
/ultrathink-task I'm new to "metacognitive recipes". Brainstorm some tool ideas.
```

---

## 🔐 ログイン状態は保持されます

Claude のログイン情報・設定・履歴は `~/.claude` に保存され、**名前付きボリュームにマウント**しています。
そのため **コンテナを再ビルドしてもサインインし直す必要はありません**。
（仕組みの詳細: [認証と設定の保持](https://code.claude.com/docs/ja/devcontainer#persist-authentication-and-settings-across-rebuilds)）

- **🅱️ ローカル**: ボリュームを削除しない限り保持されます。
- **🅰️ Codespaces**: 停止・再起動・リビルドをまたいで保持されます。ただし **Codespace 自体を削除すると失われます**（既定で 30 日間未使用の Codespace は自動削除）。再作成時はサインインし直してください。

---

## 🛡️ セキュリティについて（必ずお読みください）

- この Dev Container は**ネットワーク送信制限 (egress firewall) を入れていません**。
  これは Claude Code の **Web 検索 / Web 取得 / Playwright によるブラウジング**を使えるようにするためです
  （送信先を制限すると、これらが任意のサイトへアクセスできず動作しなくなるため）。
- したがって、コンテナ内のコードは**ホスト（またはクラウド環境）と同等のネットワーク権限**を持ちます。
  **信頼できるリポジトリ・コードでのみ使用してください。**
- **`~/.ssh` やクラウド認証情報などの秘密情報をコンテナにマウントしないでください。**
  必要な場合はリポジトリスコープ／短期トークンを使ってください。
- Claude の操作は監視し、想定外のコマンドは承認しないでください。

> 送信先を絞った「強化版」が必要な場合は、公式の
> [ネットワークエグレス制限](https://code.claude.com/docs/ja/devcontainer#restrict-network-egress) と
> [リファレンスコンテナ](https://github.com/anthropics/claude-code/tree/main/.devcontainer)（`init-firewall.sh`）
> を参照し、許可ドメインに `api.anthropic.com` / `github.com` / `pypi.org` / `registry.npmjs.org` などを追加してください。
> ただし Web 検索系の機能は制限されます。

---

## 🧰 トラブルシューティング

| 症状 | 対処 |
|---|---|
| `claude: command not found` | ビルド（post-create）が未完了か失敗。ログを確認: `cat /tmp/devcontainer-post-create.log` |
| ターミナルが `amplifier` に入らない | post-create 完了後に**新しい**ターミナルを開く |
| `make install` が失敗する | ネットワーク／プロキシを確認のうえ再ビルド（`Dev Containers: Rebuild Container`） |
| ブラウザでログインしても戻ってこない | ターミナルの `Paste code here if prompted` に、ブラウザ表示のコードを貼り付け |
| post-create をやり直したい | コンテナ内で `bash .devcontainer/post-create.sh` を再実行（clone 済みなら clone はスキップ） |
| 🅰️ Codespaces で「コンテナーで再度開く」通知が出ない | Codespaces では不要です。Codespace を作成した時点で自動ビルドされます |
| 🅱️ ローカルでビルドが始まらない | Docker Desktop が**起動しているか**を確認 |

---

## 🧩 何が自動で行われるか（両方共通）

> 参考情報です。使うだけなら読まなくて構いません。**舞台裏で実行される内容**をまとめています。
> いずれも**コンテナの中**で行われます。ホスト（PC）側の Docker Desktop・VS Code・Git は、これらの前に**あなたが手動で**用意するもので、ここには含まれません（上部「🧭 どちらの方法で使う？」を参照）。

自動処理は2段階に分かれます。

**① コンテナのビルド時** — `devcontainer.json` の [features](.devcontainer/devcontainer.json) が前提ツールをインストール

| ツール | 用途 |
|---|---|
| Python 3.11+ | ベースイメージに同梱 |
| uv | Python パッケージマネージャ |
| Node.js / pnpm | Amplifier の Node 系依存 |
| make | `make install` / `make check` 等 |
| **Claude Code CLI** | `claude` コマンド本体 |
| gh | GitHub CLI（任意） |

**② コンテナ作成後** — [post-create.sh](.devcontainer/post-create.sh) が一度だけ実行

| ステップ | 内容 |
|---|---|
| Amplifier の取得 | `amplifier-claude` ブランチを `./amplifier` に clone |
| 依存関係の導入 | `amplifier` 内で `make install`（`.venv` 作成 + Node 依存導入） |
| シェル設定 | 新しいターミナルが自動で `amplifier` に移動し、`.venv` を有効化 |

> 公式リファレンス: [Claude Code 開発コンテナ](https://code.claude.com/docs/ja/devcontainer)

---

## 📁 構成ファイル

```
amplifier-devcontainer/
├── .devcontainer/
│   ├── devcontainer.json   # ベースイメージ・前提条件 feature・ボリューム・拡張（A/B 共通）
│   └── post-create.sh      # clone + make install + シェル設定（claude 直前まで）
├── .gitignore              # clone される amplifier/ やキャッシュを除外
└── README.md               # このファイル
```

> `amplifier/` ディレクトリはコンテナ作成時に clone されるため、この Git リポジトリには含めません（`.gitignore` 済み）。
> `devcontainer.json` は Codespaces とローカルの**両方でそのまま動作**します（環境ごとの分岐は不要）。

---

## ❓ なぜ「キット」を別フォルダにしているのか

Amplifier 本体には別の `.devcontainer` が同梱されていますが、このキットは
**「開くだけで Amplifier を自動取得してセットアップする」初学者向けの入口**として独立させています。
Amplifier 本体を直接いじらずに配布・更新できます。

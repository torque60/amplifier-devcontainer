# Amplifier クイックスタート Dev Container

**AI に興味のある人・学生が、環境構築でつまずかずに [Amplifier](https://github.com/microsoft/amplifier/tree/amplifier-claude) を試すための Dev Container キットです。**

Dev Containerを開くだけで、Amplifier のクイックスタート前提条件のインストールが**自動**で完了します。あなたがやることは、開いた後にターミナルで `claude` と打つことだけです。

> このキットは **GitHub Codespaces** での利用を前提に説明しています（PC に何もインストールせず、ブラウザだけで始められます）。
> 自分の PC の **VS Code + Docker** で動かしたい場合は、おまけの [**ローカルでの使い方（LOCAL_SETUP.md）**](./LOCAL_SETUP.md) を参照してください。

---

## 🚀 まず：テンプレートから自分のリポジトリを作る

最初に**このキットを「テンプレート」として自分の GitHub リポジトリにコピー**します。

1. キットのリポジトリ（テンプレート）を GitHub で開く
2. 右上にある緑色の **「Use this template」** ボタン → **「Create a new repository」**
3. 自分のアカウントを選び、好きなリポジトリ名を付けて作成

> `Code` ボタンからの直接利用ではなく、テンプレートで**自分専用のコピー**を作ることで、設定変更や課題の保存を自分のリポジトリで自由に行えます。
> （配布者向け: この機能を使うには、キットのリポジトリ設定で **Template repository** を有効化しておく必要があります。詳細: [テンプレートリポジトリの作成](https://docs.github.com/ja/repositories/creating-and-managing-repositories/creating-a-template-repository)）

以降は、いま作った**自分のリポジトリ**に対して操作します。

---

## ☁️ Codespace を作成する

### 必要なもの
- **GitHub アカウント**
- **ブラウザ**（または GitHub Codespaces 拡張入りの VS Code）
- **Anthropic アカウント** — Claude Code の利用には **Anthropic の有料プラン（Claude Pro / Max など）か、API のクレジット（課金）が必要**です（無料では利用できません。[料金](https://claude.com/pricing)）。

### 手順

1. **作成した自分のリポジトリ**を GitHub で開く

2. **Codespace を作成する**
   - 緑色の **`<> Code`** ボタン → **`Codespaces`** タブ → **`Create codespace on main`**
   - クラウド上でコンテナが自動ビルドされ、[何が自動で行われるか](#-何が自動で行われるか) の処理がすべて走ります（初回は数分）

> 公式手順: [リポジトリの codespace を作成する](https://docs.github.com/ja/codespaces/developing-in-a-codespace/creating-a-codespace-for-a-repository)

---

## ▶ コンテナ起動後：`claude` を実行

ビルドが完了したら:

1. **新しいターミナルを開く**
   - メニュー **「ターミナル（Terminal）」→「新しいターミナル（New Terminal）」**
   - ショートカット: 新規ターミナル `` Ctrl+Shift+` ``／パネルの表示・非表示の切り替え `` Ctrl+` ``（Mac も同じ）
   - 開くと自動で `amplifier` ディレクトリに入り、`.venv` が有効化されています
2. そのまま入力:
   ```bash
   claude
   ```
3. 初回はサインインを求められます。ブラウザでログインしてください。

> ⚠️ **Codespaces での認証のコツ（つまずきやすい）**
> サインイン時にブラウザの別タブが開き、メールアドレス宛の **OTP（ワンタイムコード）** を入力します。
> その後 `localhost` へリダイレクトされますが、**Codespaces ではこのリダイレクトが失敗してエラー画面になります**（クラウド上のコンテナなので手元の `localhost` には戻れません）。
>
> **対処**: 失敗しても、次の手順でコードを取得してください。
> 1. ターミナルに戻り、認証ページの**リンクをもう一度クリック**する。
> 2. ブラウザの別タブが開き、再び承認ボタンを押すと画面に**認証コードが表示**されます。
> 3. そのコードをコピーし、**ターミナルの `Paste code here if prompted:` に貼り付けて Enter**。
>
> これでサインインが完了します（`localhost` のエラー画面自体は無視して構いません）。

これで Amplifier が使える状態です。たとえば次のように話しかけられます:
```
/ultrathink-task I'm new to "metacognitive recipes". Brainstorm some tool ideas.
```

---

## 🔐 ログイン状態は保持されます

Claude のログイン情報・設定・履歴は `~/.claude` に保存され、**名前付きボリュームにマウント**しています。
そのため **コンテナを再ビルドしてもサインインし直す必要はありません**。
（仕組みの詳細: [認証と設定の保持](https://code.claude.com/docs/ja/devcontainer#persist-authentication-and-settings-across-rebuilds)）

ただし Codespaces では、停止・再起動・リビルドをまたいで保持される一方、**Codespace 自体を削除すると失われます**（既定で 30 日間未使用の Codespace は自動削除）。再作成時はサインインし直してください。

---

## 🛑 Codespace の終わり方

作業を終えるときは、用途に合わせて **停止** か **削除** を選びます。

| 操作 | やり方 | 何が起きる |
|---|---|---|
| **停止（Stop）** | リポジトリの **`<> Code` → `Codespaces`** タブ → 対象の **`…` → `Stop codespace`**（ブラウザのタブを閉じるだけでも、一定時間操作がなければ自動停止します） | コンテナを一時停止。**コンピュート（実行）課金が止まります**。`~/.claude` や作業内容はそのまま残り、次回そのまま再開できます。 |
| **削除（Delete）** | 同じ `Codespaces` タブ → 対象の **`…` → `Delete`** | Codespace を完全に削除。**ストレージ課金も止まります**。`~/.claude` を含む状態は失われ、再作成時はサインインし直しです。 |

> - 迷ったら **停止** で OK（次回すぐ再開できます）。長く使わない・容量を空けたいときは **削除**。
> - 停止中も**ストレージ課金は続きます**。課金を完全に止めるには削除してください。
>
> 公式手順: [Codespace の停止と開始](https://docs.github.com/ja/codespaces/developing-in-a-codespace/stopping-and-starting-a-codespace) ／ [Codespace の削除](https://docs.github.com/ja/codespaces/developing-in-a-codespace/deleting-a-codespace) ／ [Codespaces の課金について](https://docs.github.com/ja/billing/managing-billing-for-your-products/managing-billing-for-github-codespaces/about-billing-for-github-codespaces)

---

## 🛡️ セキュリティについて（必ずお読みください）

- この Dev Container は**ネットワーク送信制限 (egress firewall) を入れていません**。
  これは Claude Code の **Web 検索 / Web 取得 / Playwright によるブラウジング**を使えるようにするためです
  （送信先を制限すると、これらが任意のサイトへアクセスできず動作しなくなるため）。
- したがって、コンテナ内のコードは**クラウド環境と同等のネットワーク権限**を持ちます。
  **信頼できるリポジトリ・コードでのみ使用してください。**
- **`~/.ssh` やクラウド認証情報などの秘密情報をコンテナにマウントしないでください。**
  必要な場合はリポジトリスコープ／短期トークンを使ってください。
- Claude の操作は監視し、想定外のコマンドは承認しないでください。
- **Claude Code の利用には Anthropic の規約への同意が必要**です。サインインは各自の Anthropic アカウントで行ってください（プランにより適用規約が異なります → [Claude Code 法的・規制対応](https://code.claude.com/docs/ja/legal-and-compliance)）。詳細は下記「ライセンス / Acknowledgements」を参照。

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
| `make install` が失敗する | ネットワークを確認のうえ再ビルド（`F1` → **Codespaces: Rebuild Container**） |
| サインインで `localhost` へのリダイレクトが失敗する | Codespaces では正常な挙動。認証ページのリンクを**もう一度クリック**して表示される**コードをコピー**し、ターミナルの `Paste code here if prompted:` に貼り付け（詳細は[「`claude` を実行」の注記](#-コンテナ起動後claude-を実行)） |
| post-create をやり直したい | コンテナ内で `bash .devcontainer/post-create.sh` を再実行（clone 済みなら clone はスキップ） |

> ローカル（VS Code + Docker）固有のトラブルは [LOCAL_SETUP.md](./LOCAL_SETUP.md) を参照してください。

---

## 🧩 何が自動で行われるか

> 参考情報です。使うだけなら読まなくて構いません。**舞台裏で実行される内容**をまとめています。
> いずれも**コンテナの中**で行われます。ホスト（PC）側の準備（Docker Desktop・VS Code・Git）はローカルで使う場合のみ必要で、Codespaces では不要です（→ [LOCAL_SETUP.md](./LOCAL_SETUP.md)）。

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
│   ├── devcontainer.json   # ベースイメージ・前提条件 feature・ボリューム・拡張
│   └── post-create.sh      # clone + make install + シェル設定（claude 直前まで）
├── .gitignore              # clone される amplifier/ やキャッシュを除外
├── LICENSE                 # キット本体のライセンス（MIT）
├── LOCAL_SETUP.md          # （おまけ）ローカル（VS Code + Docker）での使い方
└── README.md               # このファイル（Codespaces 前提）
```

> `amplifier/` ディレクトリはコンテナ作成時に clone されるため、この Git リポジトリには含めません（`.gitignore` 済み）。
> `devcontainer.json` は Codespaces とローカルの**両方でそのまま動作**します（環境ごとの分岐は不要）。

---

## ❓ なぜ「キット」を別フォルダにしているのか

Amplifier 本体には別の `.devcontainer` が同梱されていますが、このキットは
**「開くだけで Amplifier を自動取得してセットアップする」初学者向けの入口**として独立させています。
Amplifier 本体を直接いじらずに配布・更新できます。

---

## 📜 ライセンス / Acknowledgements

- **このキット自体**（`.devcontainer/` の設定・`post-create.sh`・各 `.md`）は **[MIT License](./LICENSE)** で配布しています。
- このキットは **Amplifier と Claude Code のソースを同梱していません**。ビルド時に各公式から取得・インストールするため、それぞれのライセンス・規約は各提供元に従います。

| 取得されるもの | 提供元 | ライセンス / 規約 |
|---|---|---|
| Amplifier | [microsoft/amplifier](https://github.com/microsoft/amplifier) | [MIT License](https://github.com/microsoft/amplifier/blob/main/LICENSE)（Copyright (c) Microsoft Corporation） |
| Claude Code CLI | Anthropic | **プロプライエタリ**（© Anthropic PBC）。利用は [Anthropic の規約](https://code.claude.com/docs/ja/legal-and-compliance)に従う |

> **Claude Code はオープンソースではありません。** 利用には**各自の Anthropic アカウントでのサインインと規約への同意が必要**で、プランにより適用規約が異なります（Free / Pro / Max → [コンシューマー利用規約](https://www.anthropic.com/legal/consumer-terms)、Team / Enterprise / API → [商用条件](https://www.anthropic.com/legal/commercial-terms)、共通で [使用ポリシー](https://www.anthropic.com/legal/aup)）。
>
> ※ 上記は一般的な情報であり、法的助言ではありません。最終的な可否は各原文ライセンス・規約をご確認ください。

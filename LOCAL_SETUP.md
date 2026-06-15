# （おまけ）ローカルでの使い方 — VS Code + Docker

[README](./README.md) は **GitHub Codespaces** での利用を前提に説明しています。
このファイルは、自分の PC（ローカル）で同じキットを動かしたい人向けの**おまけ**手順です。
Codespaces で使う場合は読む必要はありません。

> Codespaces との違いは「**最初の準備と開き方**」だけです。コンテナ起動後の操作（`claude` 実行・ログイン）は README とまったく同じになります。

---

## 必要なもの（一度だけ）

ローカルで使う場合は、コンテナを動かす土台として PC 側に以下が必要です。

1. **[Docker Desktop](https://www.docker.com/products/docker-desktop/)**（起動しておく）
   - Windows の場合は WSL2 バックエンドを有効化
2. **[Visual Studio Code](https://code.visualstudio.com/)**
3. VS Code 拡張 **[Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)**
4. **[Git](https://git-scm.com/downloads)**（自分のリポジトリを `git clone` するため）

> これらは**コンテナの外（ホスト）**で必要なもので、`post-create.sh` では導入されません。
> 初めての方は [VS Code Dev Containers チュートリアル](https://code.visualstudio.com/docs/devcontainers/tutorial) も参考にしてください。

---

## 手順

1. **テンプレートから自分のリポジトリを作る**
   - [README](./README.md) の「🚀 まず：テンプレートから自分のリポジトリを作る」と同じ手順です。

2. **自分のリポジトリを取得して VS Code で開く**
   ```bash
   git clone <作成した自分のリポジトリの URL>
   cd <リポジトリ名>
   code .
   ```

3. **コンテナーで再度開く**
   - 右下に出る通知の **「コンテナーで再度開く (Reopen in Container)」** をクリック
   - 通知が出ない場合: `F1`（Mac は `Cmd+Shift+P`／Win・Linux は `Ctrl+Shift+P`）→ **Dev Containers: Reopen in Container**
   - 初回はイメージ取得と自動処理（clone + `make install`）のため数分かかります（ターミナルにログが流れます）

4. **`claude` を実行**
   - 以降は [README](./README.md) の「▶ コンテナ起動後：`claude` を実行」と同じです。
   - 新しいターミナルを開くと自動で `amplifier` に入り `.venv` が有効化されているので、そのまま `claude` と入力します。

---

## ローカル特有のメモ

### ログイン状態の保持
`~/.claude` は名前付きボリュームに保存されるため、**コンテナを再ビルドしてもサインインし直す必要はありません**。ボリュームを削除しない限り保持されます。
（Codespaces と違い、30 日自動削除のような制約はありません。）

### トラブルシューティング（ローカル特有）

| 症状 | 対処 |
|---|---|
| ビルドが始まらない | **Docker Desktop が起動しているか**を確認 |
| 「コンテナーで再度開く」通知が出ない | `F1` → **Dev Containers: Reopen in Container** |
| `make install` が失敗する | ネットワーク／プロキシを確認のうえ **Dev Containers: Rebuild Container** |

> セキュリティ・自動処理の中身など**共通の説明**は [README](./README.md) を参照してください。

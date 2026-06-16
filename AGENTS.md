このリポジトリで AI（Claude Code）と人間が作業するための **契約**。
迷ったらこのファイルを最優先する。

プロジェクト概要・アーキテクチャ・起動方法は → [README.md](./README.md) を参照。

---

## 1. 常時守る契約（最重要）

- 変更は **1ステップずつ** 入れて、直後に必ず検証（tests/metrics）する
- SSE/WS 等は **自動で終わる** こと（timeout / close / スコープ制限）を最優先する
- コミットは **1コミット＝1論点**、メッセージは `type(scope): subject` を厳守する
- 作成・更新したファイルの先頭にファイルの概要を理解するためのコメントを記載し、更新時は常にアップデートを厳守する
- 挙動を変える変更は Issue に基づいて行い、`master` へ直接 commit/push せず必ず feature ブランチ + PR を経由する

---

## 2. skill（必要なときに自動で読まれる手続き的ルール）

細則は Claude Code の skill に置いた。skill は description の発火条件に応じて自動で読み込まれるため、
ここから明示的に読み込み指定する必要はない。各 skill がいつ起動するかの索引だけ示す。

| skill | いつ起動するか |
|-------|----------------|
| **git-commit** | コミットメッセージを作成・生成するとき |
| **github-workflow** | GitHub を操作するとき（Issue 起票・閲覧・PR 作成/レビュー・ブランチ運用） |
| **doc-writing** | 設計ドキュメント・技術文書を作成・更新するとき |
| **ticket-template** / **ticket-draft** / **ticket-publish** / **ticket-pr-publish** | チケット下書きの作成・発行・PR 化を行うとき |

---

## 3. 参考ドキュメント

- 秘密情報・個人情報スキャン（pre-commit / PreToolUse フックの仕組み・運用・allowlist の足し方）は
  → [docs/secret-scan.md](docs/secret-scan.md) を参照する。外部公開操作を変更するときや検出の誤検知・
  検出漏れに対処するときに読む。

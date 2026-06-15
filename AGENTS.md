このリポジトリで AI（例: GitHub Copilot）と人間が作業するための **契約**。
迷ったらこのファイルを最優先する。

プロジェクト概要・アーキテクチャ・起動方法は → [README.md](./README.md) を参照。

---

## 1. TL;DR（最重要だけ）

- 作業開始前に [README.md](./README.md) と `instructions/` 配下の該当ファイルを確認する
- 変更は **1ステップずつ** 入れて、直後に必ず検証（tests/metrics）する
- SSE/WS 等は **自動で終わる** こと（timeout / close / スコープ制限）を最優先する
- コミットは **1コミット＝1論点**、メッセージは `type(scope): subject` を厳守する（→ [instructions/git-commit.md](instructions/git-commit.md)）
- 作成・更新したファイルの先頭にファイルの概要を理解するためのコメントを記載し、更新時は常にアップデートを厳守する

---

## 2. instructions/ ガイド（条件付き読み込み）

作業内容に応じて、**必要なファイルだけ**を読むこと：

| ドキュメント | 読むべきタイミング |
|-------------|-------------------|
| **[instructions/git-commit.md](instructions/git-commit.md)** | コミットを作成するとき（毎回） |
| **[instructions/github-workflow.md](instructions/github-workflow.md)** | GitHub を操作するとき（Issue 起票・閲覧・PR 等、毎回） |
| **[instructions/doc-writing.md](instructions/doc-writing.md)** | 設計ドキュメント・技術文書を作成・更新するとき（毎回） |
| **[instructions/secret-scan.md](instructions/secret-scan.md)** | 外部公開操作（commit/push・Issue/PR アップロード）を変更するとき、スキャンの誤検知・検出漏れに対処するとき |

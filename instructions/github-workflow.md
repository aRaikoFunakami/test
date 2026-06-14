# GitHub 運用ルール

いつ読むか: GitHub を操作するとき（Issue の起票・閲覧、PR 作成・レビュー等、毎回）

このドキュメントは、本リポジトリにおける GitHub の運用契約を定める。
迷ったら AGENTS.md の方針を優先し、本ドキュメントを GitHub 操作の手順・規約として参照する。

⸻

## リポジトリ

- **URL:** `https://github.com/aRaikoFunakami/test.git`
- **default ブランチ:** `master`（PR のマージ先。closing keyword の発火条件に関わる）

⸻

## ツール

- GitHub 操作（接続・起票・閲覧・PR 等）には必ず `gh` コマンドを使用する。
- ブラウザ操作や Web UI を前提とした手順を記述・依頼しない。

⸻

## Issue ベース開発

- 修正や機能追加は **Issue の内容に基づいて** 実施する。Issue なしの直接変更は避ける。
- Issue 起票時は、**AI が単独で実装・完結できるレベルまで** 詳細な技術仕様を記述する。
  - 対象ファイル・モジュール、変更方針、受け入れ条件（テスト/検証方法）を含める。
  - 曖昧な要望のままで起票しない。実装者が追加質問なしで着手できる粒度にする。

⸻

## ブランチ運用

### 禁止事項

1. **default ブランチ（`master`）で直接作業しないこと** — 必ず feature ブランチを作成してから作業する。
2. **default ブランチへ直接 push しないこと** — 変更は必ず PR 経由でマージする。

### ブランチ命名規則

| 種別 | 形式 |
|------|------|
| Feature | `feature/<issue-number>-<short-description>` |
| Bugfix | `bugfix/<issue-number>-<short-description>` |
| Hotfix | `hotfix/<issue-number>-<short-description>` |
| Documentation | `docs/<issue-number>-<short-description>` |

- 作業開始前に、現在のブランチが default ブランチ（`master`）でないことを確認する。該当する場合は上記命名規則で feature ブランチを作成してから着手する。

⸻

## PR 運用

PR は Issue と双方向に辿れる状態を必須とする。「Issue → PR → Commit」「Commit → PR → Issue」の両方向を GitHub 上に残すことが目的。

### Issue との紐付け（必須）

- PR は必ず対応する Issue に紐付ける。**PR 本文**に closing keyword を 1 行入れる:

  ```
  Closes #<issue-number>
  ```

  `Fixes #<n>` / `Resolves #<n>` でも可。

- **紐付けは PR 本文に書く。** ブランチ名や commit メッセージでは Issue⇄PR の双方向リンクは作られない。
  - ブランチ名 `feature/<n>-...` に番号を含めても GitHub はリンクを生成しない（人間が読むためのラベル）。
  - commit メッセージの `#<n>` は Issue を参照（mention）するだけで、その PR は Issue の linked pull request として表示されない。

### default ブランチ制約

- closing keyword はマージ先が **default ブランチ（`master`）** のときのみ発火する。
- default 以外のブランチを base にした PR では keyword は無視されリンクが生成されない。その場合は GitHub の Development サイドバーから手動で Issue を紐付ける。

### 作成例

```
gh pr create \
  --base master \
  --title "<type(scope): subject>" \
  --body "Closes #<issue-number>

<変更概要 / なぜ>"
```

- `--base` は default ブランチ（`master`）を指定する。
- タイトルは `type(scope): subject` 形式（→ [git-commit.md](git-commit.md)）に揃える。
- PR テンプレート（`.github/PULL_REQUEST_TEMPLATE.md`）がある場合はその構造に沿い、`Closes #` を必ず埋める。

### 根拠

GitHub 公式ドキュメント [Linking a pull request to an issue](https://docs.github.com/en/issues/tracking-your-work-with-issues/linking-a-pull-request-to-an-issue) による。closing keyword は `close/closes/closed`, `fix/fixes/fixed`, `resolve/resolves/resolved`。default ブランチ以外を対象とした PR では keyword は無視される。

# GitHub 運用ルール

いつ読むか: GitHub を操作するとき（Issue の起票・閲覧、PR 作成・レビュー等、毎回）

このドキュメントは、本リポジトリにおける GitHub の運用契約を定める。
迷ったら AGENTS.md の方針を優先し、本ドキュメントを GitHub 操作の手順・規約として参照する。

⸻

## リポジトリ

- **URL:** `https://github.com/access-company/smartestiroid-core.git`

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

1. **`develop` ブランチで直接作業しないこと** — 必ず feature ブランチを作成してから作業する。
2. **`main` ブランチで作業しないこと** — main は本番リリース専用とする。

### ブランチ命名規則

| 種別 | 形式 |
|------|------|
| Feature | `feature/<issue-number>-<short-description>` |
| Bugfix | `bugfix/<issue-number>-<short-description>` |
| Hotfix | `hotfix/<issue-number>-<short-description>` |
| Documentation | `docs/<issue-number>-<short-description>` |

- 作業開始前に、現在のブランチが `develop` / `main` でないことを確認する。該当する場合は上記命名規則で feature ブランチを作成してから着手する。

---
description: Issue 下書きを種別選択して issues/ に作成し Zed で開く
---

<!--
概要: チケット(Issue)下書き作成コマンド。
種別(bug/docs/feature)を選ばせ、対応テンプレを issues/ にコピーして Zed で開く。
発行は別コマンド /ticket-issue で行う。テンプレ実体は .github/ISSUE_TEMPLATE/ にある。
-->

GitHub Issue の下書きを作成する。手順を厳守する。

1. `AskUserQuestion` で Issue 種別を聞く。選択肢は **bug / docs / feature** の3つ。
2. 選択に対応するテンプレを読む:
   - bug → `.github/ISSUE_TEMPLATE/bug.md`
   - docs → `.github/ISSUE_TEMPLATE/docs.md`
   - feature → `.github/ISSUE_TEMPLATE/feature.md`
3. 保存先ファイル名を決める。`date +%Y%m%d-%H%M%S` を Bash で取得し、
   `issues/<type>-<timestamp>.md`（例 `issues/feature-20260613-141500.md`）とする。
   `issues/` が無ければ作る。
4. テンプレ全文（**frontmatter 含む**）をその下書きファイルにコピーする。
   frontmatter は発行時に title/label を拾うため残す。
5. `zed <path>` で開く。
6. 作成パスを表示し、「編集・保存後 `/ticket-issue @<path>` で GitHub に発行」と案内する。

注意:
- 内容は生成しない。テンプレをコピーするだけ。本文はユーザーが Zed で記述する。
- 既存の同名ファイルは上書きしない（timestamp で衝突回避済み）。

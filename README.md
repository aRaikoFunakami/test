<!--
概要: プロジェクト README。チケット駆動開発を Claude Code に担わせるフレームワークの概要・導入・使い方・構成。
設計の背景と判断の記録は docs/design-notes.md、秘密情報スキャンの詳細は docs/secret-scan.md を参照。
-->

# Ticket-Driven Dev Framework for Claude Code

チケット駆動開発のルールと手順を **Claude Code** に持たせ、起票からブランチ作成・コミット・
Pull Request 作成までを会話だけで回すフレームワーク。開発者は「次に何を作りたいか」を自然言語で
伝えるだけでよく、Issue の書き方・ブランチ命名・コミット規約・PR と Issue の紐付けといった
細則は AI 側が担う。

人手の運用に依存するルールは、忘れ・例外でいつか崩れる。そこで覚える主体を人から AI へ移した。
設計の背景と各部品の判断は [docs/design-notes.md](docs/design-notes.md) に詳しい。

## 特徴

- **会話で完結** — 計画を伝えると Issue 下書き生成 → 発行 → ブランチ → 実装 → PR までを Claude Code が駆動する
- **追跡性** — PR 本文の `Closes #N` で Issue・PR・コミットを双方向に辿れる状態を保つ
- **規約は skill に常駐** — コミット・GitHub 操作・文書文体の規約を skill 化し、必要なときだけ自動で読み込む
- **外部公開の安全弁** — 秘密情報・個人情報を pre-commit と PreToolUse フックの二層（gitleaks）でアップロード前に止める

## 構成要素

| 層 | 実体 | 役割 |
|----|------|------|
| 型 | `.github/ISSUE_TEMPLATE/`（feature / bug / docs） | どんな Issue を書くべきかの雛形。frontmatter の `title` 接頭辞と `labels` を発行コマンドが読む |
| 契約 | `AGENTS.md` + skill（`git-commit` / `github-workflow` / `doc-writing`） | 常時守る最小契約は AGENTS.md、細則は発火条件で自動ロードされる skill |
| 手続き | skill（`ticket-template` / `ticket-draft` / `ticket-publish` / `ticket-pr-publish`） | 下書き作成・発行・PR 化を実行する |
| 安全弁 | `.githooks/` + `.claude/settings.json`（PreToolUse） | gitleaks による秘密情報スキャン（[docs/secret-scan.md](docs/secret-scan.md)） |

## 導入

各 clone で一度だけ、秘密情報スキャンのフックを有効化する。

```sh
brew install gitleaks
git config core.hooksPath .githooks
```

GitHub 操作には `gh` を使う。未認証なら `gh auth login` で認証する。新規リポジトリには
ラベルが無いので、テンプレートが前提とする `feature` / `bug` / `documentation` を作っておく。

```sh
gh label list   # 無ければ次で作成
gh label create feature && gh label create bug && gh label create documentation
```

## 使い方

典型フローは「計画を渡す → 発行して実装させる」の2ステップ。例として 3 言語の hello world を作る。

```
rust と C と python で hello world を作る開発計画を立てて。それぞれ別々のチケットにして
```

`/ticket-draft` が計画を 3 件の作業項目へ分解し、種別を 1 枚の対応表でまとめて確認したうえで
`.issue_drafts/<type>-<timestamp>-NN.md` を生成する（ここでは発行しない）。続けて、

```
すべて発行して、そのあと実装して
```

`/ticket-publish` が下書きを 1 件ずつ Issue として発行し、ブランチを切って実装する。結果として
3 つの Issue と、ビルドして実行できる 3 言語の hello world が手元に残る。

```sh
cd hello/rust && cargo run        # Rust
cd hello/c && make run            # C
python3 hello/python/hello.py     # Python
```

### skill 一覧

| skill | 種別 | 役割 |
|-------|------|------|
| `/ticket-template` | ローカル | テンプレートをコピーし人が手で書く足場を作る |
| `/ticket-draft` | ローカル | 会話・計画から下書きを AI 生成する（1〜N 件） |
| `/ticket-publish` | GitHub 登録 | 下書きを `gh issue create` で発行する（明示実行のみ） |
| `/ticket-pr-publish` | GitHub 登録 | ブランチ名から issue 番号を拾い `Closes #N` 付きで PR を作る（明示実行のみ） |

ローカル系はファイルを作るだけなので自然言語の依頼で自動起動する。GitHub に出る発行系は
取り消しが難しいため、明示的にコマンドを呼んだときだけ起動し、実行前に同意を取る。

典型的な一連の流れ:

```
/ticket-draft [@PLAN.md]   会話・計画 → .issue_drafts/ に下書き（1〜N 件）
/ticket-publish @<file>    下書き → GitHub Issue（発行後に下書きを削除）
<type>/<issue番号>-<説明>   ブランチを切って実装・コミット
/ticket-pr-publish          PR 本文に Closes #N を入れて gh pr create（base は master）
master へマージ             Closes # が発火し Issue が自動クローズ
```

## リポジトリ構成

```
.github/ISSUE_TEMPLATE/   Issue テンプレート（feature / bug / docs / config.yml）
.github/PULL_REQUEST_TEMPLATE.md   PR テンプレート（Closes # を含む）
.claude/skills/           ticket-* と git-commit / github-workflow / doc-writing の各 skill
.claude/settings.json     PreToolUse フック（L3 秘密情報スキャン）の設定
.githooks/                pre-commit フック（L1 秘密情報スキャン）
docs/                     設計ノート・秘密情報スキャンの設計
AGENTS.md                 人間と AI の常時契約 + skill 索引
tests/                    秘密情報スキャンの回帰テスト
```

## ドキュメント

- [AGENTS.md](AGENTS.md) — 常時守る作業契約と skill 索引
- [docs/design-notes.md](docs/design-notes.md) — 設計の背景と各部品の判断の記録
- [docs/secret-scan.md](docs/secret-scan.md) — 秘密情報・個人情報スキャンの仕組み・運用・allowlist

## テスト

秘密情報スキャンの挙動は回帰テストで固定している。

```sh
sh tests/run.sh
```

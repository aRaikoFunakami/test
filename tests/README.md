# tests — 流出防止スキャンの回帰テスト

概要: L1(pre-commit) / L3(egress フック) と `.gitleaks.toml` の検出挙動を固定化した回帰テスト。
設定やフックを修正したら実行して、検出漏れ・過検出が起きていないか確認する。

## 実行

```sh
sh tests/run.sh
```

`gitleaks` が必要（`brew install gitleaks`）。全項目通過で exit 0、失敗があれば非 0。

## 検証内容

- `fixtures/flag/` … 検出されるべき検体（ホームパス / メール / プライベート IP / 電話）。各々が gitleaks で検出されることを確認する。
- 秘密情報（Slack トークン）の検出は、実トークンをリポジトリに置かないようランナーが実行時に分割リテラルから組み立てて走査する（標準ルールの確認）。
- `fixtures/pass/` … allowlist で除外されるべき検体（`/Users/<user>/`・`example.com`・`192.168.0.1` 等）。検出されないことを確認する。
- `fixtures/payloads/` … L3 フックへ渡す PreToolUse 入力。PII を含む `gh issue create` は exit 2 で拒否、無関係コマンドは exit 0 で素通りすることを確認する。

## 設計メモ

`fixtures/` は意図的に秘密情報・個人情報を含むため、`.gitleaks.toml` の allowlist パスでコミット時走査から除外している。これがないと自分のテスト検体を L1 がブロックしてコミットできない。
ランナーは検体を一時ディレクトリ（allowlist 対象外パス）へ複製してから走査するので、検出テストは正しく機能する。

検体を増やすときは `flag/`（検出されるべき）か `pass/`（除外されるべき）に置けば、ランナーが自動で拾う。

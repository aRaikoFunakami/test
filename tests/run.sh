#!/bin/sh
# 概要: 流出防止スキャン(L1/L3)の回帰テスト。tests/fixtures/ の検体を一時ディレクトリへ複製して
#       gitleaks で走査し、(1) 検出されるべき検体が検出される (2) allowlist 検体が除外される
#       (3) L3 が PII アップロードを拒否し無関係コマンドを素通りさせる、を検証する。
#       .gitleaks.toml や各フックを修正したら `sh tests/run.sh` を実行して挙動を確認する。
# 補足: fixtures は .gitleaks.toml の allowlist パスでコミット走査から除外されるため、
#       ランナーは一時ディレクトリ（allowlist 対象外パス）へ複製してから走査する。
set -u

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CFG="$ROOT/.gitleaks.toml"
SCAN="$ROOT/scripts/egress-scan.sh"
FIX="$ROOT/tests/fixtures"

pass=0
fail=0
ok() { echo "  PASS: $1"; pass=$((pass + 1)); }
ng() { echo "  FAIL: $1"; fail=$((fail + 1)); }

if ! command -v gitleaks >/dev/null 2>&1; then
  echo "gitleaks が未インストールです。brew install gitleaks 後に再実行してください。" >&2
  exit 2
fi

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

# gitleaks detect: exit 0 = no leaks / exit 1 = leaks found
scan() { gitleaks detect --no-git --source "$1" --no-banner --redact -c "$CFG" >/dev/null 2>&1; }

echo "[1] flag: 検出されるべき検体"
for f in "$FIX"/flag/*; do
  b="$(basename "$f")"
  cp "$f" "$tmp/$b"
  if scan "$tmp/$b"; then ng "flag/$b は検出されるべきだが no leaks"; else ok "flag/$b 検出"; fi
  rm -f "$tmp/$b"
done

echo "[1b] 生成シークレット（実トークンをリポジトリに置かないため実行時に組み立て）"
# Slack bot token を分割リテラルで連結する。連続マッチが run.sh の本文に残らないので、
# GitHub の push protection にも commit 走査(L1)にも引っかからない。実行時のみ完全な形になる。
gen="$tmp/gen_secret.txt"
printf 'slack: %s%s%s\n' "xoxb-2492348923-" "2348923489234-" "aBcDeFgHiJkLmNoPqRsTuVwX" > "$gen"
if scan "$gen"; then ng "生成した Slack token は検出されるべきだが no leaks"; else ok "生成 Slack token 検出（標準ルール）"; fi
rm -f "$gen"

echo "[2] pass: allowlist で除外されるべき検体"
for f in "$FIX"/pass/*; do
  b="$(basename "$f")"
  cp "$f" "$tmp/$b"
  if scan "$tmp/$b"; then ok "pass/$b 除外(no leaks)"; else ng "pass/$b は除外されるべきだが検出された"; fi
  rm -f "$tmp/$b"
done

echo "[3] L3 egress フック"
for p in "$FIX"/payloads/deny*.json; do
  CLAUDE_PROJECT_DIR="$ROOT" sh "$SCAN" < "$p" >/dev/null 2>&1
  [ $? -eq 2 ] && ok "deny $(basename "$p") → exit 2" || ng "deny $(basename "$p") で exit 2 にならない"
done
for p in "$FIX"/payloads/pass*.json; do
  CLAUDE_PROJECT_DIR="$ROOT" sh "$SCAN" < "$p" >/dev/null 2>&1
  [ $? -eq 0 ] && ok "pass $(basename "$p") → exit 0" || ng "pass $(basename "$p") で exit 0 にならない"
done

echo ""
echo "結果: PASS=$pass FAIL=$fail"
[ "$fail" -eq 0 ]

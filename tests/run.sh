#!/bin/bash
# 双向验证：正例必须报，反例必须不报（误报是安全工具的头号杀手）
set -uo pipefail
export PATH="/usr/local/bin:$PATH"
cd "$(dirname "$0")/.."
PASS=0; FAIL=0
ok(){ echo "  ✅ $1"; PASS=$((PASS+1)); }
bad(){ echo "  ❌ $1"; FAIL=$((FAIL+1)); }

echo ""; echo "  $(node -p "require('./package.json').name") · 双向验证"
echo "  ────────────────────────────────────────────────"

echo ""; echo "  【正例】违规样本（必须报）"
N=$(node bin/cli.mjs --root tests/fixtures/fail/demo-project --quiet 2>&1 | grep -oE '^[0-9]+' | head -1)
[ "${N:-0}" -gt 0 ] && ok "命中 ${N} 条" || bad "违规样本 0 命中 —— 判据可能没生效"

echo ""; echo "  【反例】合规样本（必须 0 命中）"
M=$(node bin/cli.mjs --root tests/fixtures/pass/clean-project --quiet 2>&1 | grep -oE '^[0-9]+' | head -1)
[ "${M:-1}" = "0" ] && ok "0 命中" || bad "误报 ${M} 条"

echo ""; echo "  【溯源】每条规则必须带 source"
python3 - <<'PY' && ok "全部规则均有 source" || bad "有规则缺 source"
import json,glob,sys
bad=[json.load(open(f,encoding='utf-8')).get('id') for f in glob.glob('rules/*.json') if not json.load(open(f,encoding='utf-8')).get('source')]
if bad: print('缺 source:',bad,file=sys.stderr); sys.exit(1)
PY

echo ""; echo "  ────────────────────────────────────────────────"
echo "  通过 $PASS · 失败 $FAIL"; echo ""
[ "$FAIL" -eq 0 ] || exit 1

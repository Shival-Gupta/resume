#!/usr/bin/env bash
# build.sh  — main/scripts/build.sh
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT"

# find python command: python3, python, py -3
PY=""
if command -v python3 >/dev/null 2>&1; then
  PY="python3"
elif command -v python >/dev/null 2>&1; then
  # ensure python is v3
  if python -c 'import sys; sys.exit(0) if sys.version_info[0]==3 else sys.exit(1)'; then
    PY="python"
  fi
elif command -v py >/dev/null 2>&1; then
  PY="py -3"
fi

if [ -z "$PY" ]; then
  echo "[ERROR] No Python 3 found. Install Python 3 and ensure it's on PATH."
  exit 1
fi

echo "[INFO] Using $PY to run generator."
# use eval to support "py -3"
eval "$PY main/scripts/compile_tex.py"

echo "[INFO] Building PDF..."
main/scripts/build_pdf.sh

# copy photo (if referenced in JSON)
PHOTO="$($PY -c "import json,sys;print(json.load(open('main/contents.json'))['meta'].get('photo','') or '')" 2>/dev/null || true)"
if [ -n "$PHOTO" ] && [ -f "main/$PHOTO" ]; then
  mkdir -p public
  cp -f "main/$PHOTO" "public/"
  echo "[INFO] Copied photo -> public/$PHOTO"
fi

echo "[INFO] Build done: public/RESUME_ShivalGupta.pdf"

#!/usr/bin/env bash
# build_pdf.sh  — main/scripts/build_pdf.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
MAIN="$ROOT/main"
PUBLIC="$ROOT/public"
JOB="RESUME_ShivalGupta"
TEX="$MAIN/main.tex"

log(){ echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"; }

if [ ! -f "$TEX" ]; then log "Error: $TEX not found. Run compile_tex first."; exit 2; fi

# prefer latexmk -> xelatex -> pdflatex
if command -v latexmk >/dev/null 2>&1; then
  log "Using latexmk (xelatex)..."
  (cd "$MAIN" && latexmk -pdf -xelatex -silent -jobname="$JOB" main.tex)
elif command -v xelatex >/dev/null 2>&1; then
  log "Using xelatex (two runs)..."
  (cd "$MAIN" && xelatex -interaction=nonstopmode -jobname="$JOB" main.tex)
  (cd "$MAIN" && xelatex -interaction=nonstopmode -jobname="$JOB" main.tex)
elif command -v pdflatex >/dev/null 2>&1; then
  log "Using pdflatex (two runs)..."
  (cd "$MAIN" && pdflatex -interaction=nonstopmode -jobname="$JOB" main.tex)
  (cd "$MAIN" && pdflatex -interaction=nonstopmode -jobname="$JOB" main.tex)
else
  cat <<EOF >&2

[ERROR] No LaTeX engine detected (latexmk / xelatex / pdflatex).

To install:

- Ubuntu / WSL:
    sudo apt-get update
    sudo apt-get install -y texlive-xetex texlive-latex-extra latexmk

- macOS (Homebrew):
    brew install --cask mactex

- Windows:
    Install MiKTeX: https://miktex.org/download
    Or use WSL and install texlive as above.

After installing, re-open your shell so the new binaries are on PATH, then run the build again.

EOF
  exit 3
fi

PDF_SRC="$MAIN/${JOB}.pdf"
if [ -f "$PDF_SRC" ]; then
  mkdir -p "$PUBLIC"
  mv -f "$PDF_SRC" "$PUBLIC/${JOB}.pdf"
  log "PDF produced -> $PUBLIC/${JOB}.pdf"
else
  log "Build failed: expected PDF at $PDF_SRC"
  exit 4
fi

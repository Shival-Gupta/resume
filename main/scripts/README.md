
# Resume Build Scripts

This directory contains all scripts responsible for generating and compiling the resume.

````

/main/scripts
├── compile_tex.py     # JSON → TeX generator
├── build_pdf.sh       # TeX → PDF builder
└── build.sh           # Orchestrator (runs both)

````

These scripts are designed to be:
- **Modular**
- **Cross-platform**
- **CI-friendly**
- **Minimal and predictable**

---

## 📜 Script Overview

### 1. `compile_tex.py`
**Purpose:**  
Generates `main.tex` from:

- `contents.json` (data)
- `layout.tex` (template)

**Features:**
- Escapes LaTeX-unsafe characters
- Renders lists: skills, experience, projects, etc.
- Never modifies layout.tex
- Produces deterministic output

Run manually (from repo root):

```bash
python3 main/scripts/compile_tex.py
````

or use `python` / `py -3` — autodetected in `build.sh`.

---

### 2. `build_pdf.sh`

**Purpose:**
Compiles `main.tex` into `public/RESUME_ShivalGupta.pdf`.

**Features:**

* Prefers:

  1. `latexmk -pdf -xelatex`
  2. fallback `xelatex`
  3. fallback `pdflatex`
* Detects missing compilers and prints exact install instructions.
* Does **not** auto-install (safe and predictable).
* Works on Linux, macOS, Windows (WSL or MiKTeX).

Run manually:

```bash
main/scripts/build_pdf.sh
```

---

### 3. `build.sh` (orchestrator)

**Purpose:**
High-level script that performs a complete build:

1. Detects python3 (`python3`, `python`, `py -3`)
2. Runs the generator (`compile_tex.py`)
3. Runs the PDF compiler (`build_pdf.sh`)
4. Copies profile photo to `public/`
5. Prints final output location

Run from repo root:

```bash
./main/scripts/build.sh
```

or:

```bash
./build_resume.sh
```

---

## ⚙️ Making Scripts Executable

If you're using Linux, macOS, WSL, or Git Bash:

```bash
chmod +x compile_tex.py
chmod +x build_pdf.sh
chmod +x build.sh
```

Windows PowerShell does not require this.

---

## 🧪 CI / GitHub Actions

The CI pipeline runs these scripts in the exact order:

1. `compile_tex.py`
2. `latexmk -pdf -xelatex main.tex`

This guarantees reproducible builds.

---

## ✔️ Summary

This directory contains your **automated resume toolkit**:

* `compile_tex.py` → Generate TeX
* `build_pdf.sh` → Build PDF
* `build.sh` → Run everything

Together they form a clean, modular, and professional automated resume build system.

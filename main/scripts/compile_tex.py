#!/usr/bin/env python3
"""
compile_tex.py
Generate main/main.tex from main/contents.json and main/layout.tex
"""
from pathlib import Path
import json
import sys

ROOT = Path(__file__).resolve().parents[2]
MAIN = ROOT / "main"
CONTENTS = MAIN / "contents.json"
LAYOUT = MAIN / "layout.tex"
OUT = MAIN / "main.tex"

LATEX_ESC = {
    "\\": r"\textbackslash{}",
    "&": r"\&",
    "%": r"\%",
    "$": r"\$",
    "#": r"\#",
    "_": r"\_",
    "{": r"\{",
    "}": r"\}",
    "~": r"\textasciitilde{}",
    "^": r"\textasciicircum{}",
}

def esc(s):
    if s is None:
        return ""
    s = str(s)
    return "".join(LATEX_ESC.get(c, c) for c in s)

def render_skills(sk):
    out = []
    if sk.get("languages"):
        out.append(f"\\resumeItem{{\\textbf{{Languages}}: {esc(', '.join(sk['languages']))}}}")
    if sk.get("web_development"):
        out.append(f"\\resumeItem{{\\textbf{{Web Development}}: {esc(', '.join(sk['web_development']))}}}")
    if sk.get("ai_robotics_iot"):
        out.append(f"\\resumeItem{{\\textbf{{AI, Robotics \\& IoT}}: {esc(', '.join(sk['ai_robotics_iot']))}}}")
    if sk.get("tools"):
        out.append(f"\\resumeItem{{\\textbf{{Tools}}: {esc(', '.join(sk['tools']))}}}")
    return "\n    ".join(out)

def render_projects(ps):
    blocks = []
    for p in ps:
        title = esc(p.get("title", ""))
        dur = esc(p.get("duration", ""))
        tech = esc(", ".join(p.get("tech", [])))
        cert = p.get("certificate", "")
        cert_tex = f"{{\\href{{{cert}}}{{(certificate)}}}}" if cert else ""
        b = [
            "\\resumeSubheading",
            f"    {{{title}}}{{{dur}}}{{{tech}}}{{{cert_tex}}}",
            "    \\resumeSubHeadingList"
        ]
        for it in p.get("items", []):
            b.append("      " + f"\\resumeItem{{{esc(it)}}}")
        b.append("    \\resumeSubHeadingListEnd\n")
        blocks.append("\n".join(b))
    return "\n\n  ".join(blocks)

def render_experience(es):
    blocks = []
    for e in es:
        role = esc(e.get("role", ""))
        dur = esc(e.get("duration", ""))
        comp = esc(e.get("company", ""))
        cert = e.get("certificate", "")
        cert_tex = f"{{\\href{{{cert}}}{{(certificate)}}}}" if cert else ""
        b = [
            "\\resumeSubheading",
            f"    {{{role}}}{{{dur}}}{{{comp}}}{{{cert_tex}}}",
            "    \\resumeSubHeadingList"
        ]
        for it in e.get("items", []):
            b.append("      " + f"\\resumeItem{{{esc(it)}}}")
        b.append("    \\resumeSubHeadingListEnd\n")
        blocks.append("\n".join(b))
    return "\n\n  ".join(blocks)

def render_education(ed):
    out = []
    for e in ed:
        title = esc(e.get("title", ""))
        grade = esc(e.get("grade", ""))
        inst = esc(e.get("institution", ""))
        dur = esc(e.get("duration", ""))
        out.append(f"\\resumeSubheading\n    {{{title}}}{{{grade}}}{{{inst}}}{{{dur}}}")
    return "\n  ".join(out)

def main():
    if not CONTENTS.exists() or not LAYOUT.exists():
        print("Missing contents.json or layout.tex", file=sys.stderr)
        sys.exit(1)

    data = json.loads(CONTENTS.read_text(encoding="utf8"))
    tmpl = LAYOUT.read_text(encoding="utf8")
    meta = data.get("meta", {})

    rep = {
        "{{NAME}}": esc(meta.get("name", "")),
        "{{PHONE}}": esc(meta.get("phone", "")),
        "{{EMAIL}}": esc(meta.get("email", "")),
        "{{GITHUB}}": meta.get("github", ""),
        "{{LINKEDIN}}": meta.get("linkedin", ""),
        "{{WEBSITE}}": meta.get("website", ""),
        "{{TECHNICAL_SKILLS}}": render_skills(data.get("technical_skills", {})),
        "{{PROJECTS}}": render_projects(data.get("projects", [])),
        "{{EXPERIENCE}}": render_experience(data.get("experience", [])),
        "{{EDUCATION}}": render_education(data.get("education", [])),
        "{{EXTRACURRICULAR}}": esc(", ".join(data.get("extracurricular", [])))
    }

    out = tmpl
    for k, v in rep.items():
        out = out.replace(k, v)

    OUT.parent.mkdir(parents=True, exist_ok=True)
    OUT.write_text(out, encoding="utf8")
    print(f"Wrote {OUT}")

if __name__ == "__main__":
    main()

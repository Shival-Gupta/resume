#!/bin/bash
# Exit immediately on errors, treat unset variables as errors, and catch failures in pipelines.
set -euo pipefail

#######################
# Configuration
#######################
NAME="ShivalGupta"
TEXFILE="MAIN.tex"
OUT_JOBNAME="RESUME_ShivalGupta"
README_FILE="README.md"

#######################
# Logging Function
#######################
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"
}

#######################
# Dependency Check Functions
#######################

# Check if a command exists.
check_command() {
    command -v "$1" &> /dev/null
}

# If a required command is missing, optionally install its package.
# Usage: ensure_command <command> [package]
ensure_command() {
    local cmd="$1"
    local pkg="${2:-}"
    if ! check_command "$cmd"; then
        if [ -n "$pkg" ]; then
            log "Command '$cmd' not found. Installing package '$pkg'..."
            sudo apt-get update
            sudo apt-get install "$pkg" -y
        else
            log "Error: Command '$cmd' not found."
            exit 1
        fi
    else
        log "Command '$cmd' is available."
    fi
}

# Check if a package is installed using dpkg; if not, install it.
check_and_install_package() {
    local pkg="$1"
    if ! dpkg -s "$pkg" &> /dev/null; then
        log "Package '$pkg' not found. Installing..."
        sudo apt-get update
        sudo apt-get install "$pkg" -y
    else
        log "Package '$pkg' is already installed."
    fi
}

#######################
# Dependency Checks
#######################
ensure_command "sed"
ensure_command "xelatex" "texlive-xetex"
check_and_install_package "fonts-roboto"

#######################
# PDF Generation Functions
#######################

# Compile the TeX file to PDF using xelatex in nonstop mode.
compile_pdf() {
    log "Compiling '$TEXFILE' to PDF..."
    if ! output=$(xelatex -interaction=nonstopmode -jobname="${OUT_JOBNAME}" "${TEXFILE}" 2>&1); then
        log "Error: LaTeX compilation failed."
        echo "$output" >&2
        exit 1
    fi
    log "Compilation succeeded."
}

# Update (or create) the README file by replacing a placeholder with the generated PDF's name.
update_readme() {
    if [ -f "$README_FILE" ]; then
        log "Updating '$README_FILE'..."
        sed -i "s/RESUME_NAME_DATE\.pdf/${OUT_JOBNAME}.pdf/g" "$README_FILE"
        log "README updated."
    else
        log "Warning: '$README_FILE' not found. Creating a new one."
        cat <<EOF > "$README_FILE"
# Resume PDF

Your generated PDF is: ${OUT_JOBNAME}.pdf

This README was automatically generated on $(date).
EOF
        log "New README created."
    fi
}

#######################
# Main Process
#######################
compile_pdf
update_readme

log "PDF generation complete."

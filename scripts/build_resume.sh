#!/bin/bash

name="ShivalGupta"

# Check if xelatex is available
if ! command -v xelatex &> /dev/null; then
    echo "Error: xelatex command not found. Please make sure it's installed."
    exit 1  # Indicate failure
fi

# Compile LaTeX to PDF directly in the root directory
xelatex_command="xelatex -jobname=\"RESUME_${name}\" RESUME.tex"

# Execute the xelatex command and capture its output
output=$(eval "$xelatex_command" 2>&1)

# Check the exit status of the xelatex command
if [ $? -ne 0 ]; then
    echo "Error compiling LaTeX:"
    echo "$output"
    exit 1  # Indicate failure
fi

# Update README.md (replace placeholders with actual values)
sed -i "s/RESUME_NAME_DATE\.pdf/RESUME_${name}\.pdf/g" README.md

echo "Build complete!"
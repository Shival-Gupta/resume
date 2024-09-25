#!/bin/bash

your_name="ShivalGupta" 

# Compile LaTeX to PDF with your name in the filename
xelatex -output-directory=build/ -jobname="RESUME_${your_name}" RESUME.tex 

# Update README.md (replace placeholders with actual values)
sed -i "s/RESUME_NAME_DATE\.pdf/RESUME_${your_name}\.pdf/g" README.md

echo "Build complete!"
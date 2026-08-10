#!/bin/bash
##############################################################################
# Run Daily Claims Report Generator
# Batch program to generate claims report
##############################################################################

echo "=========================================="
echo "  Daily Claims Report Generator"
echo "=========================================="
echo ""

# Check if program is compiled
if [ ! -f "bin/CLAIMRPT" ]; then
    echo "Error: CLAIMRPT program not found."
    echo "Please run ./scripts/compile.sh first."
    exit 1
fi

# Create reports directory if it doesn't exist
mkdir -p reports

# Run the program
./bin/CLAIMRPT

echo ""
echo "Report generation complete."
echo "Check the reports/ directory for output."

# Made with Bob

#!/bin/bash
##############################################################################
# Run Claims Entry Program
# Interactive program for entering medical claims
##############################################################################

echo "=========================================="
echo "  Health Claims Entry System"
echo "=========================================="
echo ""

# Check if program is compiled
if [ ! -f "bin/CLAIMENTRY" ]; then
    echo "Error: CLAIMENTRY program not found."
    echo "Please run ./scripts/compile.sh first."
    exit 1
fi

# Run the program
./bin/CLAIMENTRY

echo ""
echo "Claims entry session ended."

# Made with Bob

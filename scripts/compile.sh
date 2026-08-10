#!/bin/bash
##############################################################################
# COBOL Compilation Script
# Compiles all COBOL programs in the project
##############################################################################

echo "=========================================="
echo "  COBOL Health Claims System - Compile"
echo "=========================================="
echo ""

# Set colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Create bin directory if it doesn't exist
mkdir -p bin

# Compilation function
compile_program() {
    local program=$1
    local source="src/programs/${program}.cbl"
    local output="bin/${program}"
    
    echo -n "Compiling ${program}... "
    
    if cobc -x -I src/copybooks -o "${output}" "${source}" 2>/dev/null; then
        echo -e "${GREEN}SUCCESS${NC}"
        return 0
    else
        echo -e "${RED}FAILED${NC}"
        echo "Detailed error output:"
        cobc -x -I src/copybooks -o "${output}" "${source}"
        return 1
    fi
}

# Compile all programs
echo "Compiling COBOL programs..."
echo ""

FAILED=0

compile_program "CLAIMENTRY" || FAILED=1
compile_program "CLAIMRPT" || FAILED=1
compile_program "PROVMAINT" || FAILED=1

echo ""
echo "=========================================="

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}All programs compiled successfully!${NC}"
    echo ""
    echo "Executables are in the bin/ directory:"
    ls -lh bin/
else
    echo -e "${RED}Some programs failed to compile.${NC}"
    echo "Please check the error messages above."
    exit 1
fi

echo "=========================================="

# Made with Bob

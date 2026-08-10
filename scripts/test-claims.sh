#!/bin/bash
##############################################################################
# Test Script - Enter Sample Claims
# Automatically enters test claims for demonstration
##############################################################################

echo "=========================================="
echo "  Entering Test Claims"
echo "=========================================="
echo ""

# Check if program is compiled
if [ ! -f "bin/CLAIMENTRY" ]; then
    echo "Error: CLAIMENTRY program not found."
    echo "Please run ./scripts/compile.sh first."
    exit 1
fi

# Create test input file
cat > /tmp/test_claims_input.txt << 'EOF'
1
M000000001
P000000001
2026-04-21
99213
Z00.00
150.00
1
M000000002
P000000002
2026-04-21
99214
E11.9
200.00
1
M000000003
P000000003
2026-04-20
80053
R73.09
85.00
2
EOF

# Run the program with test input
./bin/CLAIMENTRY < /tmp/test_claims_input.txt

# Clean up
rm /tmp/test_claims_input.txt

echo ""
echo "Test claims entry complete!"
echo "Run ./scripts/run-report.sh to generate the report."

# Made with Bob

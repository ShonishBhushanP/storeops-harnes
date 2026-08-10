#!/bin/bash
##############################################################################
# Provider Maintenance System Launcher
# Runs the interactive provider management program
##############################################################################

echo "=========================================="
echo "  Provider Maintenance System"
echo "=========================================="
echo ""

# Check if the program is compiled
if [ ! -f "bin/PROVMAINT" ]; then
    echo "Error: PROVMAINT program not found."
    echo "Please run ./scripts/compile.sh first."
    exit 1
fi

# Check if data directory exists
if [ ! -d "data" ]; then
    echo "Error: data directory not found."
    exit 1
fi

# Check if PROVIDERS.dat exists, create if not
if [ ! -f "data/PROVIDERS.dat" ]; then
    echo "Note: PROVIDERS.dat not found. Creating empty file..."
    touch data/PROVIDERS.dat
fi

# Run the program
echo "Starting Provider Maintenance System..."
echo ""
./bin/PROVMAINT

# Handle temp file replacement if it exists
if [ -f "data/PROVIDERS.tmp" ]; then
    echo "Updating provider file..."
    mv data/PROVIDERS.tmp data/PROVIDERS.dat
fi

echo ""
echo "=========================================="
echo "Provider Maintenance System terminated."
echo "=========================================="

# Made with Bob

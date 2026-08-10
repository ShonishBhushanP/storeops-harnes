#!/bin/bash

# Compile and run the Health Claims Management System Main Menu

echo "Compiling Health Claims Management System..."

# Compile all programs with copybook path
cobc -x -I src/copybooks -o bin/MAINMENU src/programs/MAINMENU.cbl
if [ $? -ne 0 ]; then
    echo "Error compiling MAINMENU"
    exit 1
fi

cobc -x -I src/copybooks -o bin/CLAIMENTRY src/programs/CLAIMENTRY.cbl
if [ $? -ne 0 ]; then
    echo "Error compiling CLAIMENTRY"
    exit 1
fi

cobc -x -I src/copybooks -o bin/PROVMAINT src/programs/PROVMAINT.cbl
if [ $? -ne 0 ]; then
    echo "Error compiling PROVMAINT"
    exit 1
fi

echo "Compilation successful!"
echo ""
echo "Starting Health Claims Management System..."
echo ""

# Run the main menu
./bin/MAINMENU

# Made with Bob

# Health Claims Management System

A COBOL-based application for managing Medicare and Medicaid health claims, designed to run on macOS using GnuCOBOL.

## Overview

This system provides:
- **Main Menu Interface**: Centralized navigation hub for all system functions
- **Claims Management**: Interactive terminal-based UI for entering medical claims with real-time validation
- **Provider Management**: Full CRUD operations for managing healthcare providers
- **Batch Report Generation**: Daily claims report with detailed transaction information
- **Data Management**: Member, provider, and procedure code reference files

## System Requirements

- **macOS** (tested on macOS 11+)
- **GnuCOBOL 3.2+** (installed via Homebrew)
- **Bash shell**

## Installation

### 1. Install GnuCOBOL

If not already installed:

```bash
brew install gnucobol
```

Verify installation:

```bash
cobc --version
```

### 2. Clone or Download the Project

```bash
cd /path/to/bob-cobol-sample
```

## Project Structure

```
bob-cobol-sample/
├── src/
│   ├── copybooks/          # COBOL data structure definitions
│   │   ├── MEMBER.cpy      # Member record layout
│   │   ├── CLAIM.cpy       # Claim record layout
│   │   ├── PROVIDER.cpy    # Provider record layout
│   │   └── PROCEDURE.cpy   # Procedure code layout
│   └── programs/           # COBOL source programs
│       ├── MAINMENU.cbl    # Main menu (entry point)
│       ├── CLAIMENTRY.cbl  # Claims management sub-menu
│       ├── CLAIMRPT.cbl    # Batch report generator
│       └── PROVMAINT.cbl   # Provider management sub-menu
├── data/                   # Data files
│   ├── MEMBERS.dat         # Member master file
│   ├── PROVIDERS.dat       # Provider reference file
│   ├── PROCEDURES.dat      # Procedure code file
│   └── CLAIMS.dat          # Claims transaction file
├── scripts/                # Shell scripts
│   ├── compile.sh          # Compile all programs
│   ├── run-main.sh         # Run main menu (recommended)
│   ├── run-entry.sh        # Run claims entry directly
│   ├── run-report.sh       # Run report generator
│   └── run-provider.sh     # Run provider maintenance directly
├── bin/                    # Compiled executables (created by compile.sh)
└── reports/                # Generated reports (created by run-report.sh)
```

## Quick Start

### 1. Compile the Programs

```bash
./scripts/compile.sh
```

This will compile all COBOL programs and place executables in the `bin/` directory.

### 2. Run the Main Menu (Recommended)

```bash
./scripts/run-main.sh
```

This launches the main menu interface where you can:
- Navigate to **Claims Management** for entering and managing claims
- Navigate to **Provider Management** for managing healthcare providers
- Exit the system

The main menu provides a centralized entry point with sub-menus that return to the main menu when finished.

### 3. Alternative: Run Programs Directly

You can also run individual programs directly:

**Enter Claims:**
```bash
./scripts/run-entry.sh
```

**Manage Providers:**
```bash
./scripts/run-provider.sh
```

**Generate Daily Report:**
```bash
./scripts/run-report.sh
```

### Sample Test Data

Member IDs: `M000000001` through `M000000010`
Provider IDs: `P000000001` through `P000000010`
Procedure Codes: `99213`, `99214`, `80053`, `85025`, `93000`, etc.

**Example Claim Entry:**
```
Member ID: M000000001
Provider ID: P000000001
Service Date: 2026-04-21
Procedure Code: 99213
Diagnosis Code: Z00.00
Billed Amount: 150.00
```

## Data Files

### Members (data/MEMBERS.dat)

Contains 10 sample members with:
- Member demographics (name, DOB, gender, address)
- Plan type (Medicare, Medicaid, or Dual)
- Eligibility dates and status

### Providers (data/PROVIDERS.dat)

Contains 10 sample healthcare providers with:
- Provider information (name, specialty, address)
- NPI and Tax ID
- Active status

### Procedures (data/PROCEDURES.dat)

Contains 15 common medical procedure codes with:
- CPT codes
- Descriptions
- Categories
- Standard charges

### Claims (data/CLAIMS.dat)

Transaction file that stores all entered claims. Initially empty, populated by the claims entry program.

## Program Details

### MAINMENU - Main Menu Program

**Features:**
- Centralized navigation hub
- Menu-driven interface
- Launches sub-menu programs (Claims and Provider Management)
- Clean exit from the system

**Menu Options:**
1. **Claims Management** - Navigate to claims entry sub-menu
2. **Provider Management** - Navigate to provider maintenance sub-menu
3. **Exit** - Exit the entire system

### CLAIMENTRY - Claims Management Sub-Menu

**Features:**
- Menu-driven interface for claims operations
- Real-time validation against reference files
- Automatic claim ID generation
- Date/time stamping
- Error handling and user feedback
- Returns to main menu when finished

**Menu Options:**
1. **Enter New Claim** - Interactive claim entry with validation
2. **Return to Main Menu** - Go back to the main menu

**Validation Rules:**
- Member must exist and be active
- Provider must exist and be active
- Procedure code must exist in reference file
- All required fields must be provided

**Claim Status:**
- `P` - Pending (initial status)
- `A` - Approved
- `D` - Denied
- `X` - Paid

### CLAIMRPT - Daily Claims Report

**Features:**
- Formatted report with headers and page numbers
- Detail lines with member and provider names
- Summary totals (count, billed, allowed amounts)
- Automatic report file naming with date

**Report Sections:**
1. Header with date and page number
2. Column headers
3. Detail lines (one per claim)
4. Summary totals

### PROVMAINT - Provider Management Sub-Menu

**Features:**
- Menu-driven interface for provider management
- Create new providers with automatic ID generation
- Update provider information (all fields editable)
- Delete providers (marks as inactive, preserves data)
- Reactivate previously deleted providers
- List all providers with status
- Search for providers by ID
- Returns to main menu when finished

**Menu Options:**
1. **Create New Provider** - Add new providers to the system
2. **Update Provider** - Modify any provider field (name, specialty, address, etc.)
3. **Delete Provider** - Mark providers as inactive (soft delete)
4. **Reactivate Provider** - Reactivate an inactive provider (only works on inactive providers)
5. **List All Providers** - Display all providers with their current status
6. **Search Provider by ID** - Find and display specific provider details
7. **Return to Main Menu** - Go back to the main menu

**Provider Fields:**
- ID (auto-generated)
- Name
- Specialty
- Address, City, State, ZIP
- Phone
- NPI (National Provider Identifier)
- Tax ID
- Status (Active/Inactive)

## Development Notes

### COBOL Standards

- Written in COBOL-85 standard
- Compatible with GnuCOBOL 3.2+
- Uses LINE SEQUENTIAL file organization (text files)
- Fixed-format source code (columns 7-72)

### File Formats

All data files use fixed-length records:
- **MEMBERS.dat**: 237 characters per record
- **PROVIDERS.dat**: 207 characters per record
- **PROCEDURES.dat**: 109 characters per record
- **CLAIMS.dat**: 171 characters per record

### Copybooks

Copybooks define data structures and are included in programs using:
```cobol
COPY MEMBER.
COPY CLAIM.
COPY PROVIDER.
COPY PROCEDURE.
```

The `-I src/copybooks` compiler flag tells GnuCOBOL where to find these files.

## Troubleshooting

### Compilation Errors

If compilation fails:
1. Verify GnuCOBOL is installed: `cobc --version`
2. Check that all copybook files exist in `src/copybooks/`
3. Review error messages for syntax issues

### Runtime Errors

**File Not Found:**
- Ensure you're running from the project root directory
- Check that data files exist in the `data/` directory

**File Status Errors:**
- File status codes are displayed in error messages
- Common codes: `00` = success, `35` = file not found, `37` = permission denied

**Validation Failures:**
- Verify test data IDs match those in reference files
- Check that members/providers have status 'A' (active)

## Extending the System

### Adding New Fields

1. Update the appropriate copybook in `src/copybooks/`
2. Modify data files to match new record length
3. Update programs to handle new fields
4. Recompile

### Adding New Programs

1. Create new `.cbl` file in `src/programs/`
2. Add compilation step to `scripts/compile.sh`
3. Create run script in `scripts/`
4. Update this README

### Adding New Validations

Modify the `VALIDATE-CLAIM` section in `CLAIMENTRY.cbl` to add:
- Date range checks
- Amount validations
- Business rule enforcement

## Sample Workflow

1. **Compile the system:**
   ```bash
   ./scripts/compile.sh
   ```

2. **Launch the main menu:**
   ```bash
   ./scripts/run-main.sh
   ```

3. **From the main menu, select option 2 (Provider Management):**
   - List existing providers
   - Add new providers
   - Update provider information
   - Mark providers as inactive
   - Return to main menu

4. **From the main menu, select option 1 (Claims Management):**
   - Enter 3-5 claims using sample data
   - Try both valid and invalid data to see validation
   - Return to main menu

5. **Exit the main menu (option 3)**

6. **Generate the daily report:**
   ```bash
   ./scripts/run-report.sh
   ```

7. **View the report:**
   ```bash
   cat reports/CLAIMS_REPORT_*.txt
   ```

8. **View the data files:**
   ```bash
   cat data/CLAIMS.dat
   cat data/PROVIDERS.dat
   ```

## License

See LICENSE file for details.

## Author

COBOL Developer - Health Claims Management System

## Version History

- **v1.2** (2026-04-21): UI Restructure - Main Menu System
  - Added MAINMENU program as centralized entry point
  - Restructured CLAIMENTRY as Claims Management sub-menu
  - Restructured PROVMAINT as Provider Management sub-menu
  - Sub-menus now return to main menu instead of exiting
  - Only main menu has exit option
  - Improved navigation and user experience

- **v1.1** (2026-04-21): Provider Management Feature
  - Added PROVMAINT program for full provider CRUD operations
  - Create, update, delete, list, and search providers
  - Automatic provider ID generation
  - Soft delete (inactive status) preserves data integrity

- **v1.0** (2026-04-21): Initial release
  - Claims entry program with validation
  - Daily claims report generator
  - Sample reference data files
  - macOS/GnuCOBOL compatibility
#!/usr/bin/env python3
"""Build the Business Rules Extraction (BRE) deliverables.

Generates, from the single rule catalogue held in this file:
  * docs/BRE/BUSINESS_RULES_CATALOGUE.md
  * docs/BRE/ABS_BRE_HealthClaims.xlsx  (ABS_BRE template column layout)

Every rule is written in business language only, as required by the
COBOL_BRE_Prompt brief.
"""

from pathlib import Path

import openpyxl
from openpyxl.styles import Alignment, Border, Font, PatternFill, Side

ROOT = Path(__file__).resolve().parent.parent
OUT_DIR = ROOT / "docs" / "BRE"

HEADERS = [
    "Area",
    "Functionality",
    "Sub functionality",
    "BRE-ID",
    "Business  Rule/Process Decsription\nFormat # ",
    "LOB",
    "State",
    "Claim Type (If Applicable)",
    "Upstream and downstream systems and interfaces,if Applicable)",
    "Any additional Information that cannot be captured in the gvien columsn",
]

ALL_LOB = "Medicare, Medicaid, Dual"
ALL_STATES = "All"
NA = "Not applicable"

# (area, functionality, sub functionality, bre_id, rule, lob, state,
#  claim_type, interfaces, additional)
RULES = [
    # ---------------------------------------------------------------- Navigation
    (
        "Claims", "Intake", "Service navigation and session control",
        "BRE-HCM-001",
        "The claims service is offered as a single point of entry that gives the "
        "user exactly three choices: handle claims, maintain provider records, or "
        "end the session. No other work can be started from this point.",
        ALL_LOB, ALL_STATES, "All", "Claims handling desk; Provider records desk",
        "",
    ),
    (
        "Claims", "Intake", "Service navigation and session control",
        "BRE-HCM-002",
        "If the user selects anything other than one of the three offered choices, "
        "no work is started, the user is told the selection is not valid, and the "
        "same three choices are offered again. The session continues to offer the "
        "choices until the user explicitly chooses to end it.",
        ALL_LOB, ALL_STATES, "All", NA,
        "There is no limit on the number of invalid attempts and no lock-out.",
    ),
    (
        "Claims", "Intake", "Service navigation and session control",
        "BRE-HCM-003",
        "Claims handling and provider maintenance are run as separate pieces of "
        "work. Leaving one of them returns the user to the three main choices; it "
        "does not end the session.",
        ALL_LOB, ALL_STATES, "All", NA, "",
    ),

    # ---------------------------------------------------------------- Claim capture
    (
        "Claims", "Intake", "Claim registration - data captured",
        "BRE-CLM-101",
        "A claim can only be registered when all six of the following have been "
        "supplied: the patient's membership reference, the treating provider's "
        "reference, the date the service was given, the procedure performed, the "
        "diagnosis, and the amount billed. The process asks for each of them in "
        "that order and none may be skipped.",
        ALL_LOB, ALL_STATES, "Professional",
        "Member register; Provider register; Procedure catalogue; Claim register",
        "No other claim details (place of service, units, modifiers, referring "
        "provider) are captured at all.",
    ),
    (
        "Claims", "Intake", "Claim registration - data captured",
        "BRE-CLM-102",
        "The amount billed on a claim may be up to 9,999,999.99 and is held to two "
        "decimal places. Amounts above that ceiling cannot be registered.",
        ALL_LOB, ALL_STATES, "Professional", NA,
        "There is no minimum billed amount; a claim billed at zero is accepted.",
    ),
    (
        "Claims", "Pre-loaders", "Claim registration - member eligibility check",
        "BRE-CLM-103",
        "A claim is only acceptable if the membership reference quoted belongs to a "
        "member on the membership register and that member is currently active. If "
        "the member is on the register but is suspended or no longer covered, the "
        "claim is refused and the user is told the member is not active.",
        ALL_LOB, ALL_STATES, "Professional", "Member register",
        "Eligibility is judged only on the member's current standing. The member's "
        "cover start and end dates are not compared with the date of service, so a "
        "service given outside the member's period of cover is still accepted.",
    ),
    (
        "Claims", "Pre-loaders", "Claim registration - member eligibility check",
        "BRE-CLM-104",
        "If the membership reference quoted does not appear on the membership "
        "register at all, the claim is refused and the user is told the member "
        "cannot be found.",
        ALL_LOB, ALL_STATES, "Professional", "Member register",
        "The reference must match exactly, character for character; no partial or "
        "name-based matching is attempted.",
    ),
    (
        "Claims", "Pre-loaders", "Claim registration - provider check",
        "BRE-CLM-105",
        "A claim is only acceptable if the provider quoted is on the provider "
        "register and is currently active. A provider that has been withdrawn from "
        "service cannot have new claims registered against them, and the user is "
        "told the provider is not active. A provider that is not on the register at "
        "all is likewise refused.",
        ALL_LOB, ALL_STATES, "Professional", "Provider register",
        "Withdrawing a provider stops new claims only; claims already registered "
        "against that provider are unaffected.",
    ),
    (
        "Claims", "Pre-loaders", "Claim registration - procedure check",
        "BRE-CLM-106",
        "A claim is only acceptable if the procedure quoted appears in the catalogue "
        "of recognised procedures. An unrecognised procedure causes the claim to be "
        "refused.",
        ALL_LOB, ALL_STATES, "Professional", "Procedure catalogue",
        "The catalogue also holds a standard charge for each procedure, but that "
        "charge is never compared with the amount billed, so a claim billed far "
        "above the standard charge passes unchallenged.",
    ),
    (
        "Claims", "Pre-loaders", "Claim registration - unchecked information",
        "BRE-CLM-107",
        "The date of service and the diagnosis are recorded exactly as supplied and "
        "are never checked. A claim with a missing, malformed, future or "
        "implausibly old date of service, or with a diagnosis that does not exist, "
        "is still accepted provided the member, provider and procedure checks pass.",
        ALL_LOB, ALL_STATES, "Professional", NA,
        "Recognised control gap: no date validation, no diagnosis validation, and no "
        "check that the diagnosis supports the procedure.",
    ),
    (
        "Claims", "Pre-loaders", "Claim registration - acceptance decision",
        "BRE-CLM-108",
        "All three checks (member, provider, procedure) are always carried out in "
        "full, so the user is shown every problem with a claim at once rather than "
        "only the first. The claim is registered only if all three succeed; if any "
        "one fails, the claim is not registered and the user is told it was "
        "rejected because of validation problems.",
        ALL_LOB, ALL_STATES, "Professional", NA, "",
    ),
    (
        "Claims", "Pre-loaders", "Claim registration - acceptance decision",
        "BRE-CLM-109",
        "A rejected claim leaves no trace: nothing is recorded, no rejection notice "
        "is produced, and nothing is held for follow-up. The details must be "
        "re-keyed in full if the claim is to be submitted again.",
        ALL_LOB, ALL_STATES, "Professional", NA,
        "Recognised control gap: rejected submissions cannot be reported on or "
        "audited afterwards.",
    ),
    (
        "Claims", "Pre-loaders", "Claim registration - reference data unavailable",
        "BRE-CLM-110",
        "If the membership register, the provider register or the procedure "
        "catalogue cannot be consulted, the corresponding check is treated as "
        "failed and the claim is not registered. Business consequence: while any "
        "one reference source is unavailable, no claims at all can be taken on.",
        ALL_LOB, ALL_STATES, "Professional",
        "Member register; Provider register; Procedure catalogue",
        "Claims are never provisionally accepted pending later checking.",
    ),
    (
        "Claims", "Online Adjudication", "Claim reference number allocation",
        "BRE-CLM-111",
        "Every accepted claim is given a reference made up of a fixed claim marker, "
        "the date the claim was taken on, and a sequence number counting the claims "
        "taken on so far in the current sitting, starting again at one each sitting.",
        ALL_LOB, ALL_STATES, "Professional", NA,
        "Recognised control gap: because the count restarts every sitting, two "
        "claims taken on in different sittings on the same day receive the same "
        "reference.",
    ),
    (
        "Claims", "Claims pricing", "Allowed amount determination at intake",
        "BRE-CLM-112",
        "The amount allowed on a newly registered claim is always set equal to the "
        "full amount billed. No fee schedule, contracted rate, discount or "
        "reasonable-and-customary limit is applied at the point of registration.",
        ALL_LOB, ALL_STATES, "Professional", NA,
        "Any repricing must therefore happen outside this process.",
    ),
    (
        "Claims", "Online Adjudication", "Claim status on registration",
        "BRE-CLM-113",
        "Every newly registered claim starts as pending, with nothing yet paid and "
        "no reason for refusal recorded. No claim is ever approved, refused or paid "
        "by the registration process itself; those outcomes must be applied later "
        "by another part of the business.",
        ALL_LOB, ALL_STATES, "Professional", NA,
        "There is no automatic adjudication and no auto-approval threshold.",
    ),
    (
        "Claims", "Online Adjudication", "Claim dating",
        "BRE-CLM-114",
        "The date the claim is treated as submitted, and the date and time it was "
        "taken on, are all recorded as the moment of registration. A claim received "
        "earlier and keyed later is therefore dated as if it had been submitted on "
        "the day of keying.",
        ALL_LOB, ALL_STATES, "Professional", NA,
        "Consequence: any ageing, timeliness or prompt-payment measure based on "
        "these dates understates the true elapsed time.",
    ),
    (
        "Claims", "Intake", "Claim registration - duplicate handling",
        "BRE-CLM-115",
        "An accepted claim is added to the claim register alongside all existing "
        "claims; nothing already recorded is ever changed or replaced. The same "
        "member, provider, date of service, procedure and amount may be registered "
        "any number of times.",
        ALL_LOB, ALL_STATES, "Professional", "Claim register",
        "Recognised control gap: no duplicate detection of any kind.",
    ),
    (
        "Claims", "Intake", "Claim registration - session close",
        "BRE-CLM-116",
        "When the person finishes taking on claims, they are told how many claims "
        "they registered during that sitting. Attempts that were rejected are not "
        "counted.",
        ALL_LOB, ALL_STATES, "Professional", NA, "",
    ),
    (
        "Claims", "Intake", "Claim registration - written record failure",
        "BRE-CLM-117",
        "If the claim register cannot be written to, the claim is not recorded even "
        "though every check passed. The user is told the record could not be "
        "stored; nothing is held for retry.",
        ALL_LOB, ALL_STATES, "Professional", "Claim register", "",
    ),

    # ---------------------------------------------------------------- Reporting
    (
        "Claims", "Reporting", "Daily claims report - production and naming",
        "BRE-RPT-001",
        "A claims report is produced on demand and is identified by the day it was "
        "produced. Producing it a second time on the same day completely replaces "
        "the earlier version for that day; no history of earlier runs is kept.",
        ALL_LOB, ALL_STATES, "All", "Claim register; Member register; Provider register",
        "Category not present in the template list; recorded under a reporting "
        "heading for this legacy service.",
    ),
    (
        "Claims", "Reporting", "Daily claims report - population selected",
        "BRE-RPT-002",
        "Every claim held on the register is included in the report, whatever its "
        "status and whenever it was submitted or serviced. Although presented as a "
        "daily report, it is in fact a complete listing of all claims ever "
        "registered, and grows with every run.",
        ALL_LOB, ALL_STATES, "All", "Claim register",
        "Recognised gap: no selection by date, status, provider, member or amount.",
    ),
    (
        "Claims", "Reporting", "Daily claims report - member identification",
        "BRE-RPT-003",
        "For each claim the member's name is looked up from the membership register "
        "and shown next to the claim. If the member cannot be found, the claim is "
        "still reported and the member is shown as unknown rather than being "
        "excluded or flagged as an error.",
        ALL_LOB, ALL_STATES, "All", "Member register",
        "The same fallback applies when the membership register cannot be consulted "
        "at all: the report still completes with all members shown as unknown.",
    ),
    (
        "Claims", "Reporting", "Daily claims report - provider identification",
        "BRE-RPT-004",
        "The treating provider's name is also looked up for every claim, with an "
        "unknown-provider fallback when it cannot be found. The name obtained is "
        "not shown anywhere on the report; only the provider's reference is printed.",
        ALL_LOB, ALL_STATES, "All", "Provider register",
        "Recognised inefficiency: the provider look-up is performed for every claim "
        "yet contributes nothing to the output.",
    ),
    (
        "Claims", "Reporting", "Daily claims report - status presentation",
        "BRE-RPT-005",
        "Each claim's standing is reported in plain words as pending, approved, "
        "refused or paid. Any claim whose standing is not one of these four is "
        "reported as unknown rather than being suppressed.",
        ALL_LOB, ALL_STATES, "All", NA, "",
    ),
    (
        "Claims", "Reporting", "Daily claims report - layout and pagination",
        "BRE-RPT-006",
        "The report is laid out for wide printing. A heading block carrying the "
        "report title, the production date, the page number and the column titles "
        "is printed at the start and repeated once more than fifty claim lines have "
        "been placed on a page. Pages are numbered consecutively from one.",
        ALL_LOB, ALL_STATES, "All", NA, "",
    ),
    (
        "Claims", "Reporting", "Daily claims report - totals and summary",
        "BRE-RPT-007",
        "Running totals of the amounts billed and the amounts allowed are "
        "accumulated across every claim reported and printed as a totals line, "
        "followed by a summary giving the number of claims reported, the total "
        "billed and the total allowed.",
        ALL_LOB, ALL_STATES, "All", NA, "",
    ),
    (
        "Claims", "Reporting", "Daily claims report - amounts paid",
        "BRE-RPT-008",
        "The amount already paid on each claim is accumulated but is never shown, "
        "either per claim or in the summary. The report therefore gives no view of "
        "money actually disbursed, only of amounts billed and allowed.",
        ALL_LOB, ALL_STATES, "All", NA,
        "Recognised gap for financial reconciliation.",
    ),
    (
        "Claims", "Reporting", "Daily claims report - run failure",
        "BRE-RPT-009",
        "If the report cannot be created, or the claim register cannot be read, the "
        "run stops immediately and no report at all is produced; a partial report is "
        "never issued.",
        ALL_LOB, ALL_STATES, "All", "Claim register", "",
    ),
    (
        "Claims", "Reporting", "Daily claims report - completion notice",
        "BRE-RPT-010",
        "On completion the operator is told which report was produced, how many "
        "claims it covered and the total amount billed, so the run can be checked "
        "off before the report is distributed.",
        ALL_LOB, ALL_STATES, "All", NA, "",
    ),

    # ---------------------------------------------------------------- Provider
    (
        "Provider", "Demo Provider ", "Provider maintenance - permitted actions",
        "BRE-PRV-001",
        "Provider records may only be added, amended, withdrawn from service, "
        "restored to service, listed in full, or looked up individually. Any other "
        "selection is refused and the choices are offered again.",
        ALL_LOB, ALL_STATES, NA, "Provider register", "",
    ),
    (
        "Provider", "Demo Provider ", "Provider reference allocation",
        "BRE-PRV-002",
        "A new provider's reference is allocated by the business, not by the user. "
        "It is formed from a provider marker followed by a number one higher than "
        "the number carried by the last provider record held, padded to a fixed "
        "length. The very first provider ever set up is numbered one.",
        ALL_LOB, ALL_STATES, NA, "Provider register",
        "Recognised control gap: the number is taken from the last record held "
        "rather than the highest number in use, so if records are ever held out of "
        "sequence an existing reference can be issued a second time.",
    ),
    (
        "Provider", "Demo Provider ", "Provider set-up - details captured",
        "BRE-PRV-003",
        "Setting up a provider captures the practice name, the specialty, the full "
        "address, the telephone number, the national provider identifier and the tax "
        "registration number. Every one of these is accepted exactly as supplied.",
        ALL_LOB, ALL_STATES, NA, NA,
        "Recognised control gap: nothing is mandatory and nothing is validated - "
        "the identifier is not checked for length or format, the state is not "
        "checked against a list, and no check is made for a provider already set up "
        "with the same identifier, tax number or name.",
    ),
    (
        "Provider", "Demo Provider ", "Provider set-up - initial standing",
        "BRE-PRV-004",
        "A newly set-up provider is always placed in service immediately and is "
        "therefore eligible to have claims registered against them from that moment. "
        "There is no way to set one up as pending or out of service.",
        ALL_LOB, ALL_STATES, NA, "Claims intake", "",
    ),
    (
        "Provider", "Demo Provider ", "Provider set-up - confirmation",
        "BRE-PRV-005",
        "No provider is added until the user explicitly confirms it. Anything other "
        "than a positive confirmation abandons the set-up and nothing is recorded, "
        "although the reference that had been allocated is not reused and is "
        "effectively skipped.",
        ALL_LOB, ALL_STATES, NA, NA, "",
    ),
    (
        "Provider", "Demo Provider ", "Provider amendment - identification",
        "BRE-PRV-006",
        "A provider can only be amended if the exact reference quoted is held. The "
        "current details, including whether the provider is in service, are "
        "displayed before any change is made. If the reference is not held, the user "
        "is told so and no amendment takes place.",
        ALL_LOB, ALL_STATES, NA, "Provider register",
        "Look-up is by exact reference only; searching by name, identifier or "
        "specialty is not possible.",
    ),
    (
        "Provider", "Demo Provider ", "Provider amendment - fields and commitment",
        "BRE-PRV-007",
        "Any of the practice name, specialty, address, city, state, postal code, "
        "telephone, national provider identifier, tax registration number, and "
        "in-service standing may be amended, one at a time and as many times as "
        "wanted. Changes are held provisionally and take effect on the register only "
        "when the user chooses to save and leave; leaving the amendment step always "
        "saves, so there is no way to abandon changes once made.",
        ALL_LOB, ALL_STATES, NA, "Provider register",
        "Recognised control gap: no confirmation is asked for on amendment, unlike "
        "set-up, withdrawal and restoration, and no record is kept of what was "
        "changed, by whom or when.",
    ),
    (
        "Provider", "Demo Provider ", "Provider amendment - standing change",
        "BRE-PRV-008",
        "A provider's in-service standing may be changed directly during amendment "
        "to in service or out of service. The value supplied is not checked, so a "
        "standing other than the two recognised ones can be recorded; a provider in "
        "that condition is treated as not in service for claims purposes and is "
        "shown as out of service on listings.",
        ALL_LOB, ALL_STATES, NA, "Claims intake",
        "This route bypasses the confirmation required by the withdrawal and "
        "restoration processes.",
    ),
    (
        "Provider", "Demo Provider ", "Provider amendment - application to register",
        "BRE-PRV-009",
        "Amendments are applied by rewriting the provider register in its existing "
        "order, changing only the provider concerned and leaving every other record "
        "exactly as it was. If the register cannot be worked with at that moment, no "
        "change is applied at all.",
        ALL_LOB, ALL_STATES, NA, "Provider register", "",
    ),
    (
        "Provider", "Demo Provider ", "Provider withdrawal (soft delete)",
        "BRE-PRV-010",
        "A provider is never physically removed. Deletion means marking the provider "
        "as out of service, so the record and its history remain available. The "
        "provider must be found and must currently be in service; if they are "
        "already out of service the user is told and nothing happens. Withdrawal "
        "requires explicit confirmation, and anything other than a positive "
        "confirmation cancels it.",
        ALL_LOB, ALL_STATES, NA, "Claims intake; Claims reporting",
        "Business effect: no new claims may be registered against the provider, but "
        "existing claims and reports are unaffected.",
    ),
    (
        "Provider", "Demo Provider ", "Provider restoration",
        "BRE-PRV-011",
        "A provider that is out of service may be restored. The provider must be "
        "found and must currently be out of service; if they are already in service "
        "the user is told and nothing happens. Restoration requires explicit "
        "confirmation, and on restoration the provider immediately becomes eligible "
        "for new claims again.",
        ALL_LOB, ALL_STATES, NA, "Claims intake",
        "There is no waiting period, re-credentialling step or approval hierarchy.",
    ),
    (
        "Provider", "Demo Provider ", "Provider listing",
        "BRE-PRV-012",
        "The full provider listing shows every provider held, both in service and "
        "out of service, giving the reference, practice name, specialty, location "
        "and standing, and ends with a count of all providers held.",
        ALL_LOB, ALL_STATES, NA, "Provider register",
        "Out-of-service providers are not excluded and the count is of all records, "
        "not of active providers.",
    ),
    (
        "Provider", "Demo Provider ", "Provider look-up",
        "BRE-PRV-013",
        "A single provider may be looked up by quoting their exact reference, which "
        "displays their full details including standing. If no provider carries that "
        "reference the user is told none was found.",
        ALL_LOB, ALL_STATES, NA, "Provider register", "",
    ),
]


def build_markdown() -> str:
    lines = [
        "# Business Rules Catalogue - Health Claims Management Service",
        "",
        "Audience: operations managers, product owners, auditors and compliance "
        "officers. Every rule below describes the business process as a person "
        "would carry it out by hand. No technical detail is included.",
        "",
        "Scope: the complete claims and provider service, covering service "
        "navigation, claim registration, claims reporting and provider record "
        "maintenance.",
        "",
        "## How to read this catalogue",
        "",
        "* Each rule carries a unique reference so it can be cited in audit and "
        "requirement work.",
        "* Rules marked as a recognised gap describe a control that a reader might "
        "reasonably expect to exist but which the business process does not "
        "currently apply.",
        "* All rules apply to Medicare, Medicaid and dual-eligible business in every "
        "state; the service makes no distinction between them.",
        "",
    ]

    current = None
    for area, func, sub, rid, rule, lob, state, ctype, iface, extra in RULES:
        heading = f"{area} - {func}"
        if heading != current:
            current = heading
            lines += [f"## {heading}", ""]
        lines += [f"### {rid} - {sub}", "", rule, ""]
        if iface and iface != NA:
            lines += [f"*Information relied on or updated:* {iface}", ""]
        if extra:
            lines += [f"*Note:* {extra}", ""]

    lines += [
        "## Completeness statement",
        "",
        "Each step of the service was reviewed in order from beginning to end. "
        "Every step that carries a business meaning has contributed at least one "
        "rule above. The following steps carry no business meaning and are recorded "
        "here for completeness only: the opening and closing greetings, the "
        "on-screen banners and menu headings, and the internal preparation carried "
        "out at the start of each sitting (clearing counters and noting the current "
        "date). Where the same step is used in more than one place - for example "
        "locating a provider by reference, or rewriting the provider register after "
        "a change - the rule is stated once and applies wherever that step occurs.",
        "",
    ]
    return "\n".join(lines)


def build_workbook(path: Path) -> None:
    wb = openpyxl.Workbook()
    ws = wb.active
    ws.title = "ABS_BRE_Area"

    header_fill = PatternFill("solid", fgColor="1F4E78")
    header_font = Font(bold=True, color="FFFFFF")
    thin = Side(style="thin", color="BFBFBF")
    border = Border(left=thin, right=thin, top=thin, bottom=thin)

    ws.append(HEADERS)
    for cell in ws[1]:
        cell.fill = header_fill
        cell.font = header_font
        cell.border = border
        cell.alignment = Alignment(wrap_text=True, vertical="center")
    ws.row_dimensions[1].height = 45

    for row in RULES:
        ws.append(list(row))

    for row in ws.iter_rows(min_row=2):
        for cell in row:
            cell.alignment = Alignment(wrap_text=True, vertical="top")
            cell.border = border

    widths = [14, 22, 34, 14, 80, 22, 8, 14, 34, 46]
    for idx, width in enumerate(widths, start=1):
        ws.column_dimensions[openpyxl.utils.get_column_letter(idx)].width = width

    ws.freeze_panes = "A2"
    ws.auto_filter.ref = f"A1:J{ws.max_row}"

    wb.save(path)


def main() -> None:
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    (OUT_DIR / "BUSINESS_RULES_CATALOGUE.md").write_text(build_markdown())
    build_workbook(OUT_DIR / "ABS_BRE_HealthClaims.xlsx")
    print(f"Wrote {len(RULES)} business rules to {OUT_DIR}")


if __name__ == "__main__":
    main()

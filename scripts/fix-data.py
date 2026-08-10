#!/usr/bin/env python3
"""
Fix data file formatting to match COBOL copybook layouts
"""

# Member record: 209 characters total
# Fields: ID(10) + LastName(30) + FirstName(20) + DOB(10) + Gender(1) + 
#         Address(50) + City(30) + State(2) + Zip(10) + Phone(15) + 
#         PlanType(10) + EffDate(10) + TermDate(10) + Status(1)

members = [
    ("M000000001", "Smith", "John", "1945-03-15", "M", "123 Main Street", "Springfield", "IL", "60601", "555-123-4567", "MEDICARE", "2020-01-01", "", "A"),
    ("M000000002", "Johnson", "Mary", "1950-07-22", "F", "456 Oak Avenue", "Chicago", "IL", "60611", "555-234-5678", "MEDICAID", "2019-06-15", "", "A"),
    ("M000000003", "Williams", "Robert", "1938-11-30", "M", "789 Elm Street", "Peoria", "IL", "61602", "555-345-6789", "DUAL", "2021-03-10", "", "A"),
    ("M000000004", "Brown", "Patricia", "1955-02-18", "F", "321 Pine Road", "Rockford", "IL", "61101", "555-456-7890", "MEDICARE", "2020-09-01", "", "A"),
    ("M000000005", "Davis", "Michael", "1942-08-25", "M", "654 Maple Drive", "Naperville", "IL", "60540", "555-567-8901", "MEDICAID", "2018-12-20", "", "A"),
]

# Provider record: 223 characters total
# Fields: ID(10) + Name(50) + Specialty(30) + Address(50) + City(30) +
#         State(2) + Zip(10) + Phone(15) + NPI(10) + TaxID(15) + Status(1)

providers = [
    ("P000000001", "City Medical Center", "General Practice", "123 Hospital Drive", "Chicago", "IL", "60611", "555-100-2000", "1234567890", "12-3456789", "A"),
    ("P000000002", "Springfield Family Practice", "Family Medicine", "456 Clinic Road", "Springfield", "IL", "62701", "555-200-3000", "2345678901", "23-4567890", "A"),
    ("P000000003", "Peoria Cardiology Associates", "Cardiology", "789 Heart Lane", "Peoria", "IL", "61602", "555-300-4000", "3456789012", "34-5678901", "A"),
    ("P000000004", "Rockford Orthopedic Clinic", "Orthopedics", "321 Bone Street", "Rockford", "IL", "61101", "555-400-5000", "4567890123", "45-6789012", "A"),
    ("P000000005", "Naperville Urgent Care", "Urgent Care", "654 Quick Avenue", "Naperville", "IL", "60540", "555-500-6000", "5678901234", "56-7890123", "A"),
]

def format_member(data):
    """Format member record to exactly 209 characters"""
    id, last, first, dob, gender, addr, city, state, zip, phone, plan, eff, term, status = data
    
    record = (
        id.ljust(10) +
        last.ljust(30) +
        first.ljust(20) +
        dob.ljust(10) +
        gender.ljust(1) +
        addr.ljust(50) +
        city.ljust(30) +
        state.ljust(2) +
        zip.ljust(10) +
        phone.ljust(15) +
        plan.ljust(10) +
        eff.ljust(10) +
        term.ljust(10) +
        status.ljust(1)
    )
    
    assert len(record) == 209, f"Member record length is {len(record)}, expected 209"
    return record

def format_provider(data):
    """Format provider record to exactly 207 characters"""
    id, name, spec, addr, city, state, zip, phone, npi, tax, status = data
    
    record = (
        id.ljust(10) +
        name.ljust(50) +
        spec.ljust(30) +
        addr.ljust(50) +
        city.ljust(30) +
        state.ljust(2) +
        zip.ljust(10) +
        phone.ljust(15) +
        npi.ljust(10) +
        tax.ljust(15) +
        status.ljust(1)
    )
    
    assert len(record) == 223, f"Provider record length is {len(record)}, expected 223"
    return record

# Write members file
with open('data/MEMBERS.dat', 'w') as f:
    for member in members:
        f.write(format_member(member) + '\n')

print(f"Created data/MEMBERS.dat with {len(members)} records (209 chars each)")

# Write providers file
with open('data/PROVIDERS.dat', 'w') as f:
    for provider in providers:
        f.write(format_provider(provider) + '\n')

print(f"Created data/PROVIDERS.dat with {len(providers)} records (223 chars each)")

# Verify
with open('data/MEMBERS.dat', 'r') as f:
    line = f.readline()
    print(f"Member record length: {len(line)-1} characters (excluding newline)")
    
with open('data/PROVIDERS.dat', 'r') as f:
    line = f.readline()
    print(f"Provider record length: {len(line)-1} characters (excluding newline)")

print("\nData files fixed successfully!")

# Made with Bob

#!/bin/bash
# check_files.sh - checks output files in a folder and prints PASS/FAIL
# Usage: ./check_files.sh my_folder

folder=${1:-.}              # folder to check (default: current folder)
report="report.txt"         # report file we save
pass=0
fail=0

printf "%-30s %-6s %s\n" "FILE" "RESULT" "REASON" | tee "$report"
echo "------------------------------------------------------" | tee -a "$report"

for file in "$folder"/*; do
    [ -f "$file" ] || continue          # skip anything that is not a file
    name=$(basename "$file")
    [ "$name" = "$report" ] && continue # skip our own report
    reason=""

    # Check 1: file must not be empty
    if [ ! -s "$file" ]; then
        reason="empty file"

    # Check 2: no failure words (whole words only)
    elif grep -qiwE "error|failed|nan" "$file"; then
        reason="found error/failed/NaN"

    else
        # Check 3: success marker depends on file type
        case "$name" in
            *.out)    grep -q "Total DFT energy" "$file" || reason="no 'Total DFT energy'" ;;
            *.log)    grep -q "affinity" "$file"         || reason="no docking affinity" ;;
            *.pdbqt)  grep -q "ATOM" "$file"             || reason="no ATOM lines" ;;
            *.csv)    [ "$(wc -l < "$file")" -ge 2 ]     || reason="CSV has no data rows" ;;
        esac
    fi

    # Print result
    if [ -z "$reason" ]; then
        printf "%-30s %-6s\n" "$name" "PASS" | tee -a "$report"
        pass=$((pass + 1))
    else
        printf "%-30s %-6s %s\n" "$name" "FAIL" "$reason" | tee -a "$report"
        fail=$((fail + 1))
    fi
done

echo "------------------------------------------------------" | tee -a "$report"
echo "Passed: $pass   Failed: $fail" | tee -a "$report"

# Exit code: 0 = all good, 1 = something failed
[ "$fail" -eq 0 ]
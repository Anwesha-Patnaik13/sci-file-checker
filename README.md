# Scientific File Checker

A simple Linux shell script that checks computational chemistry output files and prints a PASS/FAIL table.

## What it checks
- Empty or missing files
- Failure words: error, failed, NaN
- Success markers:
  - NWChem `.out` -> "Total DFT energy"
  - Docking `.log` -> "affinity"
  - Docking `.pdbqt` -> "ATOM"
  - Descriptor `.csv` -> header + at least 1 data row

## How to run
```
chmod +x check_files.sh
./check_files.sh test_data
```

## Output
- A PASS/FAIL table on screen
- A saved `report.txt`
- Exit code 0 if all pass, 1 if any fail

## Skills shown
Bash loops, conditions, grep, case, exit codes, Git/GitHub.
## Tested on
My own NWChem project (`nwchem-qa/runs`): 13 output files.

```
Passed: 12   Failed: 1
```

The one FAIL was `bad_water.out`, a deliberately broken calculation. The checker caught it correctly.
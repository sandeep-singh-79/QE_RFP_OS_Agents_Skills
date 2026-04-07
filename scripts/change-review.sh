#!/usr/bin/env bash
# change-review.sh — Automated checks for the System Change Review Checklist
# Covers Pass 1 checks (1.1–1.12) and automatable Pass 2 checks (2.4a, 2.8, 2.9,
# 2.10, 2.11, 2.13, 2.14) against diff-scoped files.
# Remaining Pass 2 checks require cross-file reasoning and stay manual.
#
# Usage:
#   ./scripts/change-review.sh              # diff against main
#   ./scripts/change-review.sh <base-ref>   # diff against custom base

set -euo pipefail

BASE_REF="${1:-main}"
REPO_ROOT="$(git rev-parse --show-toplevel)"

# Step 0 — Diff Scoping: get list of changed files in scope
CHANGED_FILES=$(git diff "$BASE_REF" --name-only -- .claude/ claude-memory/improvements.md claude-memory/insights.md 2>/dev/null || true)

if [[ -z "$CHANGED_FILES" ]]; then
  echo "✅ No in-scope files changed relative to $BASE_REF. Nothing to check."
  exit 0
fi

echo "=== System Change Review — Automated Pass 1 ==="
echo "Base ref: $BASE_REF"
echo "Files in scope:"
echo "$CHANGED_FILES" | sed 's/^/  /'
echo ""

FAILURES=0
WARNINGS=0

# ---------------------------------------------------------------------------
# Check 1.1 — Bare Memory File References [Blocks commit]
# ---------------------------------------------------------------------------
echo "--- Check 1.1: Bare Memory File References ---"
CHECK_1_1_FAIL=0

MEMORY_FILES="memory\.md|notes\.md|artifacts\.md|insights\.md|decisions\.md|improvements\.md"

while IFS= read -r file; do
  filepath="$REPO_ROOT/$file"
  [[ -f "$filepath" ]] || continue

  # Search for bare references: word boundary + filename, NOT preceded by claude-memory/ or .claude/
  # Exclude: code blocks, section headings, file template table rows, checklist documentation,
  #          historical footnotes, and explanatory prose describing the file itself
  matches=$(grep -nP "(?<!claude-memory/)(?<!\.claude/)(?<!/)\b($MEMORY_FILES)" "$filepath" \
    | grep -vP '^\d+:\s*```' \
    | grep -vP '^\d+:#+\s' \
    | grep -vP '^\d+:.*plan\.md' \
    | grep -vP '\[\^[0-9]+\]' \
    | grep -vP '\*\*Check [0-9]' \
    | grep -vP 'Historical Examples' \
    | grep -vP '^\d+:\|\s*`(memory|notes|artifacts|insights|decisions|improvements)\.md`' \
    | grep -vP '^\d+:\*\*\w+\.md\s+(header|initial|template)' \
    | grep -vP '^\d+:(memory|notes|artifacts|insights|decisions|improvements)\.md' \
    | grep -vP '\*\*Pass condition:\*\*' \
    | grep -vP '\*\*Scope\b' \
    | grep -vP '\*\*Exceptions\b' \
    | grep -vP '\(e\.g\.,.*\.md' \
    | grep -vP '\((notes|improvements)\.md\s+(initial|schema)' \
    | grep -vP '^[0-9]+:-\s*`(improvements|insights|memory|notes|artifacts|decisions)\.md`\s+\*\*' \
    || true)

  if [[ -n "$matches" ]]; then
    echo "  ⚠ FAIL in $file:"
    echo "$matches" | sed 's/^/    /'
    CHECK_1_1_FAIL=1
  fi
done <<< "$CHANGED_FILES"

if [[ $CHECK_1_1_FAIL -eq 0 ]]; then
  echo "  ✅ Pass"
else
  FAILURES=$((FAILURES + 1))
fi
echo ""

# ---------------------------------------------------------------------------
# Check 1.2 — Stage Name Accuracy [Blocks commit]
# ---------------------------------------------------------------------------
echo "--- Check 1.2: Stage Name Accuracy ---"
CHECK_1_2_FAIL=0

# Canonical stage names — labels that must follow "Stage N — "
declare -A CANONICAL_STAGES=(
  ["0"]="Artifact Discovery"
  ["1"]="Evidence Extraction"
  ["2"]="Memory Initialization"
  ["3"]="Gap Coverage Enforcement"
  ["3.5"]="Capability Coverage Check"
  ["4"]="Solution Design"
  ["5"]="Architecture Validation"
  ["6"]="Delivery Validation"
  ["7"]="Client Perspective Review"
  ["8"]="Governance Validation"
  ["9"]="Output Generation"
  ["10"]="System Learning"
)

while IFS= read -r file; do
  filepath="$REPO_ROOT/$file"
  [[ -f "$filepath" ]] || continue

  # Find all "Stage N — Name" patterns in section headings and table/label contexts
  # Only match lines that look like stage labels: headings (###), table rows (|), or
  # standalone label lines — not inline prose mentions
  stage_refs=$(grep -nP '(?:^#{1,6}\s+|^\|\s*).*Stage\s+([\d.]+)\s+—\s+\S' "$filepath" || true)

  if [[ -n "$stage_refs" ]]; then
    while IFS= read -r match; do
      line_num=$(echo "$match" | cut -d: -f1)
      line_text=$(echo "$match" | cut -d: -f2-)

      # Extract all Stage N — Name patterns from the line
      while read -r stage_num stage_name; do
        [[ -z "$stage_num" ]] && continue

        if [[ -n "${CANONICAL_STAGES[$stage_num]+x}" ]]; then
          canonical="${CANONICAL_STAGES[$stage_num]}"
          if [[ "$stage_name" != "$canonical" ]]; then
            # Skip conductor.md operational headings
            case "$file" in
              .claude/agents/conductor.md) continue ;;
            esac
            echo "  ⚠ FAIL in $file:$line_num: Stage $stage_num — '$stage_name' (expected '$canonical')"
            CHECK_1_2_FAIL=1
          fi
        fi
      done < <(echo "$line_text" | grep -oP 'Stage\s+\K[\d.]+(?=\s+—)' | while read -r snum; do
        # Extract the name after "Stage N — " up to end of line, next |, or (
        sname=$(echo "$line_text" | grep -oP "Stage\s+${snum}\s+—\s+\K[^|(]+" | head -1 | sed 's/\s*$//')
        echo "$snum $sname"
      done)
    done <<< "$stage_refs"
  fi
done <<< "$CHANGED_FILES"

if [[ $CHECK_1_2_FAIL -eq 0 ]]; then
  echo "  ✅ Pass"
else
  FAILURES=$((FAILURES + 1))
fi
echo ""

# ---------------------------------------------------------------------------
# Check 1.3 — Duplicate Content [Flag for review]
# ---------------------------------------------------------------------------
echo "--- Check 1.3: Duplicate Content ---"
CHECK_1_3_FAIL=0

while IFS= read -r file; do
  filepath="$REPO_ROOT/$file"
  [[ -f "$filepath" ]] || continue

  # Check for consecutive --- dividers (with optional blank lines between)
  if grep -Pzo '\n---\s*\n\s*\n?---\s*\n' "$filepath" > /dev/null 2>&1; then
    echo "  ⚠ FLAG in $file: consecutive --- dividers found"
    CHECK_1_3_FAIL=1
  fi

  # Check for duplicate section headings at same level
  headings=$(grep -nP '^#{1,6}\s+' "$filepath" || true)
  if [[ -n "$headings" ]]; then
    dupes=$(echo "$headings" | sed 's/^[0-9]*://' | sort | uniq -d || true)
    if [[ -n "$dupes" ]]; then
      echo "  ⚠ FLAG in $file: duplicate headings:"
      echo "$dupes" | sed 's/^/    /'
      CHECK_1_3_FAIL=1
    fi
  fi
done <<< "$CHANGED_FILES"

if [[ $CHECK_1_3_FAIL -eq 0 ]]; then
  echo "  ✅ Pass"
else
  WARNINGS=$((WARNINGS + 1))
fi
echo ""

# ---------------------------------------------------------------------------
# Check 1.4 — Malformed File Paths [Blocks commit]
# ---------------------------------------------------------------------------
echo "--- Check 1.4: Malformed File Paths ---"
CHECK_1_4_FAIL=0

while IFS= read -r file; do
  filepath="$REPO_ROOT/$file"
  [[ -f "$filepath" ]] || continue

  # Double-prefix detection (exclude inline code examples and Pattern description lines)
  double_prefix=$(grep -nP 'claude-memory/claude-memory/|\.claude/\.claude/' "$filepath" \
    | grep -vP '`claude-memory/claude-memory/' \
    | grep -vP '\*\*Pattern:\*\*' \
    | grep -vP '\*\*How to check:\*\*' \
    | grep -vP '^\d+:\s*-.*double.prefix' \
    || true)

  if [[ -n "$double_prefix" ]]; then
    echo "  ⚠ FAIL in $file (double-prefix):"
    echo "$double_prefix" | sed 's/^/    /'
    CHECK_1_4_FAIL=1
  fi

  # Backslash separator detection in path strings (exclude Windows absolute paths in comments)
  backslash=$(grep -nP '(claude-memory|\.claude)\\' "$filepath" || true)
  if [[ -n "$backslash" ]]; then
    echo "  ⚠ FAIL in $file (backslash separator):"
    echo "$backslash" | sed 's/^/    /'
    CHECK_1_4_FAIL=1
  fi
done <<< "$CHANGED_FILES"

if [[ $CHECK_1_4_FAIL -eq 0 ]]; then
  echo "  ✅ Pass"
else
  FAILURES=$((FAILURES + 1))
fi
echo ""

# ---------------------------------------------------------------------------
# Check 1.5 — Frontmatter Integrity [Blocks commit]
# ---------------------------------------------------------------------------
echo "--- Check 1.5: Frontmatter Integrity ---"
CHECK_1_5_FAIL=0

while IFS= read -r file; do
  filepath="$REPO_ROOT/$file"
  [[ -f "$filepath" ]] || continue

  # Only applies to agent and skill files
  case "$file" in
    .claude/agents/*.md|.claude/skills/*/SKILL.md) ;;
    *) continue ;;
  esac

  # Check frontmatter block exists (starts with ---)
  first_line=$(head -1 "$filepath")
  if [[ "$first_line" != "---" ]]; then
    echo "  ⚠ FAIL in $file: no YAML frontmatter block (file does not start with ---)"
    CHECK_1_5_FAIL=1
    continue
  fi

  # Check closing --- exists
  closing=$(tail -n +2 "$filepath" | grep -n '^---$' | head -1 || true)
  if [[ -z "$closing" ]]; then
    echo "  ⚠ FAIL in $file: frontmatter block not closed (no second ---)"
    CHECK_1_5_FAIL=1
    continue
  fi

  closing_line=$(echo "$closing" | cut -d: -f1)
  frontmatter=$(head -$((closing_line + 1)) "$filepath")

  # Check name: field exists
  if ! echo "$frontmatter" | grep -qP '^name:\s+'; then
    echo "  ⚠ FAIL in $file: frontmatter missing 'name:' field"
    CHECK_1_5_FAIL=1
  fi

  # Check description: field exists
  if ! echo "$frontmatter" | grep -qP '^description:\s+'; then
    echo "  ⚠ FAIL in $file: frontmatter missing 'description:' field"
    CHECK_1_5_FAIL=1
  fi

  # Check description: for bare memory refs
  desc_line=$(echo "$frontmatter" | grep -P '^description:\s+' || true)
  if [[ -n "$desc_line" ]]; then
    bare_in_desc=$(echo "$desc_line" | grep -oP "(?<!claude-memory/)(?<!\.claude/)(?<!/)\b($MEMORY_FILES)" || true)
    if [[ -n "$bare_in_desc" ]]; then
      echo "  ⚠ FAIL in $file: frontmatter description: contains bare memory ref: $bare_in_desc"
      CHECK_1_5_FAIL=1
    fi
  fi
done <<< "$CHANGED_FILES"

if [[ $CHECK_1_5_FAIL -eq 0 ]]; then
  echo "  ✅ Pass"
else
  FAILURES=$((FAILURES + 1))
fi
echo ""

# ---------------------------------------------------------------------------
# Check 1.6 — Client-Specific Leakage [Blocks commit]
# ---------------------------------------------------------------------------
echo "--- Check 1.6: Client-Specific Leakage ---"
CHECK_1_6_FAIL=0

# Known client names to check (case-insensitive).
# Add engagement-specific names here as needed.
CLIENT_NAMES="Manulife|Sun Life|Great-West"

while IFS= read -r file; do
  filepath="$REPO_ROOT/$file"
  [[ -f "$filepath" ]] || continue

  # Only check .claude/ files and cross-engagement memory files
  case "$file" in
    .claude/*|claude-memory/improvements.md|claude-memory/insights.md) ;;
    *) continue ;;
  esac

  # For improvements.md: only check Suggested Change text (Observation, Root Cause, Status, Derived from are exempt)
  # For insights.md: check insight body text (section headings and Derived from are exempt)
  # For .claude/ files: check everything except historical footnotes
  if [[ "$file" == "claude-memory/improvements.md" ]]; then
    matches=$(grep -niP "($CLIENT_NAMES)" "$filepath" \
      | grep -viP '\*\*Derived from:\*\*' \
      | grep -viP '\*\*Observation:\*\*' \
      | grep -viP '\*\*Root Cause:\*\*' \
      | grep -viP '\*\*Status:\*\*' \
      | grep -viP '^\d+:Derived from:' \
      | grep -viP '^\d+:-\s*\*\*Observation' \
      | grep -viP '^\d+:-\s*\*\*Root Cause' \
      || true)
  elif [[ "$file" == "claude-memory/insights.md" ]]; then
    matches=$(grep -niP "($CLIENT_NAMES)" "$filepath" \
      | grep -viP '\*\*Derived from:\*\*' \
      | grep -viP '^\d+:Derived from:' \
      | grep -viP '^\d+:##\s' \
      || true)
  else
    matches=$(grep -niP "($CLIENT_NAMES)" "$filepath" \
      | grep -viP '\*\*Derived from:\*\*' \
      | grep -viP '\[\^[0-9]+\]:' \
      | grep -viP 'Historical Examples' \
      || true)
  fi

  if [[ -n "$matches" ]]; then
    echo "  ⚠ FAIL in $file:"
    echo "$matches" | sed 's/^/    /'
    CHECK_1_6_FAIL=1
  fi
done <<< "$CHANGED_FILES"

if [[ $CHECK_1_6_FAIL -eq 0 ]]; then
  echo "  ✅ Pass"
else
  FAILURES=$((FAILURES + 1))
fi
echo ""

# ---------------------------------------------------------------------------
# Check 1.7 — Behavior Leakage in Agent Files [Flag for review]
# ---------------------------------------------------------------------------
echo "--- Check 1.7: Behavior Leakage in Agent Files ---"
CHECK_1_7_FAIL=0

REASONING_VERBS="(?<!\*\*)\b(identify|assess|evaluate|determine|analyze|detect|calculate)\b"

while IFS= read -r file; do
  filepath="$REPO_ROOT/$file"
  [[ -f "$filepath" ]] || continue

  # Only agent files
  case "$file" in
    .claude/agents/*.md) ;;
    *) continue ;;
  esac

  # Find reasoning verbs in instruction lines (lines starting with - or numbered items, FLAG lines)
  matches=$(grep -nP "$REASONING_VERBS" "$filepath" \
    | grep -vP '^\d+:\s*#' \
    | grep -vP '^\d+:---' \
    | grep -vP '^\d+:>\s' \
    | grep -vP '^\d+:name:|^\d+:description:' \
    | grep -vP 'do not.*\b(identify|assess|evaluate|determine|analyze|detect|calculate)\b' \
    | grep -vP 'not.*\b(identify|assess|evaluate|determine|analyze|detect|calculate)\b.*but' \
    | grep -vP 'evaluator' \
    | grep -vP 'Evaluation Dimensions' \
    | grep -vP 'Check whether:' \
    | grep -vP '§[0-9]' \
    || true)

  if [[ -n "$matches" ]]; then
    echo "  ⚠ FLAG in $file:"
    echo "$matches" | sed 's/^/    /'
    CHECK_1_7_FAIL=1
  fi
done <<< "$CHANGED_FILES"

if [[ $CHECK_1_7_FAIL -eq 0 ]]; then
  echo "  ✅ Pass"
else
  WARNINGS=$((WARNINGS + 1))
fi
echo ""

# ---------------------------------------------------------------------------
# Check 1.8 — Responsibility Leakage in Skill Files [Flag for review]
# ---------------------------------------------------------------------------
echo "--- Check 1.8: Responsibility Leakage in Skill Files ---"
CHECK_1_8_FAIL=0

STAGE_CONTROL="blocks?\s+Stage|clears?\s+Stage|cannot proceed|blocked until|must not pass control"
AUTHORITY_CLAIM="decision authority|accountable for"

while IFS= read -r file; do
  filepath="$REPO_ROOT/$file"
  [[ -f "$filepath" ]] || continue

  # Only skill files
  case "$file" in
    .claude/skills/*/SKILL.md) ;;
    *) continue ;;
  esac

  # Stage-control language
  stage_matches=$(grep -niP "$STAGE_CONTROL" "$filepath" \
    | grep -vP '^\d+:\s*#' \
    | grep -vP '^\d+:name:|^\d+:description:' \
    | grep -vP 'HALT|STOP' \
    || true)

  if [[ -n "$stage_matches" ]]; then
    echo "  ⚠ FLAG in $file (stage-control language):"
    echo "$stage_matches" | sed 's/^/    /'
    CHECK_1_8_FAIL=1
  fi

  # Authority claims (skill claiming ownership rather than assessing)
  auth_matches=$(grep -niP "$AUTHORITY_CLAIM" "$filepath" \
    | grep -vP '^\d+:\s*#' \
    | grep -vP 'calling agent|conductor' \
    || true)

  if [[ -n "$auth_matches" ]]; then
    echo "  ⚠ FLAG in $file (authority claim):"
    echo "$auth_matches" | sed 's/^/    /'
    CHECK_1_8_FAIL=1
  fi
done <<< "$CHANGED_FILES"

if [[ $CHECK_1_8_FAIL -eq 0 ]]; then
  echo "  ✅ Pass"
else
  WARNINGS=$((WARNINGS + 1))
fi
echo ""

# ---------------------------------------------------------------------------
# Check 1.9 — Decision Presence / Failure Path (LINT-A03) [Flag for review]
# ---------------------------------------------------------------------------
echo "--- Check 1.9: Decision Presence / Failure Path (LINT-A03) ---"
CHECK_1_9_FAIL=0

while IFS= read -r file; do
  filepath="$REPO_ROOT/$file"
  [[ -f "$filepath" ]] || continue

  case "$file" in
    .claude/agents/*.md) ;;
    *) continue ;;
  esac

  # Find "Confirm that:" blocks and check if next 5 lines contain a failure action
  confirm_lines=$(grep -nP 'Confirm that:' "$filepath" || true)
  if [[ -n "$confirm_lines" ]]; then
    while IFS= read -r cline; do
      lnum=$(echo "$cline" | cut -d: -f1)
      # Check next 10 lines for a failure action verb
      after=$(sed -n "$((lnum+1)),$((lnum+10))p" "$filepath")
      if ! echo "$after" | grep -qiP '(flag|escalate|reject|block|halt|raise|do not proceed|stop)'; then
        echo "  ⚠ FLAG in $file:$lnum: 'Confirm that:' block with no visible failure-path action in next 10 lines"
        CHECK_1_9_FAIL=1
      fi
    done <<< "$confirm_lines"
  fi

  # Find standalone "Ensure X" lines in instruction blocks (not in Operating Stance)
  ensure_lines=$(grep -nP '^\s*-?\s*\*?\*?Ensure\b' "$filepath" \
    | grep -vP 'Operating Stance|Guiding Principles|Core Principles' \
    || true)
  # Note: standalone Ensure lines are flagged for manual review only — not all are violations
done <<< "$CHANGED_FILES"

if [[ $CHECK_1_9_FAIL -eq 0 ]]; then
  echo "  ✅ Pass"
else
  WARNINGS=$((WARNINGS + 1))
fi
echo ""

# ---------------------------------------------------------------------------
# Check 1.10 — Skill Invocation Traceability (LINT-A04) [Flag for review]
# ---------------------------------------------------------------------------
echo "--- Check 1.10: Skill Invocation Traceability (LINT-A04) ---"
CHECK_1_10_FAIL=0

while IFS= read -r file; do
  filepath="$REPO_ROOT/$file"
  [[ -f "$filepath" ]] || continue

  case "$file" in
    .claude/agents/*.md) ;;
    *) continue ;;
  esac

  # Skip conductor — coordinates structurally via stage procedures
  case "$file" in
    .claude/agents/conductor.md) continue ;;
  esac

  # Find Approve/Authorize lines without skill references nearby
  approve_lines=$(grep -nP '^\s*-\s+\*?\*?(Approve|Authorize)\b' "$filepath" || true)
  if [[ -n "$approve_lines" ]]; then
    while IFS= read -r aline; do
      lnum=$(echo "$aline" | cut -d: -f1)
      # Check the line itself and surrounding 3 lines for a skill name reference
      context=$(sed -n "$((lnum > 3 ? lnum-3 : 1)),$((lnum+3))p" "$filepath")
      if ! echo "$context" | grep -qiP '(Thinking|skill|SKILL|evidence.extraction|evidence.reconciliation|review.*challenge|structuring|estimation|kpi.baseline|pert|capability.coverage|domain.context)'; then
        echo "  ⚠ FLAG in $file:$lnum: Approve/Authorize without skill reference in context"
        CHECK_1_10_FAIL=1
      fi
    done <<< "$approve_lines"
  fi
done <<< "$CHANGED_FILES"

if [[ $CHECK_1_10_FAIL -eq 0 ]]; then
  echo "  ✅ Pass"
else
  WARNINGS=$((WARNINGS + 1))
fi
echo ""

# ---------------------------------------------------------------------------
# Check 1.11 — No Silent Authority in Escalations (LINT-G02) [Flag for review]
# ---------------------------------------------------------------------------
echo "--- Check 1.11: No Silent Authority in Escalations (LINT-G02) ---"
CHECK_1_11_FAIL=0

while IFS= read -r file; do
  filepath="$REPO_ROOT/$file"
  [[ -f "$filepath" ]] || continue

  case "$file" in
    .claude/agents/*.md) ;;
    *) continue ;;
  esac

  # Find Escalate/Reject lines that are very short (lack condition specificity)
  esc_lines=$(grep -nP '^\s*-\s+\*?\*?(Escalate|Reject)\b' "$filepath" || true)
  if [[ -n "$esc_lines" ]]; then
    while IFS= read -r eline; do
      lnum=$(echo "$eline" | cut -d: -f1)
      text=$(echo "$eline" | cut -d: -f2-)
      # Check if the line has a condition (where/when/if/that/because/due to, or is sufficiently long)
      word_count=$(echo "$text" | wc -w)
      if ! echo "$text" | grep -qiP '(where|when|if|that|because|due to|before|after|exceeds|gaps?|risk|concern)' && [[ $word_count -lt 10 ]]; then
        echo "  ⚠ FLAG in $file:$lnum: Escalate/Reject without condition: $(echo "$text" | sed 's/^\s*//')"
        CHECK_1_11_FAIL=1
      fi
    done <<< "$esc_lines"
  fi
done <<< "$CHANGED_FILES"

if [[ $CHECK_1_11_FAIL -eq 0 ]]; then
  echo "  ✅ Pass"
else
  WARNINGS=$((WARNINGS + 1))
fi
echo ""

# ---------------------------------------------------------------------------
# Check 1.12 — Decision Outcome Completeness (LINT-A05) [Flag for review]
# ---------------------------------------------------------------------------
echo "--- Check 1.12: Decision Outcome Completeness (LINT-A05) ---"
CHECK_1_12_FAIL=0

# Only applies to decision-contracts.md
CONTRACTS_FILE="$REPO_ROOT/.claude/references/decision-contracts.md"

if echo "$CHANGED_FILES" | grep -q 'decision-contracts.md' && [[ -f "$CONTRACTS_FILE" ]]; then
  # Find all contract blocks: extract Contract ID lines and check if Allowed Outcomes follows before next ```
  # Use awk for robust multi-line parsing
  missing=$(awk '
    /^```$/ { in_block = !in_block; if (!in_block && contract_id != "" && !has_outcomes) print contract_id " (line " block_start ")"; contract_id=""; has_outcomes=0; if (in_block) block_start=NR; next }
    in_block && /^Contract ID:/ { contract_id = $0; sub(/^Contract ID:\s+/, "", contract_id) }
    in_block && /^Allowed Outcomes:/ { has_outcomes = 1 }
  ' "$CONTRACTS_FILE")

  if [[ -n "$missing" ]]; then
    while IFS= read -r m; do
      echo "  ⚠ FLAG: Contract $m missing 'Allowed Outcomes:' field"
      CHECK_1_12_FAIL=1
    done <<< "$missing"
  fi
fi

if [[ $CHECK_1_12_FAIL -eq 0 ]]; then
  echo "  ✅ Pass"
else
  WARNINGS=$((WARNINGS + 1))
fi
echo ""

echo ""
echo "=== Pass 2 — Automatable Structural Checks ==="
echo ""

# ---------------------------------------------------------------------------
# Check 2.4a — Runtime-Fill Columns Blank [Flag for review]
# ---------------------------------------------------------------------------
echo "--- Check 2.4a: Runtime-Fill Columns Blank ---"
CHECK_2_4A_FAIL=0

# Check SETUP.md plan.md template — State Register data rows should have blank runtime columns
SETUP_FILE="$REPO_ROOT/.claude/SETUP.md"
if echo "$CHANGED_FILES" | grep -q 'SETUP.md' && [[ -f "$SETUP_FILE" ]]; then
  # Find State Register data rows (lines with contract IDs like TA-01, QM-01, etc.)
  register_rows=$(grep -nP '^\|\s*(TA|QM|CE|PM|TR)-\d+\s*\|' "$SETUP_FILE" || true)
  if [[ -n "$register_rows" ]]; then
    while IFS= read -r row; do
      lnum=$(echo "$row" | cut -d: -f1)
      text=$(echo "$row" | cut -d: -f2-)
      # Count non-empty cells after the State column (columns 4-7: Version, Last Updated, Updated By, Notes)
      # Split by | and check if runtime columns (4th onward) have content
      # Template rows should have: | ID | Decision | Created | | | | |
      runtime_content=$(echo "$text" | awk -F'|' '{for(i=5;i<=NF-1;i++) if($i !~ /^\s*$/) print NR": col "i" has content: "$i}')
      if [[ -n "$runtime_content" ]]; then
        echo "  ⚠ FLAG in SETUP.md:$lnum: runtime-fill column has pre-filled content"
        CHECK_2_4A_FAIL=1
      fi
    done <<< "$register_rows"
  fi
fi

if [[ $CHECK_2_4A_FAIL -eq 0 ]]; then
  echo "  ✅ Pass"
else
  WARNINGS=$((WARNINGS + 1))
fi
echo ""

# ---------------------------------------------------------------------------
# Check 2.8 — Register/Table Schema Field Count [Blocks commit]
# ---------------------------------------------------------------------------
echo "--- Check 2.8: Register/Table Schema Field Count ---"
CHECK_2_8_FAIL=0

if echo "$CHANGED_FILES" | grep -q 'SETUP.md' && [[ -f "$SETUP_FILE" ]]; then
  # Decision State Register header should have 7 columns
  register_header=$(grep -nP '^\|\s*Contract ID\s*\|\s*Decision\s*\|\s*State\s*\|' "$SETUP_FILE" || true)
  if [[ -n "$register_header" ]]; then
    col_count=$(echo "$register_header" | head -1 | cut -d: -f2- | awk -F'|' '{print NF-2}')
    if [[ "$col_count" -ne 7 ]]; then
      echo "  ⚠ FAIL in SETUP.md: Decision State Register header has $col_count columns (expected 7)"
      CHECK_2_8_FAIL=1
    fi
  fi

  # Decision Log header should have 7 columns
  log_header=$(grep -nP '^\|\s*Timestamp\s*\|\s*Contract ID\s*\|\s*From State\s*\|' "$SETUP_FILE" || true)
  if [[ -n "$log_header" ]]; then
    col_count=$(echo "$log_header" | head -1 | cut -d: -f2- | awk -F'|' '{print NF-2}')
    if [[ "$col_count" -ne 7 ]]; then
      echo "  ⚠ FAIL in SETUP.md: Decision Log header has $col_count columns (expected 7)"
      CHECK_2_8_FAIL=1
    fi
  fi

  # Verify data rows match header field count (State Register)
  register_rows=$(grep -nP '^\|\s*(TA|QM|CE|PM|TR)-\d+\s*\|' "$SETUP_FILE" || true)
  if [[ -n "$register_rows" ]]; then
    while IFS= read -r row; do
      lnum=$(echo "$row" | cut -d: -f1)
      text=$(echo "$row" | cut -d: -f2-)
      col_count=$(echo "$text" | awk -F'|' '{print NF-2}')
      if [[ "$col_count" -ne 7 ]]; then
        echo "  ⚠ FAIL in SETUP.md:$lnum: State Register data row has $col_count columns (expected 7)"
        CHECK_2_8_FAIL=1
      fi
    done <<< "$register_rows"
  fi

  # Sign-off table should have 4 columns per row
  signoff_rows=$(grep -nP '^\|\s*[12]\.\d+[a-z]?\s*\|' "$SETUP_FILE" || true)
  if [[ -n "$signoff_rows" ]]; then
    while IFS= read -r row; do
      lnum=$(echo "$row" | cut -d: -f1)
      text=$(echo "$row" | cut -d: -f2-)
      col_count=$(echo "$text" | awk -F'|' '{print NF-2}')
      if [[ "$col_count" -ne 4 ]]; then
        echo "  ⚠ FAIL in SETUP.md:$lnum: sign-off row has $col_count columns (expected 4)"
        CHECK_2_8_FAIL=1
      fi
    done <<< "$signoff_rows"
  fi
fi

if [[ $CHECK_2_8_FAIL -eq 0 ]]; then
  echo "  ✅ Pass"
else
  FAILURES=$((FAILURES + 1))
fi
echo ""

# ---------------------------------------------------------------------------
# Check 2.9 — Agent Responsibility Count (LINT-G03) [Flag for review]
# ---------------------------------------------------------------------------
echo "--- Check 2.9: Agent Responsibility Count (LINT-G03) ---"
CHECK_2_9_FAIL=0

while IFS= read -r file; do
  filepath="$REPO_ROOT/$file"
  [[ -f "$filepath" ]] || continue

  case "$file" in
    .claude/agents/*.md) ;;
    *) continue ;;
  esac

  # Skip client-rfp-evaluator Evaluation Dimensions
  agent_name=$(basename "$file" .md)

  # Count accountability lines in Decision Authority section
  in_da=0
  da_count=0
  while IFS= read -r line; do
    if echo "$line" | grep -qP '^## Decision Authority'; then
      in_da=1
      continue
    fi
    if [[ $in_da -eq 1 ]] && echo "$line" | grep -qP '^## '; then
      break
    fi
    if [[ $in_da -eq 1 ]]; then
      if echo "$line" | grep -qP '^\s*-\s+(Approve|Reject|Escalate|Authorize|Flag|Surface|Recommend|Decline)\b'; then
        # Skip Evaluation Dimensions for client-rfp-evaluator
        if [[ "$agent_name" == "client-rfp-evaluator" ]]; then
          continue
        fi
        da_count=$((da_count + 1))
      fi
    fi
  done < "$filepath"

  if [[ $da_count -gt 7 ]]; then
    echo "  ⚠ FLAG in $file: Decision Authority has $da_count accountability lines (limit: 7)"
    CHECK_2_9_FAIL=1
  fi
done <<< "$CHANGED_FILES"

if [[ $CHECK_2_9_FAIL -eq 0 ]]; then
  echo "  ✅ Pass"
else
  WARNINGS=$((WARNINGS + 1))
fi
echo ""

# ---------------------------------------------------------------------------
# Check 2.10 — Contract Dependency Integrity (LINT-A06) [Flag for review]
# ---------------------------------------------------------------------------
echo "--- Check 2.10: Contract Dependency Integrity (LINT-A06) ---"
CHECK_2_10_FAIL=0

if echo "$CHANGED_FILES" | grep -q 'decision-contracts.md' && [[ -f "$CONTRACTS_FILE" ]]; then
  # Use awk to parse contracts and validate dependencies in a single pass
  dep_issues=$(awk '
    /^```$/ { in_block = !in_block; if (!in_block) { contract_id = ""; } next }
    in_block && /^Contract ID:/ { contract_id = $0; sub(/^Contract ID:\s+/, "", contract_id); sub(/\s+$/, "", contract_id) }
    in_block && /^Allowed Outcomes:/ && contract_id != "" {
      outcomes = $0; sub(/^Allowed Outcomes:\s+/, "", outcomes)
      allowed[contract_id] = outcomes
    }
    in_block && /^Depends On:/ && contract_id != "" {
      dep = $0; sub(/^Depends On:\s+/, "", dep); sub(/\s+$/, "", dep)
      if (dep != "None") {
        depends[contract_id] = dep
      }
    }
    END {
      for (cid in depends) {
        dep = depends[cid]
        # Extract dependency contract ID
        match(dep, /^[A-Z]+-[0-9]+/)
        dep_id = substr(dep, RSTART, RLENGTH)
        # Extract required outcome
        req = ""
        if (match(dep, /\(([A-Za-z]+) outcome/, arr)) { req = arr[1] }
        else if (match(dep, /\(([A-Za-z]+) outcome/)) {
          tmp = dep; sub(/.*\(/, "", tmp); sub(/ outcome.*/, "", tmp); req = tmp
        }
        if (dep_id != "" && !(dep_id in allowed)) {
          print cid " depends on " dep_id " but " dep_id " not found"
        } else if (dep_id != "" && req != "" && allowed[dep_id] !~ req) {
          print cid " requires " req " from " dep_id " but Allowed Outcomes: " allowed[dep_id]
        }
      }
    }
  ' "$CONTRACTS_FILE")

  if [[ -n "$dep_issues" ]]; then
    while IFS= read -r issue; do
      echo "  ⚠ FLAG: $issue"
      CHECK_2_10_FAIL=1
    done <<< "$dep_issues"
  fi
fi

if [[ $CHECK_2_10_FAIL -eq 0 ]]; then
  echo "  ✅ Pass"
else
  WARNINGS=$((WARNINGS + 1))
fi
echo ""

# ---------------------------------------------------------------------------
# Check 2.11 — Dependency Cycle Prevention (LINT-D01) [Flag for review]
# ---------------------------------------------------------------------------
echo "--- Check 2.11: Dependency Cycle Prevention (LINT-D01) ---"
CHECK_2_11_FAIL=0

if echo "$CHANGED_FILES" | grep -q 'decision-contracts.md' && [[ -f "$CONTRACTS_FILE" ]]; then
  cycle_issues=$(awk '
    /^```$/ { in_block = !in_block; if (!in_block) { contract_id = ""; } next }
    in_block && /^Contract ID:/ { contract_id = $0; sub(/^Contract ID:\s+/, "", contract_id); sub(/\s+$/, "", contract_id) }
    in_block && /^Depends On:/ && contract_id != "" {
      dep = $0; sub(/^Depends On:\s+/, "", dep); sub(/\s+$/, "", dep)
      if (dep != "None") {
        match(dep, /^[A-Z]+-[0-9]+/)
        dep_id = substr(dep, RSTART, RLENGTH)
        if (dep_id != "") depends[contract_id] = dep_id
      }
    }
    END {
      for (start in depends) {
        path = start
        current = depends[start]
        depth = 0
        while (current != "" && depth < 10) {
          if (current == start) {
            print "Cycle: " path " -> " current
            break
          }
          path = path " -> " current
          current = depends[current]
          depth++
        }
      }
    }
  ' "$CONTRACTS_FILE")

  if [[ -n "$cycle_issues" ]]; then
    while IFS= read -r issue; do
      echo "  ⚠ FLAG: $issue"
      CHECK_2_11_FAIL=1
    done <<< "$cycle_issues"
  fi
fi

if [[ $CHECK_2_11_FAIL -eq 0 ]]; then
  echo "  ✅ Pass"
else
  WARNINGS=$((WARNINGS + 1))
fi
echo ""

# ---------------------------------------------------------------------------
# Check 2.13 — Dependency Depth Limit (LINT-D03) [Flag for review]
# ---------------------------------------------------------------------------
echo "--- Check 2.13: Dependency Depth Limit (LINT-D03) ---"
CHECK_2_13_FAIL=0

if echo "$CHANGED_FILES" | grep -q 'decision-contracts.md' && [[ -f "$CONTRACTS_FILE" ]]; then
  depth_issues=$(awk '
    /^```$/ { in_block = !in_block; if (!in_block) { contract_id = ""; } next }
    in_block && /^Contract ID:/ { contract_id = $0; sub(/^Contract ID:\s+/, "", contract_id); sub(/\s+$/, "", contract_id) }
    in_block && /^Depends On:/ && contract_id != "" {
      dep = $0; sub(/^Depends On:\s+/, "", dep); sub(/\s+$/, "", dep)
      if (dep != "None") {
        match(dep, /^[A-Z]+-[0-9]+/)
        dep_id = substr(dep, RSTART, RLENGTH)
        if (dep_id != "") depends[contract_id] = dep_id
      }
    }
    END {
      for (start in depends) {
        current = depends[start]
        depth = 1
        while (current != "" && current in depends) {
          current = depends[current]
          depth++
          if (depth > 3) {
            print start " chain exceeds depth 3 (depth: " depth ")"
            break
          }
        }
      }
    }
  ' "$CONTRACTS_FILE")

  if [[ -n "$depth_issues" ]]; then
    while IFS= read -r issue; do
      echo "  ⚠ FLAG: $issue"
      CHECK_2_13_FAIL=1
    done <<< "$depth_issues"
  fi
fi

if [[ $CHECK_2_13_FAIL -eq 0 ]]; then
  echo "  ✅ Pass"
else
  WARNINGS=$((WARNINGS + 1))
fi
echo ""

# ---------------------------------------------------------------------------
# Check 2.14 — Decision State Value Validation (LINT-L01) [Flag for review]
# Note: Only checks the SETUP.md template — runtime plan.md is not in .claude/
# ---------------------------------------------------------------------------
echo "--- Check 2.14: Decision State Value Validation (LINT-L01) ---"
CHECK_2_14_FAIL=0

VALID_STATES="Created|Escalated|Approved|Rejected|Executed|Invalidated|Closed"

if echo "$CHANGED_FILES" | grep -q 'SETUP.md' && [[ -f "$SETUP_FILE" ]]; then
  register_rows=$(grep -nP '^\|\s*(TA|QM|CE|PM|TR)-\d+\s*\|' "$SETUP_FILE" || true)
  if [[ -n "$register_rows" ]]; then
    while IFS= read -r row; do
      lnum=$(echo "$row" | cut -d: -f1)
      text=$(echo "$row" | cut -d: -f2-)
      # Extract State column (3rd pipe-delimited field)
      state=$(echo "$text" | awk -F'|' '{gsub(/^\s+|\s+$/,"",$4); print $4}')
      if [[ -n "$state" ]] && ! echo "$state" | grep -qP "^($VALID_STATES)$"; then
        echo "  ⚠ FLAG in SETUP.md:$lnum: State value '$state' is not canonical"
        CHECK_2_14_FAIL=1
      fi
    done <<< "$register_rows"
  fi
fi

if [[ $CHECK_2_14_FAIL -eq 0 ]]; then
  echo "  ✅ Pass"
else
  WARNINGS=$((WARNINGS + 1))
fi
echo ""

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
echo "=== Summary ==="
echo "Pass 1 + Pass 2 automated checks complete."
echo "Blocking failures: $FAILURES"
echo "Warnings (flag for review): $WARNINGS"
echo ""
echo "Manual Pass 2 checks still required: 2.1, 2.2, 2.3, 2.4, 2.5, 2.6, 2.7, 2.12, 2.15, 2.16, 2.17, 2.18, 2.19, 2.20"

if [[ $FAILURES -gt 0 ]]; then
  echo ""
  echo "❌ COMMIT BLOCKED — resolve all blocking failures before pushing."
  exit 1
fi

if [[ $WARNINGS -gt 0 ]]; then
  echo ""
  echo "⚠ Warnings present — document justification if proceeding."
  exit 0
fi

echo ""
echo "✅ All automated Pass 1 checks passed."
exit 0

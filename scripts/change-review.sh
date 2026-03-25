#!/usr/bin/env bash
# change-review.sh — Automated Pass 1 checks for the System Change Review Checklist
# Runs checks 1.1, 1.3, 1.4, and 1.6 against diff-scoped files.
# Pass 2 checks remain manual (they require cross-file reasoning).
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
# Summary
# ---------------------------------------------------------------------------
echo "=== Summary ==="
echo "Blocking failures: $FAILURES"
echo "Warnings (flag for review): $WARNINGS"

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

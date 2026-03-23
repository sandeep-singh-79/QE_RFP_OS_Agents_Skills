---
name: scope-completeness-validator
description: Validate that all expected scope categories are explicitly accounted for before estimation begins. Use as a pre-PERT gate to catch missing integration testing, RBAC, regression, NFR, external dependencies, data migration, and environment coverage before effort is sized. Invoked only by estimation-sizing-thinking — not loaded independently.
---

# Skill: Scope Completeness Validator

## Purpose

Provide a systematic, checklist-based scope gate that catches missing test coverage categories before `pert-estimation` begins sizing. This skill does not add scope — it surfaces gaps so they can be explicitly included or explicitly excluded before effort figures are produced.

Scope corrections applied after estimation begins compound errors across every subsequent multiplier. Catching them here is materially cheaper than correcting them downstream.

> Use this skill to answer: *"Have all expected test coverage areas been explicitly accounted for before we commit to an effort range?"*

---

## Activation Conditions

This skill activates when **all** of the following are true:

1. `estimation-sizing-thinking` has completed the Scope Establishment Pre-Phase (scenario count declared, or capacity envelope declared in Capacity-based mode)
2. PERT sizing has not yet begun
3. A scope description or scope list is available (from `claude-memory/memory.md`, `claude-memory/notes.md`, or `outputs/staged-proposal.md`)

> **Capacity-based mode note:** When no scenario count exists, the validator still runs on the scope context available at proposal time. Unknown categories default to **Missing** with the note: *"Scope to be confirmed at sprint planning — classify once backlog is established."*

> **HALT — no scope available:** If no scope description can be found, stop immediately and prompt:
> *"Scope Completeness Validator requires a scope description to check. Please provide the workstream list, module list, or RFP scope section before estimation begins."*

---

## Context Scope

This skill loads **only**:
- `claude-memory/memory.md` — for scope-relevant findings and technology/integration inventory
- `claude-memory/notes.md` — for scope decisions made during earlier workflow stages
- `outputs/staged-proposal.md` — if populated, for Stage 4 solution and scope framing

It must **not** load `claude-memory/insights.md`, `claude-memory/improvements.md`, or `claude-memory/decisions.md` unless a specific scope clarification task requires them.

---

## Scope Completeness Checklist

Check each category against the available scope description. Assign one of three statuses:

- **Present** — explicitly included in scope with sufficient detail to estimate
- **Explicitly Excluded** — declared out of scope with rationale provided
- **Missing** — not mentioned or addressed; requires review before estimation proceeds

| # | Category | What to Look For | Common Reason It's Missed |
|---|---|---|---|
| 1 | **Integration Testing** | Cross-system, API, and service integration validation; inter-module communication testing | Scoping focuses on UI flows; integration assumed implicit or "covered by functional" |
| 2 | **RBAC / Authorization Validation** | Role-based access control, permission matrix testing, user role boundary cases | Treated as part of functional testing; separate test design and coverage not planned |
| 3 | **Cross-System Regression** | Regression scope covering modules impacted by the change — not just the target module | Regression scoped only for the target workstream; impacted downstream systems ignored |
| 4 | **NFR Testing** | Performance, security, accessibility, reliability, scalability testing | Deferred or assumed out of scope without explicit declaration; often remembered post-award |
| 5 | **External Dependencies** | Third-party APIs, vendor integrations, data feeds, external authentication services | Scoped only when named explicitly in RFP; overlooked when referenced implicitly |
| 6 | **Data Migration / Validation** | Data integrity checks post-migration, transformation validation, seed data verification | Assumed covered by functional testing; separate scripting and execution effort required |
| 7 | **Environment / Deployment Validation** | Smoke tests and deployment verification across environments (dev, UAT, staging, prod) | Assumed zero-effort or manual-only; automation scripting and maintenance not planned |

---

## Status Rules

**Present:**
- The scope description explicitly names this category, OR
- Test cases or scenarios of this type appear in the scope list, OR
- The category is addressed in the RFP requirements or workstream definition

**Explicitly Excluded:**
- A clear out-of-scope declaration exists for this category, AND
- A rationale is provided (e.g., "NFR testing — client has separate performance testing team", "Data migration — handled by ETL team, QA not in scope")

**Missing:**
- The category is not mentioned in any available scope material, AND
- No exclusion rationale is present

> **Ambiguous case:** If a category is partially addressed (e.g., "some integration testing included but no cross-system regression"), classify as **Missing** and note what is unclear. Do not upgrade to Present when coverage is partial.

---

## Halting Condition

If **2 or more categories** are **Missing**, raise:

```
⚠ SCOPE COMPLETENESS — REVIEW REQUIRED
Missing categories: [list]
These categories have no explicit inclusion or exclusion in the current scope description.
Estimation may proceed, but these items must appear in the Assumptions Block marked
[UNVERIFIED — may require scope addition or explicit exclusion]. 
Confirm with client before committing to the estimate.
```

If **1 category** is Missing, raise a lower-severity note:

```
ℹ SCOPE NOTE: [category] not addressed in scope description.
Declare as in-scope (with effort impact) or explicitly excluded (with rationale) before finalising estimate.
```

If **0 categories** are Missing (all Present or Explicitly Excluded), proceed without flag.

---

## Output Format

Produce a **Scope Completeness Report** as part of the estimation output preamble (appears before the PERT tier table):

### Scope Completeness Report

| # | Category | Status | Note |
|---|---|---|---|
| 1 | Integration Testing | [Present / Explicitly Excluded / Missing] | [brief note if needed] |
| 2 | RBAC / Authorization Validation | [Present / Explicitly Excluded / Missing] | |
| 3 | Cross-System Regression | [Present / Explicitly Excluded / Missing] | |
| 4 | NFR Testing | [Present / Explicitly Excluded / Missing] | |
| 5 | External Dependencies | [Present / Explicitly Excluded / Missing] | |
| 6 | Data Migration / Validation | [Present / Explicitly Excluded / Missing] | |
| 7 | Environment / Deployment Validation | [Present / Explicitly Excluded / Missing] | |

**Overall status:** [Clean / 1 item for review / ⚠ SCOPE COMPLETENESS — REVIEW REQUIRED]

---

## Assumptions Block Contribution

For every category classified as **Missing**, the Assumptions Block of the estimate **must** contain an entry:

```
[UNVERIFIED — may require scope addition or explicit exclusion]:
[Category name] not addressed in scope description. If in scope: add [directional effort note].
If out of scope: declare exclusion with rationale.
Confirmation required before estimate is finalised.
```

These entries persist through to the Stage 9 output unless resolved.

---

## Explicit Exclusions

Do not:
- Add scope or scenarios to the estimate — this skill flags, it does not scope
- Estimate effort for missing categories — mark as `[UNVERIFIED]`; let `pert-estimation` handle sizing once scope is confirmed
- Override client or practitioner scope decisions — if a category is explicitly excluded, accept it
- Produce a risk analysis — scope gaps are surfaced, not risk-rated (risk rating belongs to `assumption-dependency-management` and `outcome-risk-framing`)

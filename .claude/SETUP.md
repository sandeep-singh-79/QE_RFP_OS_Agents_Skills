# SETUP.md — Workspace Initialization

**Load this file:** During workspace initialization only, before Stages 0–3 begin. Not required during agent execution (Stages 4+) unless file templates or initialization order need to be consulted.

Workspace initialization procedures for the QE RFP Operating System. Load this file when setting up a new engagement workspace or when file templates are needed for initialization.

---

## Workspace Initialization

If required workspace files or folders do not exist, the system may create them when first needed during workflow execution. Do not create files prematurely or speculatively.

### Initialization Order
1. Check if `claude-memory/` directory exists — create if absent
2. Check for required memory files — create with header template when first write is needed
3. `plan.md` at root — create if absent when task tracking begins
4. `outputs/` directory and `outputs/staged-proposal.md` — created on first write at Stage 4; do not pre-create
5. Never create agent or skill files during initialization — these are system-managed

### File Templates (for creation on first use)

**claude-memory/decisions.md** — Header: `# Decisions Log` + `> Tracks major decisions made during engagement analysis.`

**claude-memory/artifacts.md** — Header: `# Artifact Index` + `> Registers all knowledge source artifacts entering the system.` + table with columns: ID, Name, Type, Source, Date Received, Status

**claude-memory/improvements.md** — Header: `# QE OS Improvement Proposals` + `> Records proposed improvements to the QE RFP Operating System.` + `> Agents propose changes here. System updates require human approval.`

**claude-memory/notes.md** — Header: `# Working Notes` + `> Records in-progress observations, gap coverage, dependency register, and inter-stage handoff notes for the current engagement.`

Initial sections on first creation:
```md
## Missing Artifacts
[To be populated at Stage 0 — list any artifact categories not available]

## Dependency Register
| D-[n] | Stage Identified | Description | Owner (Client/Vendor/Joint) | Status (Open/Confirmed/Mitigated) |
|---|---|---|---|---|

## Insight Candidates
[Populated progressively during Stages 1–8. Format: `> INSIGHT CANDIDATE [Stage N]: [observation]. Carry-forward: [why this recurs / what to watch for]`. Reviewed and promoted (or discarded) at Stage 10.]
```

**outputs/staged-proposal.md** — Header: `# Staged Proposal Output` + `> Progressive output staging file. Written by Stages 4–7. Read by Stage 8 (evidence-reconciliation skill).`

Initial sections on first creation:
```md
## Stage 4 — Solution Design
[To be populated by Test Architect]

## Stage 5 — Architecture Validation
[To be populated by QA Manager]

## Stage 6 — Delivery Validation
[To be populated by Project Manager]

## Stage 7 — Client Perspective Review
[To be populated by Client/RFP Evaluator — after Conductor pre-processing]
```

**plan.md** (at workspace root) — Use the following structure:

```md
# Engagement Plan

| Field | Value |
|---|---|
| Client | [client name from artifacts] |
| RFP / Document | [document name or reference] |
| Engagement Started | [date] |
| Discovery Maturity | [Constrained / Moderate / Deep] |
| Engagement Type | [managed_service / transformation_partnership / retained_qe_delivery / standalone_project / qa_audit] |
| Application Count | [integer] |
| Engagement Signals | [none / comma-separated list: incumbent_vendor_present, distributed_delivery_consolidation, vendor_transition, greenfield_delivery] |
| Regulatory Context | [Explicit / Inferred ([framework], confidence [score]) / Unknown] |
| Current Stage | [Stage N — Name] |

## Stage Status

| Stage | Status | Notes |
|---|---|---|
| Stage 0 — Artifact Discovery | Not Started | |
| Stage 1 — Evidence Extraction | Not Started | |
| Stage 2 — Memory Initialization | Not Started | |
| Stage 3 — Gap Coverage | Not Started | |
| Stage 3.5 — Capability Coverage | Not Started | |
| Stage 4 — Solution Design | Not Started | |
| Stage 5 — Architecture Validation | Not Started | |
| Stage 6 — Delivery Validation | Not Started | |
| Stage 7 — Client Perspective Review | Not Started | |
| Stage 8 — Governance Validation | Not Started | |
| Stage 9 — Output Generation | Not Started | |
| Stage 10 — System Learning | Not Started | |
```

Update `Current Stage` in the header and the corresponding row in Stage Status after each stage completes.

---

## Engagement Teardown

Run this procedure when an engagement is complete, before beginning a new engagement in the same workspace.

### Purpose
Prevent prior engagement findings, decisions, and notes from contaminating a new engagement's memory and analysis.

### Step 1 — Archive (before clearing)
Create an archive folder at `archive/[client-name]-[date]/` and copy the following files into it:

| File | Action |
|---|---|
| `claude-memory/memory.md` | Copy to archive |
| `claude-memory/artifacts.md` | Copy to archive |
| `claude-memory/notes.md` | Copy to archive |
| `claude-memory/decisions.md` | Copy to archive |
| `plan.md` | Copy to archive |
| `outputs/staged-proposal.md` | Copy to archive (if exists) |

### Step 2 — Reset (after archive confirmed)
Clear the following files by replacing their content with just the header template (as defined in the File Templates section above):

| File | Reset Action |
|---|---|
| `claude-memory/memory.md` | Header only: `# Findings Memory` + `> Extracted findings for current engagement.` |
| `claude-memory/artifacts.md` | Header + empty table (see File Templates) |
| `claude-memory/notes.md` | Header + initial sections (see File Templates) |
| `claude-memory/decisions.md` | Header only (see File Templates) |
| `plan.md` | Full template (see File Templates) |
| `outputs/staged-proposal.md` | Delete or replace with header + empty stage sections |

### Step 3 — Persist (do not clear)
The following files accumulate cross-engagement learning and must **not** be reset:

| File | Why Persist |
|---|---|
| `claude-memory/insights.md` | Cross-engagement patterns and recurring observations |
| `claude-memory/improvements.md` | System improvement proposals — cleared only by manual triage |

### Step 4 — Confidentiality Confirmation
Before beginning the new engagement, confirm:

> "Prior engagement data has been archived to `archive/[client-name]-[date]/`. Memory files have been reset. `claude-memory/insights.md` and `claude-memory/improvements.md` carry forward cross-engagement learning only — no client-identifying data from the prior engagement remains in active memory."

If you cannot confirm this, do not begin the new engagement. Re-run Steps 1–3.

---

## System Change Review Checklist

Run this checklist before committing any change to system files (`.claude/`, `claude-memory/improvements.md`). Each check is derived from a real failure pattern found during post-implementation review.

The checklist is divided into two passes. Run Pass 1 first (structural — grep-based, exhaustive). Run Pass 2 second (consistency — cross-file, reasoning-based).

---

### Pass 1 — Structural Sweep (Run on Every Changed File)

These checks are mechanical. Every item must return zero violations before Pass 2 begins.

#### Check 1.1 — Bare Memory File References
**Pattern:** Files in `claude-memory/` referenced without the `claude-memory/` prefix. Found in: AGENTS.md (Stages 1–3 action lines, Stage 0 Constrained note), capability-coverage SKILL.md, evidence-extraction SKILL.md, evidence-reconciliation SKILL.md, kpi-baseline SKILL.md, pert-estimation SKILL.md, SETUP.md file templates.

**How to check:** Search every changed file for bare references to these filenames without a directory prefix:
```
memory.md, notes.md, artifacts.md, insights.md, decisions.md, improvements.md
```
**Pass condition:** Every occurrence carries either `claude-memory/` prefix or `.claude/` prefix (for system files). Zero bare references permitted in any instruction, action, output, or scope list.

**Exceptions — bare references are valid only when:**
- The reference is inside a code block illustrating user-facing file structure (e.g., a template)
- The file is `plan.md` — it lives at workspace root, not in `claude-memory/`

---

#### Check 1.2 — Stage Name Accuracy
**Pattern:** Stage names used in labels, templates, or tables drifted from the canonical names defined in AGENTS.md. Found in: SETUP.md `plan.md` template (Stage 5 named "Estimation", Stage 6 "Delivery Planning", Stage 7 "Risk & Assumptions").

**How to check:** Search every changed file for any Stage N label (e.g., `Stage 5`, `Stage 6`, `Stage 7`). Verify each name matches the canonical set below exactly:

| Stage | Canonical Name |
|---|---|
| Stage 0 | Artifact Discovery |
| Stage 1 | Evidence Extraction |
| Stage 2 | Memory Initialization |
| Stage 3 | Gap Coverage Enforcement |
| Stage 3.5 | Capability Coverage Check |
| Stage 4 | Solution Design |
| Stage 5 | Architecture Validation |
| Stage 6 | Delivery Validation |
| Stage 7 | Client Perspective Review |
| Stage 8 | Governance Validation |
| Stage 9 | Output Generation |
| Stage 10 | System Learning |

**Pass condition:** Every stage label in every changed file matches the canonical name character-for-character.

---

#### Check 1.3 — Duplicate Content
**Pattern:** Duplicate list items or structural dividers introduced during editing. Found in: estimation-sizing-thinking SKILL.md (duplicate output item 7), improvements.md (double `---` divider before Archive).

**How to check:** Scan changed files for:
- Repeated `---` dividers (two in sequence with no content between them)
- Duplicate numbered list items (same item text appearing twice in the same ordered list)
- Duplicate section headings at the same heading level within the same file

**Pass condition:** Zero duplicated structural elements.

---

### Pass 2 — Consistency Check (Cross-File, Reasoning-Based)

These checks require comparing related files against each other. Run after Pass 1 is clean.

---

#### Check 2.1 — Context Scope Completeness
**Pattern:** A stage or skill's Context Scope section did not list all files it actually reads or writes. Found in: Conductor (Stages 0–3) scope missing `plan.md` even though Stage 3 explicitly reads Discovery Maturity from it.

**How to check:** For every changed stage definition or changed SKILL.md:
1. Read every instruction that contains: *load*, *read*, *populate*, *write to*, *update*, *check*, *verify*
2. For each file named in those instructions, verify it appears in the relevant row of the **Agent Context Scope table** (AGENTS.md) or the **Context Scope section** of the SKILL.md
3. If the file is absent from the scope declaration, it must be added

**Pass condition:** Every file a stage or skill reads or writes is listed in its declared context scope. No file is accessed silently.

---

#### Check 2.2 — New File Propagation
**Pattern:** When a new file was introduced (e.g., `governance.md`, Gap Coverage routed to `notes.md`), not all references to the old location or all references that should now include the new file were updated. Found in: System File Protection path in AGENTS.md still used bare `improvements.md` after governance.md was extracted; deferral gate in evidence-reconciliation SKILL.md still pointed to memory.md instead of notes.md.

**How to check:** When any of the following occurs — a new file is created, a file is renamed, or a section's storage location changes:
1. Search all system files for all references to the old file name or old location
2. Search for all instructions referencing the function that file performed (e.g., "gap coverage", "improvement proposals")
3. Confirm: SETUP.md file templates, Agent Context Scope table, Memory Rules, skill Context Scope sections all reflect the current state

**Pass condition:** No orphaned references. Every file reference across the system resolves to a file that exists or is declared in SETUP.md templates.

---

#### Check 2.3 — AGENTS.md ↔ Skill Handoff Alignment
**Pattern:** Stage definitions in AGENTS.md and the corresponding SKILL.md contradict each other on inputs, outputs, or storage targets. Found in: Stage 3 in AGENTS.md wrote gap coverage to `notes.md`, but evidence-reconciliation SKILL.md's Deferred Validation Gate read from `memory.md` — a mismatch that broke the Stage 3 → Stage 8 data flow.

**How to check:** For every changed stage definition or changed SKILL.md:
1. Find the corresponding SKILL.md (for a changed stage) or AGENTS.md stage definition (for a changed skill)
2. Verify: Output file written by stage N matches input file read by stage N+1 or stage 8
3. Verify: Skill handoff section names the correct next stage and correct output file

**Pass condition:** Every stage output consumed by a downstream stage or skill matches exactly — file name, section heading, and content type.

---

#### Check 2.4 — Schema Consistency Across Descriptions
**Pattern:** The same template or format was described in multiple places with inconsistent field names or rules. Found in: Stage 9 completeness checklist existed in both AGENTS.md and review-challenge-thinking SKILL.md; Deferred to Transition required fields stated in AGENTS.md did not fully match governance.md wording.

**How to check:** When a template, schema, or validation rule is changed in any file, search for every other place that template is described or referenced:
- If the same format is described in two files: designate one as source of truth; the other carries only a pointer
- If the same rule is enforced in two files: verify the wording is identical or the non-authoritative file explicitly defers to the authoritative one

**Pass condition:** No format or rule exists in two places with different wording. If duplication is intentional, the non-authoritative copy carries an explicit source-of-truth reference.

---

### Checklist Summary Sign-Off

Before committing, confirm:

| Check | Description | Status |
|---|---|---|
| 1.1 | Bare memory file references — zero found | Pass / ⚠ Fail |
| 1.2 | Stage names match canonical set exactly | Pass / ⚠ Fail |
| 1.3 | No duplicate content or structural dividers | Pass / ⚠ Fail |
| 2.1 | Context scope lists every file accessed by stage/skill | Pass / ⚠ Fail |
| 2.2 | New/moved files propagated to all reference points | Pass / ⚠ Fail |
| 2.3 | Stage ↔ skill handoff file paths align end-to-end | Pass / ⚠ Fail |
| 2.4 | Shared templates/rules have single source of truth | Pass / ⚠ Fail |

Any `⚠ Fail` blocks commit. Resolve before pushing.

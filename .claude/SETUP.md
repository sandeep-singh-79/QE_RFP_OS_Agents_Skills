# SETUP.md — Workspace Initialization

**Load this file:**
- During workspace initialization, before Stages 0–3 begin
- At Stage 0 — when initialising the `## Dependency Register` in `claude-memory/notes.md` (template defined in File Templates below)
- At Stage 4+ — when creating `outputs/staged-proposal.md` for the first time (template defined in File Templates below)
- By the system change author (human) — before committing any change to `.claude/` or `claude-memory/improvements.md` (System Change Review Checklist, end of this file)

Workspace initialization procedures for the QE RFP Operating System, engagement teardown procedure, and System Change Review Checklist for human developers committing changes to system files.

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

**claude-memory/memory.md** — Header: `# Findings Memory` + `> Extracted findings for current engagement. Written by Stage 1 (evidence-extraction skill). Read by all downstream agents and Stage 8 governance.`

Initial metadata block (written by Conductor at Stage 2):
```md
Client Domain: [Banking / Healthcare / Payments / etc. — or omit if unknown]
Regulatory Context: [Explicit / Inferred ([framework], confidence [score]) / Unknown]

## Extraction Completeness
Extraction status: [Complete / Partial]
[If Partial: list artifacts not yet processed and reason]
```

---

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

## Cross-Agent Flags
| Flag ID | Source Stage | Source Agent | Target Agent | Severity (Blocking/Advisory) | Description | Resolution |
|---|---|---|---|---|---|---|

## Execution Trace
| Stage | Agent/Skill | Started | Files Read | Files Written | Findings | HITL | Status |
|---|---|---|---|---|---|---|---|
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
| Stage 3 — Gap Coverage Enforcement | Not Started | |
| Stage 3.5 — Capability Coverage Check | Not Started | |
| Stage 4 — Solution Design | Not Started | |
| Stage 5 — Architecture Validation | Not Started | |
| Stage 6 — Delivery Validation | Not Started | |
| Stage 7 — Client Perspective Review | Not Started | |
| Stage 8 — Governance Validation | Not Started | |
| Stage 9 — Output Generation | Not Started | |
| Stage 10 — System Learning | Not Started | |

## Contract Risk Overrides
> Optional. Populated by conductor when engagement context warrants a different Risk Level
> than the contract default. Downgrades require stated justification.

| Contract ID | Default Risk Level | Override Level | Justification |
|---|---|---|---|

## Decision State Register
> Runtime state of all active contracts for this engagement.
> State must be one of: Created / Escalated / Approved / Rejected / Executed / Invalidated / Closed
> When plan.md is absent (early stages or Mode 2), agents declare state inline in output and mark it [UNREGISTERED — not recorded in plan.md].
> Version starts at 1 when state is first set to `Created`; increments by 1 on every subsequent state transition. Never reset.
> The conductor is the sole writer of this register during active workflow. Always read the current file before writing — do not write from a cached copy.

| Contract ID | Decision | State | Version | Last Updated | Updated By | Notes |
|---|---|---|---|---|---|---|
| TA-01 | Architecture Readiness Gate | Created | | | | |
| TA-02 | Scalability Gap Flag | Created | | | | |
| TA-03 | Integration Dependency Flag | Created | | | | |
| TA-04 | Tooling Validation Authorization | Created | | | | |
| QM-01 | Adoption Risk Escalation | Created | | | | |
| QM-02 | Sustainability Escalation | Created | | | | |
| QM-03 | Adoption Resistance Flag | Created | | | | |
| CE-01 | Scoring Risk Surface | Created | | | | |
| CE-02 | Red Flag Surface | Created | | | | |
| PM-01 | Plan Feasibility Flag | Created | | | | |
| PM-02 | Client Dependency Escalation | Created | | | | |
| TR-01 | Tooling Recommendation Handback | Created | | | | |
| TR-02 | Scope Protection Decline | Created | | | | |
| TR-03 | Capability Clarification Escalation | Created | | | | |

## Decision Log
> Append-only record of all state transitions and invalidation events for this engagement.
> Each cascade invalidation must have its own individual entry — no bulk entries.
> Snapshot discipline: a full State Register snapshot must be appended to this log at every stage `Complete` boundary (LINT-L05). Never mark a stage Complete without the corresponding snapshot.

| Timestamp | Contract ID | From State | To State | Version | Reason | Updated By |
|---|---|---|---|---|---|---|
```

Update `Current Stage` in the header and the corresponding row in Stage Status after each stage completes.

---

## Engagement Teardown

Run this procedure when an engagement is complete, before beginning a new engagement in the same workspace.

### Purpose
Prevent prior engagement findings, decisions, and notes from contaminating a new engagement's memory and analysis.

### Step 0 — Close untriggered contracts (before archiving)
Before archiving, transition all contracts still in `Created` state in the Decision State Register to `Closed` with reason `Untriggered — engagement closed`. Add an individual entry to the Decision Log for each. This ensures the archive contains a complete and honest record — no contract is left in an ambiguous open state.

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

**Audience:** This checklist is for the **human developer or system author** making changes to system files. It is not an agent-runtime check. Run it before every commit to `.claude/` or `claude-memory/improvements.md`.

Each check is derived from a real failure pattern found during post-implementation review. Footnote markers (e.g., [^1]) in each Pattern field link to the **Historical Examples** section at the bottom of this checklist, which names the files where that violation was first discovered — those files have since been fixed. Do not interpret the historical examples as indicating current violations in those files.

The checklist is divided into two passes. Run Pass 1 first (structural — grep-based, exhaustive). Run Pass 2 second (consistency — cross-file, reasoning-based).

---

### Step 0 — Diff Scoping (Run First)

Before running any check, produce the exact file list that this review covers:

```bash
git diff main --name-only -- .claude/ claude-memory/improvements.md claude-memory/insights.md
```

All subsequent checks scope to this file list only. Do not run checks against unchanged files.

---

### Pass 1 — Structural Sweep (Run on Every Changed File)

These checks are mechanical. Every item must return zero violations before Pass 2 begins.

#### Check 1.1 — Bare Memory File References [Blocks commit]
**Pattern:** Files in `claude-memory/` referenced without the `claude-memory/` prefix. [^1]

**How to check:** Search every changed file for bare references to these filenames without a directory prefix:
```
memory.md, notes.md, artifacts.md, insights.md, decisions.md, improvements.md
```

**Scope — check ALL of the following, not just body text:**
- Instruction lines (load, read, write, populate, check, verify, update)
- YAML frontmatter `description:` and `name:` fields — these are frequently missed
- Table cells and bullet lists
- Output format examples
- Context Scope declarations

**Pass condition:** Every occurrence carries either `claude-memory/` prefix or `.claude/` prefix (for system files). Zero bare references permitted in any of the above contexts.

**Exceptions — bare references are valid only when:**
- The reference is inside a ` ``` ` code block illustrating user-facing file structure (e.g., a template or schema)
- The file is `plan.md` — it lives at workspace root, not in `claude-memory/`
- The text is a section heading or prose that *describes the file itself* (e.g., `## Artifact Index (artifacts.md)` or `memory.md header fields:`) — these are explanatory labels, not access instructions. If in doubt: does the line instruct an agent to load or access the file? If yes, it must have the prefix.
- The text is a historical violation example or footnote reference (e.g., `[^1]` markers or entries in the Historical Examples section) — these are documentation references, not agent instructions. This exemption applies to entries in this checklist itself.

---

#### Check 1.2 — Stage Name Accuracy [Blocks commit]
**Pattern:** Stage names used in labels, templates, or tables drifted from the canonical names defined in AGENTS.md. [^2]

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

#### Check 1.3 — Duplicate Content [Flag for review]
**Pattern:** Duplicate list items or structural dividers introduced during editing. [^3]

**How to check:** Scan changed files for:
- Repeated `---` dividers (two in sequence with no content between them)
- Duplicate numbered list items — same item text appearing **twice within the same ordered list block** (not across different sections of the file)
- Duplicate section headings at the same heading level within the same file

**Pass condition:** Zero duplicated structural elements within the same list or section scope. Note: identical item text appearing in two *different* sections (e.g., the same governance step repeated for Stage 1 and Stage 2) is not a violation.

---

#### Check 1.4 — Malformed File Paths [Blocks commit]
**Pattern:** File path strings that are syntactically incorrect — double-prefix, missing directory, wrong separator. [^4]

**How to check:** Search every changed file for any path string containing:
- Double directory prefix — in instructions or scope declarations: `claude-memory/claude-memory/` or `.claude/.claude/`
- Paths starting with `/` that are meant to be workspace-relative
- Backslash separators `\` in path strings (all paths must use `/`)

Note: example patterns that appear inside inline code spans (` \`claude-memory/claude-memory/\` `) or inside this checklist's own **Pattern** description lines are not violations — they are documentation.

Scan particularly in:
- Context Scope declarations in SKILL.md files
- Agent Context Scope table in AGENTS.md
- File reference lines in SETUP.md

**Pass condition:** Every file path string has exactly one directory prefix and uses forward slashes.

---

#### Check 1.5 — Frontmatter Integrity (Agent and Skill Files) [Blocks commit]
**Pattern:** YAML frontmatter in agent or skill files missing required fields, or `description:` field becoming stale after body edits. [^5]

**When this check applies:** Run on every changed `.md` file inside `.claude/agents/` or `.claude/skills/*/`.

**How to check:**
1. Confirm a YAML frontmatter block is present (file starts with `---`, has `name:` and `description:` fields, closes with `---`)
2. Confirm `name:` matches the file's stem — e.g., `name: conductor` for `conductor.md`; `name: capability-coverage` for `capability-coverage/SKILL.md`
3. Confirm `description:` contains no bare memory file references (apply Check 1.1 scope to the frontmatter fields specifically)
4. Confirm `description:` still accurately reflects the body scope — if allowed/prohibited skills changed, or the activation conditions changed, the description must also be updated

**Pass condition:** Frontmatter block present with valid `name:` and `description:`. Description is free of bare refs and consistent with body content.

---

#### Check 1.6 — Client-Specific Leakage [Blocks commit]
**Pattern:** Client names, project-specific proper nouns, or branded terms hardcoded in global OS files (`.claude/` directory or `claude-memory/insights.md`, `claude-memory/improvements.md`). OS files must use generic placeholders (`client`, `[Client]`, `client-approved`) so they are reusable across engagements. [^6]

**How to check:** Search every changed file in `.claude/` and `claude-memory/insights.md` and `claude-memory/improvements.md` for:
- Known client names from current or recent engagements
- Any proper noun that identifies a specific company, product, or branded team name that is not R Systems

**Exceptions — client names are valid only when:**
- The reference is inside `claude-memory/memory.md`, `claude-memory/notes.md`, `claude-memory/artifacts.md`, `claude-memory/decisions.md`, or any file in `outputs/` — these are engagement-scoped, not reusable
- The reference is inside the `**Derived from:**` line of an improvement proposal (attribution is allowed)
- The reference is inside a historical example footnote in this checklist

**Pass condition:** Zero client-specific names in `.claude/` files or in the reusable fields of cross-engagement memory files. Specifically:
- `improvements.md` **Suggested Change** text must use generic placeholders — Observation, Root Cause, Status, and Derived from fields are engagement-scoped and may reference the client
- `insights.md` **Insight body text** must use generic placeholders — section headings providing engagement attribution (e.g., `## Phase 15 — [Client] Proposal Review Insights`) and `Derived from` lines may reference the client

---

#### Check 1.7 — Behavior Leakage in Agent Files [Flag for review]
**Pattern:** Agent files using reasoning/detection verbs instead of accountability verbs in instruction, FLAG, or output expectation lines.

**How to check:** Search every changed file in `.claude/agents/` for these verbs in instruction lines (FLAG lines, Skill Usage policy, Output Expectations):
- identify, assess, evaluate, determine, analyze, detect, calculate

**Pass condition:** Agent instruction lines use accountability verbs: ensure, confirm, approve, authorize, escalate, flag. Reasoning verbs in prose paragraphs, Role Definition narrative, or YAML description fields are acceptable but should be reviewed for alignment.

**Exceptions:**
- `evaluate`/`evaluator` as a noun in client-rfp-evaluator.md (persona identity)
- `evaluate` in client-rfp-evaluator.md evaluation dimension section headings §1–§12 (framework vocabulary)
- `Check whether:` in project-manager.md planning assessment areas (verification language, not reasoning)

---

#### Check 1.8 — Responsibility Leakage in Skill Files [Flag for review]
**Pattern:** Skill files claiming stage-control authority, clearance conditions, or decision ownership that belongs to the conductor.

**How to check:** Search every changed file in `.claude/skills/*/` for:
- `blocks Stage`, `clears Stage`, `cannot proceed`, `blocked until`, `must not pass control`
- `approve`, `authorize`, `decision authority`, `accountable for` (where the skill claims the authority, not describing what a calling agent owns)

**Pass condition:** Skills raise HITL flags and produce assessments/verdicts. All stage progression decisions explicitly reference conductor authority. The HALT detection pattern ("STOP — condition not met") is permitted; defining clearance conditions ("Stage N clears when...") is not.

---

#### Check 1.9 — Decision Presence in Agent Responsibility Lines [Flag for review]
**Rule ID:** LINT-A03

**Pattern:** Agent responsibility lines that describe activity or alignment without specifying a decision outcome — lines that answer "what does this agent do?" but not "what does this agent decide?"

**How to check:** For every `Ensure`, `Confirm`, `Approve`, `Authorize`, `Escalate`, or `Flag` line in `.claude/agents/` instruction blocks (Assessment Sequence sections, Tooling sections, Output Expectations), verify it answers: *"What decision does this agent make — and what happens when the condition is not met?"*

**PASS examples:**
- `Confirm all layers are addressed before proceeding to tooling validation`
- `Flag any scalability gap before the architecture is approved for proposal submission`
- `Escalate where team capability gaps could delay adoption or reduce quality outcomes`

**FAIL examples:**
- `Ensure architecture completeness` (no decision stated — reads as ongoing monitoring)
- `Confirm alignment with business objectives` (no failure path — what happens when alignment is absent?)
- `Confirm that: [bullet list]` with no follow-on line stating what to do when a bullet fails

**Pass condition:** Every agent `Confirm that:` block has an explicit follow-on action (Flag, Escalate, Reject, or gate) stating what the agent does when criteria are not met. Standalone `Ensure X` lines must either be in Operating Stance sections (principle framing) or be refactored to include a decision outcome.

**Exceptions:**
- Operating Stance sections — two- or three-sentence principle paragraphs that set standards for the agent's mindset rather than discrete instruction checks
- YAML `description:` field — trigger/routing description, not an instruction

---

#### Check 1.10 — Skill Invocation Traceability [Flag for review]
**Rule ID:** LINT-A04

**Pattern:** Agent approval or authorization decisions that do not reference the skill or skill output that produced the evidence supporting that decision — "floating authority" with no evidentiary anchor.

**How to check:** For every `Approve`, `Authorize`, or `Reject` line in `.claude/agents/` instruction blocks, check whether the line or its surrounding context references a named skill or skill output as the evidentiary basis for the decision.

**PASS examples:**
- `Approve architecture readiness after QE Architect Thinking confirms layer completeness`
- `Authorize design baseline once Review & Challenge Thinking quality gate passes`
- `Approve delivery readiness based on Estimation & Sizing Thinking output`

**FAIL examples:**
- `Approve delivery readiness` (no skill reference — decision appears to float without evidence)
- `Authorize architecture baseline` (no traceable skill invocation)

**Pass condition:** All `Approve` and `Authorize` decisions in agent instruction lines either (a) reference the skill that enables the decision, or (b) appear in a section whose heading names the skill (e.g., `## Tooling Validation — invokes Tooling & Technology Recommendation`).

**Scope exceptions:**
- Conductor agent: coordinates skill invocations structurally; individual approval lines need not repeat skill names if the Stage procedure already defines the dependency in AGENTS.md
- `Reject` and `Decline` lines: not required to cite a skill if the rejection criterion is already stated inline

---

#### Check 1.11 — No Silent Authority in Escalations [Flag for review]
**Rule ID:** LINT-G02

**Pattern:** Escalation or rejection statements in any agent file that do not name the condition, finding, or threshold that triggered the action — authority exercised without stated justification.

**How to check:** For every `Escalate` and `Reject` line in `.claude/agents/` instruction blocks, verify it names the condition or failure that triggers it.

**PASS examples:**
- `Escalate where team capability gaps could delay adoption or reduce quality outcomes`
- `Flag any unresolved integration dependency before the architecture is approved`
- `Escalate where operational sustainability concerns exceed what the team can reasonably absorb`

**FAIL examples:**
- `Escalate delivery risk` (no trigger — what risk? on what evidence?)
- `Reject the architecture` (insufficiently specific — what condition triggers rejection?)

**Pass condition:** Every `Escalate` and `Reject` line names the condition, finding category, or threshold that justifies the action. Silent authority — authority exercised without stated justification — is a governance violation under this checklist.

**Scope exceptions:**
- Scope Boundary Protocol `decline and redirect` lines: these are scope-enforcement responses, not governance escalations; they do not need a named condition beyond the scope violation itself

---

#### Check 1.12 — Decision Outcome Completeness [Flag for review]
**Rule ID:** LINT-A05

**Pattern:** A Decision Contract in `.claude/references/decision-contracts.md` is missing an `Allowed Outcomes:` field, leaving the decision without bounded options and unable to drive deterministic or automatable governance.

**How to check:** For every contract block (fenced ` ``` ` block) in `decision-contracts.md`, verify it contains an `Allowed Outcomes:` field with at least one outcome defined.

**PASS examples:**
- `Allowed Outcomes:  Approve / Reject`
- `Allowed Outcomes:  Escalate / Flag`

**FAIL examples:**
- Contract block that ends with `Mode Applicability:` but has no `Allowed Outcomes:` field at all

**Pass condition:** Every contract in `.claude/references/decision-contracts.md` defines `Allowed Outcomes:`. A contract without bounded outcomes cannot drive deterministic or automatable governance.

**Scope:** Applies to `.claude/references/decision-contracts.md` only. Does not apply to `## Decision Authority` sections in agent files — those use role-variant verb lines, not contract blocks.

---

### Pass 2 — Consistency Check (Cross-File, Reasoning-Based)

These checks require comparing related files against each other. Run after Pass 1 is clean.

---

#### Check 2.1 — Context Scope Completeness [Blocks commit]
**Pattern:** A stage or skill's Context Scope section did not list all files it actually reads or writes. [^7]

**How to check:** For every changed stage definition or changed SKILL.md:
1. Read every instruction that contains: *load*, *read*, *populate*, *write to*, *update*, *check*, *verify*
2. For each file named in those instructions, verify it appears in the relevant row of the **Agent Context Scope table** (AGENTS.md) or the **Context Scope section** of the SKILL.md
3. If the file is absent from the scope declaration, it must be added

**Pass condition:** Every file a stage or skill reads or writes is listed in its declared context scope. No file is accessed silently.

---

#### Check 2.2 — New File Propagation [Blocks commit]
**Pattern:** When a new file was introduced (e.g., `governance.md`, Gap Coverage routed to `notes.md`), not all references to the old location or all references that should now include the new file were updated. [^8]

**How to check:** When any of the following occurs — a new file is created, a file is renamed, or a section's storage location changes:
1. Search all system files for all references to the old file name or old location
2. Search for all instructions referencing the function that file performed (e.g., "gap coverage", "improvement proposals")
3. Confirm: SETUP.md file templates, Agent Context Scope table, Memory Rules, skill Context Scope sections all reflect the current state

**Pass condition:** No orphaned references. Every file reference across the system resolves to a file that exists or is declared in SETUP.md templates.

---

#### Check 2.3 — Stage Procedure ↔ Governance ↔ Skill Handoff Alignment [Blocks commit]
**Pattern:** Stage definitions in AGENTS.md, governance obligations in conductor.md, and the corresponding SKILL.md contradict each other on inputs, outputs, or storage targets. [^9]

**Three-way check** (AGENTS.md owns procedure; conductor.md owns governance enforcement; SKILL.md owns execution logic):

**How to check:** For every changed stage definition, conductor.md governance section, or changed SKILL.md:
1. Find all three: (a) AGENTS.md stage definition, (b) the corresponding conductor.md Stage Responsibilities section, (c) the corresponding SKILL.md
2. Verify: Output file written by stage N in AGENTS.md matches the file the conductor.md governance obligation references, and matches the input file declared in the downstream SKILL.md or stage definition
3. Verify: Section heading names (`## Gap Coverage`, `## Stage 4 — Solution Design`, etc.) match exactly across all three
4. Verify: The conductor.md `Procedure: Follow AGENTS.md — [section]` pointer names a section that actually exists in AGENTS.md

**Pass condition:** Every stage output consumed by a downstream stage or skill matches exactly across all three files — file name, section heading, and content type. No dangling conductor pointers.

---

#### Check 2.4 — Schema Consistency Across Descriptions [Blocks commit]
**Pattern:** The same template or format was described in multiple places with inconsistent field names or rules. [^10]

**How to check:** When a template, schema, or validation rule is changed in any file, search for every other place that template is described or referenced:
- If the same format is described in two files: designate one as source of truth; the other carries only a pointer
- If the same rule is enforced in two files: verify the wording is identical or the non-authoritative file explicitly defers to the authoritative one

**Pass condition:** No format or rule exists in two places with different wording. If duplication is intentional, the non-authoritative copy carries an explicit source-of-truth reference.

**Addendum — Runtime-Fill Cell Rule [Flag for review]:** In checklist or template tables where a column is explicitly filled at runtime (e.g., Pass/Fail status column in the Completeness Checklist), that column must be blank at commit time. Pre-filled content in a runtime column is a violation. [^11]

---

#### Check 2.5 — Agent Roster and Context Scope Table Completeness [Blocks commit]
**Pattern:** A new agent is added to the Agent Roster table but its corresponding file does not exist, or the Agent Context Scope table is not updated to include a row for the new agent. [^12]

**When this check applies:** Run when AGENTS.md Agent Roster or Agent Context Scope table is changed, or when a new agent file is created.

**How to check:**
1. For every row in the Agent Roster table: confirm the listed file path (`agents/[name].md`) exists in `.claude/agents/`
2. For every new or modified agent: confirm a corresponding row exists in the Agent Context Scope table with all required memory files listed
3. For every row in the Agent Context Scope table: confirm each file listed in the Required Context column either exists in the workspace or is declared in SETUP.md file templates as a create-on-first-write file
4. Verify the Agent Roster row count equals or is covered by the Context Scope table row count (accounting for agents with multiple context rows like the Conductor)

**Pass condition:** Every agent in the Roster has a file that exists. Every agent has at least one Context Scope row. No phantom file references in scope declarations.

---

#### Check 2.6 — Cross-File Pointer Correctness [Blocks commit]
**Pattern:** Files that reference sections or headings in other files by name can silently break when the target file is renamed or restructured. [^13]

**When this check applies:** Run when conductor.md Stage Responsibilities are changed, or when any file adds a cross-file section reference (e.g., `See [file] — [## Section Name]`).

**How to check:**
1. For every `Procedure: Follow AGENTS.md — [section name]` in conductor.md: confirm that exact section heading exists in AGENTS.md
2. For every `see [file] — [## Section]` or `load [file] — [## Section]` instruction in any changed file: confirm the target section heading exists in the referenced file
3. For every agent or skill file reference in the Agent Roster or Skill Roster table: confirm the file path is correct and the file exists

**Pass condition:** Every cross-file section pointer resolves to an existing heading in the target file. No dangling references.

---

#### Check 2.7 — Stage Write-Scope Enforcement [Blocks commit]
**Pattern:** A stage rule in AGENTS.md or `stage-9-output-structure.md` instructs a write action (`add`, `log`, `write`, `update`) to a memory file that is not within that stage's declared write scope in the Agent Context Scope table. [^14]

**How to check:** For every changed stage rule that contains a write-action verb (`add`, `log`, `write`, `update`, `populate`) targeting a `claude-memory/` file:
1. Identify which stage the rule belongs to
2. Look up that stage's row in the Agent Context Scope table in AGENTS.md
3. Verify the target file appears in the stage's write-permitted list
4. If it does not, either move the write instruction to the correct stage or add the file to the stage's scope (with justification)

**Pass condition:** Every write instruction in a stage rule targets a file within that stage's declared write scope. No stage writes to a file it does not own.

---

#### Check 2.8 — Register/Table Schema Consistency [Blocks commit]
**Pattern:** An example row added to a stage rule or improvement proposal has a different field count from the canonical schema for that register or table. [^15]

**How to check:** When a change adds or modifies a table row example (Dependency Register, Risk Register, OC table, or any structured register):
1. Count the fields (pipe-delimited columns) in the example row
2. Look up the canonical schema for that register in SETUP.md File Templates section or the authoritative definition in AGENTS.md
3. Verify the field count matches exactly
4. If the example has extra fields, fold the additional information into an existing field (typically Description) rather than extending the schema in one place

**Pass condition:** Every example row matches the canonical field count for its register type. No ad-hoc schema extensions.

---

#### Check 2.9 — Agent Responsibility Count [Flag for review]
Rule ID: LINT-G03

**Pattern:** Agent files accumulating more than 7 distinct accountability lines in the `## Decision Authority` section, causing the agent to become a generic reasoning layer.

**How to check:** Count only the lines beginning with `- Approve`, `- Reject`, `- Escalate`, `- Authorize`, `- Flag`, `- Surface`, `- Recommend`, or `- Decline` inside the `## Decision Authority` section of each `.claude/agents/` file. Do not count:
- Assessment area headings or evaluation dimension headings (e.g., client-rfp-evaluator §1–12)
- Skill usage policy lines
- The opening mode note
- The `Decision Contracts →` reference line

**Pass condition:** Decision Authority accountability line count ≤ 7 per agent. If exceeded, split responsibilities across specialised agents or consolidate overlapping lines before committing.

**Scope exception:** client-rfp-evaluator `## Evaluation Dimensions` (§1–12) are assessment criteria applied during analysis, not accountability responsibilities — exclude from count entirely.

---

#### Check 2.10 — Contract Dependency Integrity [Flag for review]
**Rule ID:** LINT-A06

**Pattern:** A contract in `.claude/references/decision-contracts.md` with a non-None `Depends On:` field references a dependency contract whose `Allowed Outcomes:` does not include the stated required outcome, or references a later-stage contract as a prerequisite.

**How to check:** For every contract where `Depends On:` is not `None`:
1. Identify the dependency contract ID and required outcome stated in the `Depends On:` value
2. Locate the referenced dependency contract in `decision-contracts.md`
3. Verify the dependency contract's `Allowed Outcomes:` includes the required outcome
4. Verify the dependency contract belongs to an earlier or equal stage in the workflow

**Key dependency chains to verify at each commit:**
- TA-04 (`Depends On: TA-01 (Approve outcome required)`) — confirm TA-01 `Allowed Outcomes:` includes `Approve`
- TR-01 (`Depends On: TA-04 (Authorize outcome required)`) — confirm TA-04 `Allowed Outcomes:` includes `Authorize`
- TR-03 (`Depends On: TR-01 attempted`) — confirm TR-01 exists and has `Recommend` in `Allowed Outcomes:`

**Pass condition:** Every non-None `Depends On:` field references a contract that (a) exists, (b) can produce the stated required outcome, and (c) belongs to a prior or equal stage. No forward-referencing dependencies.

**Scope:** Applies to `.claude/references/decision-contracts.md` only.

---

#### Check 2.11 — Dependency Cycle Prevention [Flag for review]
**Rule ID:** LINT-D01

**Pattern:** A `Depends On:` chain in `.claude/references/decision-contracts.md` forms a cycle — following the dependency chain eventually leads back to the originating contract.

**How to check:** For every contract with a non-None `Depends On:` field:
1. Traverse the chain: contract A → A's `Depends On` → that contract's `Depends On`, and so on
2. If any contract ID appears twice during traversal, a cycle exists

**Example of a violation:**
- TR-01 `Depends On: TA-04` and TA-04 `Depends On: TR-01` — both contracts block waiting on each other

**Pass condition:** Every dependency chain terminates at a contract whose `Depends On:` is `None`. No contract ID appears more than once in any single traversal.

**Scope:** Applies to `.claude/references/decision-contracts.md` only. Check at authoring time and whenever an existing `Depends On:` field is modified.

---

#### Check 2.12 — Upstream Outcome State Validation [Flag for review]
**Rule ID:** LINT-D02

**Pattern:** A decision contract lists a non-None `Depends On:` value but the referenced upstream contract has no recorded outcome at execution time — the downstream decision executes without the upstream gate being resolved.

**How to check:** At agent execution time, before actioning a decision:
1. Identify the `Depends On:` value for the contract being evaluated
2. If not `None`, verify the upstream contract has a recorded outcome (Approve / Reject / Escalate / Recommend as appropriate)
3. If the upstream outcome is absent, **block** the downstream decision

**Pass condition:** Every decision with a non-None `Depends On:` confirms the upstream outcome is recorded before executing.
- Mode 1: Missing upstream outcome is a **blocking gate** — decision must not proceed
- Mode 2: Missing upstream outcome is a **scope-limitation disclosure** — agent qualifies output and states what is unresolved

**Scope:** Applies at agent execution time. When reviewing plan.md stage outputs, verify upstream outcomes are logged before downstream stages activate.

---

#### Check 2.13 — Dependency Depth Limit [Flag for review]
**Rule ID:** LINT-D03

**Pattern:** A dependency chain in `.claude/references/decision-contracts.md` exceeds 3 levels of depth (e.g., A → B → C → D is depth 4 — a violation).

**How to check:** For each contract with a non-None `Depends On:` field, count chain depth starting at 1:
1. Contract A (depth 1) `Depends On: B`
2. Contract B (depth 2) `Depends On: C`
3. Contract C (depth 3) `Depends On: None` ← passes
4. Contract C (depth 3) `Depends On: D` ← **violation** — chain reaches depth 4

**Pass condition:** No dependency chain exceeds depth 3. If a chain requires depth > 3, the decision model must be restructured (split decisions, consolidate intermediate approvals, or change ownership) before the contract is committed.

**Scope:** Applies to `.claude/references/decision-contracts.md` only.

---

#### Check 2.14 — Decision State Value Validation [Flag for review]
**Rule ID:** LINT-L01

**Pattern:** A `State:` value recorded in the `## Decision State Register` in `plan.md` is not one of the six canonical lifecycle states.

**Valid values:** `Created` / `Escalated` / `Approved` / `Rejected` / `Executed` / `Invalidated` / `Closed`

**How to check:** At each HITL checkpoint and stage gate, scan the Decision State Register. Flag any State value that does not exactly match one of the six canonical values. A blank State cell is treated as `Created` (not yet formally recorded).

**Pass condition:** Every State cell in the Decision State Register contains exactly one canonical value or is blank.

**Scope:** Applies to `plan.md` Decision State Register only.

---

#### Check 2.15 — Invalidated Upstream Blocks Downstream [Blocks commit]
**Rule ID:** LINT-L02

**Pattern:** A contract whose `Depends On:` references an upstream contract currently in `Invalidated` state holds a State value of `Approved`, `Executed`, or `Escalated` — meaning it is proceeding on a revoked upstream approval.

**How to check:** For every contract with a non-None `Depends On:` value:
1. Look up the upstream contract's current State in the Decision State Register
2. If upstream State = `Invalidated`, the downstream contract must be `Invalidated`, `Created`, or `Closed`
3. If downstream is `Approved`, `Executed`, or `Escalated` while upstream is `Invalidated` — violation

**Key chains to check:**
- TA-04 depends on TA-01 — if TA-01 = `Invalidated`, TA-04 must not be `Approved` / `Executed`
- TR-01 depends on TA-04 — if TA-04 = `Invalidated`, TR-01 must not be `Approved` / `Executed`

**Pass condition:** No contract with an `Invalidated` upstream holds an active-forward state (`Approved` / `Executed` / `Escalated`).

**Severity:** Blocks commit when found in a `plan.md` being committed. Flag for review when found during stage review.

**Scope:** Applies to `plan.md` Decision State Register only.

---

#### Check 2.16 — Invalidation Cascade Completeness [Blocks commit]
**Rule ID:** LINT-L03

**Pattern:** A contract is marked `Invalidated` but one or more downstream contracts whose `Depends On:` chain passes through it still holds state `Approved` or `Executed` — the cascade was not fully applied.

**How to check:** When any contract is marked `Invalidated`:
1. Identify all contracts that depend (directly or transitively) on the invalidated contract
2. Verify each downstream contract is also `Invalidated`, `Created`, or `Closed`
3. Verify the Decision Log contains an individual entry per cascaded contract (no bulk entries)

**Cascade chains to validate:**
- TA-01 invalidated → TA-04 must be `Invalidated`/`Created` → TR-01 must be `Invalidated`/`Created`
- TA-04 invalidated → TR-01 must be `Invalidated`/`Created`

**Pass condition:** Every downstream contract in an invalidation cascade has been transitioned to `Invalidated` or `Created`. Decision Log contains a separate entry per cascaded contract.

**Scope:** Applies to `plan.md` Decision State Register and Decision Log.

---

#### Check 2.17 — Illegal State Transition [Blocks commit]
**Rule ID:** LINT-L04

**Pattern:** A Decision Log entry records a From State → To State pair that is not on the permitted transition list, or the current State in the State Register is unreachable from the prior state in the permitted transitions.

**How to check:** For every Decision Log entry where a state transition occurred, and for every current State in the State Register, verify the From→To pair is in the permitted transitions table:

| From State | Permitted To States |
|---|---|
| Created | Escalated, Approved, Rejected |
| Escalated | Approved, Rejected |
| Approved | Executed, Invalidated |
| Rejected | Created |
| Executed | Invalidated, Closed |
| Invalidated | Created, Closed |
| Closed | (terminal — no transitions permitted) |

**Pass condition:** Every From→To pair recorded in the Decision Log is in the permitted transitions table above. No contract in the State Register holds a State that is unreachable from the prior recorded State via the permitted list.

**Scope:** Applies to `plan.md` Decision State Register and Decision Log.

---

#### Check 2.18 — Stage Completion Snapshot Enforcement [Blocks commit]
**Rule ID:** LINT-L05

**Pattern:** A stage is marked `Complete` in plan.md Stage Status, but the Decision Log has no corresponding `SNAPSHOT — Stage [N] complete —` block for that stage.

**How to check:** For every stage marked `Complete` in the plan.md Stage Status table, verify the Decision Log contains a snapshot block beginning with `SNAPSHOT — Stage [N] complete —` that includes a full copy of the Decision State Register (with Version column) at that point.

**Pass condition:** Every `Complete` stage in plan.md has a corresponding snapshot block in the Decision Log. If no stages are marked `Complete`, this check passes trivially.

**Scope:** Applies to `plan.md` Decision Log and Stage Status table.

---

### Checklist Summary Sign-Off

Before committing, confirm:

| Check | Description | Severity | Status |
|---|---|---|---|
| 1.1 | Bare memory file references — zero found (including frontmatter fields) | Blocks commit | |
| 1.2 | Stage names match canonical set exactly | Blocks commit | |
| 1.3 | No duplicate content or structural dividers (within same list scope) | Flag for review | |
| 1.4 | No malformed file paths (double-prefix, wrong separator) | Blocks commit | |
| 1.5 | Frontmatter present and valid on all changed agent/skill files | Blocks commit | |
| 1.6 | No client-specific names in global OS or cross-engagement memory files | Blocks commit | |
| 1.7 | No reasoning verbs in agent instruction/FLAG/output lines | Flag for review | |
| 1.8 | No stage-control or clearance language in skill files | Flag for review | |
| 1.9 | Every agent `Confirm that:` block has explicit failure-path action (LINT-A03) | Flag for review | |
| 1.10 | Approval/authorization decisions reference the enabling skill (LINT-A04) | Flag for review | |
| 1.11 | No escalation or rejection without named trigger condition (LINT-G02) | Flag for review | |
| 1.12 | Every Decision Contract defines `Allowed Outcomes:` (LINT-A05) | Flag for review | |
| 2.1 | Context scope lists every file accessed by stage/skill | Blocks commit | |
| 2.2 | New/moved files propagated to all reference points | Blocks commit | |
| 2.3 | Stage ↔ skill handoff file paths align end-to-end | Blocks commit | |
| 2.4 | Shared templates/rules have single source of truth | Blocks commit | |
| 2.4a | Runtime-fill columns blank at commit time | Flag for review | |
| 2.5 | Agent Roster files exist; Context Scope table has row for every agent | Blocks commit | |
| 2.6 | Cross-file section pointers resolve to existing headings | Blocks commit | |
| 2.7 | Stage write actions target only files within declared write scope | Blocks commit | |
| 2.8 | Example rows match canonical field count for their register type | Blocks commit | |
| 2.9 | Decision Authority accountability line count ≤ 7 per agent (LINT-G03) | Flag for review | |
| 2.10 | Contract Depends On chains reference valid, achievable outcomes (LINT-A06) | Flag for review | |
| 2.11 | No dependency cycles in decision contracts (LINT-D01) | Flag for review | |
| 2.12 | Upstream outcome recorded before downstream decision executes (LINT-D02) | Flag for review | |
| 2.13 | No dependency chain exceeds depth 3 (LINT-D03) | Flag for review | |
| 2.14 | Decision State values are one of 6 canonical states (LINT-L01) | Flag for review | |
| 2.15 | No Approved/Executed contract has an Invalidated upstream (LINT-L02) | Blocks commit | |
| 2.16 | Invalidation cascade fully applied — all downstream contracts updated (LINT-L03) | Blocks commit | |
| 2.17 | All Decision Log transitions use permitted From→To pairs — no illegal transitions (LINT-L04)[^24] | Blocks commit | |
| 2.18 | Every `Complete` stage has a Decision Log snapshot — no stage completed without snapshot (LINT-L05)[^25] | Blocks commit | |

Any `⚠ Fail` on a **Blocks commit** check blocks the commit. **Flag for review** failures produce a warning but do not block — document the justification if proceeding.

---

### Historical Examples

The footnotes below record the files where each check's pattern was first discovered. All listed files have since been fixed.

[^1]: **Check 1.1** — AGENTS.md (Stages 1–3 action lines, Stage 0 Constrained note), capability-coverage SKILL.md, evidence-extraction SKILL.md, evidence-reconciliation SKILL.md (frontmatter `description:` field), kpi-baseline SKILL.md, pert-estimation SKILL.md, SETUP.md file templates.
[^2]: **Check 1.2** — SETUP.md `plan.md` template (Stage 5 named "Estimation", Stage 6 "Delivery Planning", Stage 7 "Risk & Assumptions").
[^3]: **Check 1.3** — estimation-sizing-thinking SKILL.md (duplicate output item 7), improvements.md (double `---` divider before Archive).
[^4]: **Check 1.4** — evidence-extraction SKILL.md Context Scope with `claude-memory/claude-memory/artifacts.md` (double-prefix introduced during editing).
[^5]: **Check 1.5** — evidence-reconciliation SKILL.md frontmatter `description:` field contained a bare memory ref and described stale scope after the Context Scope section was updated.
[^6]: **Check 1.6** — `stage-9-output-structure.md` IP-MAN-12 gate example contained `Manulife-approved` instead of `client-approved`; `improvements.md` IP-MAN-14 Suggested Change contained `Manulife Test Manager` instead of `[Client] Test Manager`.
[^7]: **Check 2.1** — Conductor (Stages 0–3) scope missing `plan.md` even though Stage 3 explicitly reads Discovery Maturity from it.
[^8]: **Check 2.2** — System File Protection path in AGENTS.md still used bare `improvements.md` after governance.md was extracted; deferral gate in evidence-reconciliation SKILL.md still pointed to memory.md instead of notes.md.
[^9]: **Check 2.3** — Stage 3 in AGENTS.md wrote gap coverage to `claude-memory/notes.md`, but evidence-reconciliation SKILL.md's Deferred Validation Gate read from `claude-memory/memory.md` — a mismatch that broke the Stage 3 → Stage 8 data flow.
[^10]: **Check 2.4** — Stage 9 completeness checklist existed in both AGENTS.md and review-challenge-thinking SKILL.md; Deferred to Transition required fields stated in AGENTS.md did not fully match governance.md wording.
[^11]: **Check 2.4a** — Submission Hygiene row in `review-challenge-thinking/SKILL.md` had pre-filled Pass/Fail text in the status column.
[^12]: **Check 2.5** — conductor agent added to Agent Roster without a conductor-specific row in prior Context Scope iterations.
[^13]: **Check 2.6** — conductor.md uses `Procedure: Follow stage-workflow.md — Stage N — [Name]` references; skill files reference other skill files and AGENTS.md/stage-workflow.md sections by heading name.
[^14]: **Check 2.7** — IP-MAN-14 original implementation instructed Stage 9 to add an entry to the Dependency Register in `claude-memory/notes.md`, but only Stages 4, 5, and 6 have write access to that file for dependency logging.
[^15]: **Check 2.8** — IP-MAN-14 example Dependency Register row had 6 fields (including a separate Impact column) vs the canonical 5-field schema defined in SETUP.md File Templates.
[^16]: **Check 1.12 / LINT-A05** — Preventive rule. No prior violation file — introduced proactively to enforce `Allowed Outcomes:` completeness in `.claude/references/decision-contracts.md` before any contract is written without bounded outcomes.
[^17]: **Check 2.10 / LINT-A06** — Preventive rule. No prior violation file — introduced alongside the `Depends On:` field to enforce contract dependency chain integrity. The key enforced chains are TA-04→TA-01 and TR-01→TA-04.
[^18]: **Check 2.11 / LINT-D01** — Preventive rule. No prior violation file — introduced to prevent dependency cycles as the decision graph grows over time. A cycle would cause deadlock where no contract in the cycle can be resolved.
[^19]: **Check 2.12 / LINT-D02** — Preventive rule. No prior violation file — introduced to close the silent bypass gap: `Depends On:` enforces structural dependencies, but LINT-D02 enforces that the upstream outcome is actually recorded before the downstream decision fires.
[^20]: **Check 2.13 / LINT-D03** — Preventive rule. No prior violation file — introduced to bound dependency graph depth at 3 levels. Deep chains increase debugging complexity, slow execution, and create fragile workflows. Depth > 3 is a signal that the decision model needs restructuring.
[^21]: **Check 2.14 / LINT-L01** — Preventive rule. No prior violation file — introduced to enforce canonical state values in the Decision State Register. Prevents free-text state entries that cannot be validated by LINT-L02 or LINT-L03.
[^22]: **Check 2.15 / LINT-L02** — Preventive rule. No prior violation file — introduced to prevent decisions from proceeding on a revoked upstream approval. Operates at runtime state level (plan.md State Register). Complementary to LINT-D02 (Check 2.12), which operates at schema level (decision-contracts.md `Depends On:` field): LINT-D02 ensures the upstream outcome was recorded; LINT-L02 ensures the upstream has not since been Invalidated. Both must pass for a downstream decision to proceed safely.
[^23]: **Check 2.16 / LINT-L03** — Preventive rule. No prior violation file — introduced to enforce cascade completeness. Without this check, partial cascades leave the system in an inconsistent state where downstream contracts continue operating on an indirectly invalidated chain.
[^24]: **Check 2.17 / LINT-L04** — Preventive rule. No prior violation file — introduced to prevent illegal state transitions being written to plan.md. Without this check, a corrupted state write could move a contract to a state it cannot legally reach, breaking lifecycle invariants silently.
[^25]: **Check 2.18 / LINT-L05** — Preventive rule. No prior violation file — introduced to enforce the snapshot discipline required for rollback and audit traceability. Without this check, stage completion snapshots can be silently skipped, making it impossible to reconstruct lifecycle state at any prior stage boundary.

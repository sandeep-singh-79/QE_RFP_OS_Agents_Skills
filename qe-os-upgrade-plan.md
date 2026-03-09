# QE OS Architecture Upgrade — Implementation Plan

> **Purpose:** Detailed plan for upgrading `AGENTS.md` from a system conductor into a full QE RFP Operating System harness.  
> **Target file:** `.claude/AGENTS.md`  
> **Supporting files:** `.claude/copilot-instructions.md`, `claude-memory/*`, new workspace files  
> **Audience:** Implementing agent or model  
> **Created:** 2026-03-09  

---

## Ground Rules for the Implementing Agent

1. **Read before writing.** Load `.claude/AGENTS.md` and `.claude/copilot-instructions.md` in full before making any changes.
2. **Preserve what works.** The current `AGENTS.md` has battle-tested sections. Do not delete, reword, or restructure them unless the plan explicitly says to.
3. **Additive, not destructive.** The upgrade adds new layers around the existing structure. Existing agents, skills, routing, conflict resolution, and quality gate rules are retained.
4. **One file at a time.** Complete each file change fully before moving to the next. Do not leave partial edits.
5. **Do not create files prematurely.** Memory files (`decisions.md`, `artifacts.md`, `improvements.md`) are defined in structure but only created when first needed at runtime, not during this implementation.
6. **Do not duplicate `copilot-instructions.md` content into `AGENTS.md`.** Reference it by pointer. The guardrail rules (anti-hallucination, input validation, scope boundaries, confidentiality, context efficiency) remain in `copilot-instructions.md` only.

---

## Current System Inventory

### What Exists Today

| File | Location | Purpose | Status |
|---|---|---|---|
| `AGENTS.md` | `.claude/AGENTS.md` | System conductor — routing, workflow, quality gates, conflict resolution, sequencing | **Being upgraded** |
| `copilot-instructions.md` | `.claude/copilot-instructions.md` | System-wide guardrails (§1–§6) | **No changes needed** |
| 5 agent files | `.claude/agents/*.md` | Role-based agents with scope boundary protocols | **No changes needed** |
| 9 skill folders | `.claude/skills/*/SKILL.md` | Reasoning patterns with HALT mechanisms | **No changes needed** |
| `settings.json` | `.claude/settings.json` | Permissions | **Needs update** |
| `CLAUDE.md` | root | Claude Code pointer (`@import`) | **No changes needed** |
| `AGENTS.md` | root | Codex/OpenCode pointer stub | **No changes needed** |
| `.github/copilot-instructions.md` | `.github/` | GitHub Copilot pointer stub | **No changes needed** |
| `plan.md` | root | Guardrail implementation tracker | **Exists — already used** |
| `claude-memory/memory.md` | `claude-memory/` | Implementation context | **Exists — repurpose** |
| `claude-memory/notes.md` | `claude-memory/` | Working notes | **Exists — repurpose** |
| `claude-memory/insights.md` | `claude-memory/` | Structural insights | **Exists — repurpose** |

### What Does NOT Exist Yet (Required by Prompt)

| File | Purpose | Create Now? |
|---|---|---|
| `claude-memory/decisions.md` | Decision log | **Define structure only — create at runtime** |
| `claude-memory/artifacts.md` | Artifact index | **Define structure only — create at runtime** |
| `claude-memory/improvements.md` | QE OS improvement proposals | **Define structure only — create at runtime** |

---

## Gap Analysis: What the Prompt Asks vs What Already Exists

| Prompt Requirement | Current State | Gap | Action Required |
|---|---|---|---|
| **1. Orchestration Layer** | `AGENTS.md` has routing, workflow, sequencing, conflict resolution, quality gates | Partial — missing system purpose header, memory usage rules, context loading rules, review checkpoints per stage | Add missing sections to existing `AGENTS.md` |
| **2. Memory Layer** | `claude-memory/` exists with `memory.md`, `notes.md`, `insights.md`. `plan.md` exists at root | Missing `decisions.md`, `artifacts.md`, `improvements.md`. Existing files need structure alignment | Repurpose existing files + define schemas for new files |
| **3. Evidence Extraction Layer** | Not present | Full gap — no artifact discovery or evidence extraction stage | Add as new Stage 0–1 in workflow |
| **4. Evidence Reconciliation Rule** | Not present | Full gap — no reconciliation check before output | Add as governance rule + Stage 8 checkpoint |
| **5. Knowledge vs Memory Separation** | Implicit — `copilot-instructions.md` §1 requires sourcing | Not formalized as a named layer | Add definitions section to `AGENTS.md` |
| **6. Skills Layer** | Fully defined — Skill Roster with 9 skills + sequencing rules | No gap | No changes needed |
| **7. Agents Layer** | Fully defined — Agent Roster with 5 agents + routing guide | No gap | No changes needed |
| **8. Governance Layer** | Partial — quality gate, conflict resolution, HALT mechanisms exist | Missing: gap coverage enforcement, evidence reconciliation, HITL decision matrix, proposal quality rules | Add Governance Layer section |
| **9. Decision-Centric HITL Model** | Not present | Full gap — no decision-risk classification or human-pause mechanism | Add HITL section to `AGENTS.md` |
| **10. Execution Workflow** | 7-stage workflow exists (Stages 1–7) | Missing: Stage 0 (Artifact Discovery), Stage 1 (Evidence Extraction), Stage 2 (Memory Initialization), Stage 8 (Governance Validation), review checkpoints per stage | Expand existing workflow from 7 stages to 10 |
| **11. Continuous Learning Loop** | Not present | Full gap — no Stage 10, no feedback mechanism | Add Stage 10 + improvements.md schema |
| **12. Workspace Initialization** | Not present as formal rule | Full gap — no lazy-creation rule for workspace files | Add workspace initialization section |
| **System file protection** | Not present | Full gap — no rule preventing agents from modifying system files | Add to governance + `copilot-instructions.md` |

---

## Implementation Tasks

### Task 1: Restructure AGENTS.md Header and System Purpose

**What:** Replace the current one-line description with a proper system purpose block.

**Where:** `.claude/AGENTS.md`, lines 1–4

**Current:**
```md
# AGENTS.md — System Conductor

This file defines how agents and skills work together. It governs routing, invocation order, quality gates, and conflict resolution. It does not restrict direct invocation — explicit user calls always take precedence.
```

**Replace with:**
```md
# AGENTS.md — QE RFP Operating System

This file is the execution harness for the QE RFP Operating System (QE OS). It governs:
- System purpose and scope
- Available agents and skills
- Execution workflow (Stages 0–10)
- Governance enforcement rules
- Memory usage and context loading rules
- Review checkpoints
- Decision-centric human-in-the-loop controls
- Continuous learning feedback loop

System guardrails (anti-hallucination, input validation, scope boundaries, confidentiality, context efficiency) are defined in `copilot-instructions.md` and apply at all times. They are not repeated here.

User calls always take precedence over routing recommendations.
```

**Preserve:** Everything after line 4 remains untouched in this task.

---

### Task 2: Add Knowledge vs Memory Definitions

**What:** Add a new section defining the separation between knowledge sources (external inputs) and memory (derived workspace state).

**Where:** `.claude/AGENTS.md` — insert as a new section **after** the current Skill Roster section, **before** Agent Selection — Routing Guide.

**Content to insert:**

```md
---

## Knowledge vs Memory

### Knowledge Sources (External Inputs)
Knowledge is content provided to the system from outside. It is not generated by agents. Sources include:
- RFP documents
- Client briefs and clarification responses
- Architecture diagrams and technical documentation
- Test assets and automation artifacts
- Call transcripts and meeting notes
- Known Error Database (KEDB) — optional

Knowledge sources are indexed in `artifacts.md` when they enter the system.

### Memory (Derived Workspace State)
Memory is structured context generated by agents during workflow execution. It is stored in workspace files:

| File | Purpose | When Created |
|---|---|---|
| `plan.md` | Engagement plan and task tracking | Exists |
| `memory.md` | Structured findings extracted from artifacts — each entry includes source artifact, extraction timestamp, and confidence level (High / Medium / Low) | Exists |
| `notes.md` | Working notes and in-progress analysis | Exists |
| `insights.md` | Reusable insights discovered across engagements (e.g., common QE maturity gaps, automation adoption blockers, proposal evaluation patterns) | Exists |
| `decisions.md` | Major system and architecture decisions with rationale | Created when first decision is logged |
| `artifacts.md` | Index of all knowledge source artifacts with type classification | Created when first artifact is registered |
| `improvements.md` | Proposed improvements to the QE OS itself — used by the continuous learning loop | Created when first improvement is proposed |

### Memory Rules
1. Memory files are stored in `claude-memory/` (except `plan.md` which is at root)
2. Files that do not exist are created when first needed — not prematurely
3. Agents read memory before starting substantive work
4. Agents write findings to memory after completing work
5. Memory is workspace-scoped — it does not persist across separate engagements unless explicitly carried forward
```

---

### Task 3: Add Artifact Index and Evidence Extraction Definitions

**What:** Define the artifact indexing schema and the Evidence Extraction stage responsibilities.

**Where:** `.claude/AGENTS.md` — insert as a new section **after** Knowledge vs Memory, **before** Agent Selection — Routing Guide.

**Content to insert:**

```md
---

## Artifact Index (artifacts.md)

When knowledge sources enter the system, they are registered in `artifacts.md` with the following structure:

| Field | Description |
|---|---|
| Artifact ID | Sequential identifier (A1, A2, ...) |
| Name | Descriptive name |
| Type | RFP Document / Clarification / Architecture Diagram / Test Asset / Transcript / KEDB / Other |
| Source | Where the artifact came from (client, vendor, internal) |
| Date Received | When the artifact entered the system |
| Status | Pending Review / Evidence Extracted / Not Applicable |

The system must function even if **only an RFP document exists** as the sole artifact.

---

## Evidence Extraction

Evidence Extraction is a **mandatory system stage** (Stage 1 in the execution workflow). It is not optional and runs before any agent-level analysis begins.

### Responsibilities
1. Identify all artifacts from `artifacts.md`
2. Scan each artifact for structured findings
3. Classify findings by type (requirement, constraint, risk, gap, opportunity)
4. Extract structured findings into `memory.md` with: source artifact, extraction timestamp, confidence level
5. Identify missing evidence — requirements referenced but not substantiated
6. Flag artifacts that have not yet been reviewed

### Extraction Output Format (for memory.md entries)

Each finding in `memory.md` must include:

```
### Finding: [short title]
- **Source:** [Artifact ID + name]
- **Extracted:** [timestamp]
- **Confidence:** High / Medium / Low
- **Type:** Requirement / Constraint / Risk / Gap / Opportunity
- **Detail:** [structured finding]
```

```

---

### Task 4: Expand the Execution Workflow from 7 Stages to 11

**What:** Replace the current 7-stage "Canonical Multi-Agent Workflow" with an expanded 11-stage workflow (Stages 0–10) that includes artifact discovery, evidence extraction, memory initialization, governance validation, and continuous learning.

**Where:** `.claude/AGENTS.md` — replace the entire `## Canonical Multi-Agent Workflow (Full RFP Review)` section.

**Current section to replace** (preserve the exact boundaries):
- Starts at: `## Canonical Multi-Agent Workflow (Full RFP Review)`
- Ends at: `**This workflow is a recommendation, not a lock.** Explicit user instructions override any stage or sequence.`

**Replace with:**

```md
## Canonical Multi-Agent Workflow (Full RFP Review)

When a full RFP response or proposal needs comprehensive review, use this sequence. Each stage builds on the previous. Each stage includes a mandatory review checkpoint. Do not skip or reorder unless the user explicitly instructs otherwise.

### Stage 0 — Artifact Discovery
  Purpose:    Identify and index all available knowledge sources
  Action:     Register artifacts in `artifacts.md` with type classification
  Checkpoint: Confirm artifact inventory is complete before proceeding
  Output:     Populated `artifacts.md`

### Stage 1 — Evidence Extraction
  Purpose:    Extract structured findings from all registered artifacts
  Action:     Scan artifacts, classify findings, populate `memory.md`
  Checkpoint: Confirm all artifacts have status = Evidence Extracted or Not Applicable
  Output:     Populated `memory.md` with sourced, timestamped, confidence-rated findings

### Stage 2 — Memory Initialization
  Purpose:    Confirm workspace memory is ready for agent-level analysis
  Action:     Verify `memory.md` findings are sufficient. Populate `notes.md` with engagement context. Load `insights.md` for relevant prior patterns.
  Checkpoint: Confirm minimum context is available for downstream agents
  Output:     Workspace memory files ready

### Stage 3 — Gap Coverage Enforcement
  Purpose:    Ensure all High-confidence findings have been accounted for
  Action:     Cross-reference `memory.md` against known requirements from artifacts
  Checkpoint: Every High-confidence finding is either addressed or explicitly acknowledged as out of scope. No known gap may disappear silently.
  Output:     Gap coverage report — addressed / out-of-scope / unresolved

### Stage 4 — Solution Design (Architecture Review)
  Agent:      Test Architect
  Skill:      QE Architect Thinking (mandatory first)
  Input:      `memory.md` findings + gap coverage report
  Checkpoint: Architecture layer completeness confirmed before tooling validation
  Output:     Architecture findings, layer gaps, tooling readiness

### Stage 5 — Architecture Validation (Execution Feasibility)
  Agent:      QA Manager
  Input:      Stage 4 output
  Skill:      Assumption & Dependency Management
  Checkpoint: Adoption risks classified and surfaced
  Output:     Adoption risk, team sustainability findings

### Stage 6 — Delivery Validation
  Agent:      Project Manager
  Input:      Stage 4 + 5 output
  Skill:      Estimation & Sizing Thinking (if timelines in scope)
  Checkpoint: All delivery dependencies identified and classified
  Output:     Sequencing risks, dependency gaps, planning realism findings

### Stage 7 — Client Perspective Review
  Agent:      Client / RFP Evaluator
  Input:      Structured findings from Stages 4–6 (after Outcome & Risk Framing → Structuring)
  Skills:     Outcome & Risk Framing → Structuring & Consulting Thinking (pre-processing)
  Checkpoint: Scoring risks and defensibility gaps surfaced
  Output:     Scoring risks, defensibility gaps, red flags

### Stage 8 — Governance Validation
  Purpose:    Enforce governance rules before output generation
  Actions:
    1. **Evidence Reconciliation** — verify all High-confidence findings from `memory.md` are addressed in the solution or explicitly acknowledged as out of scope
    2. **Decision-Centric HITL check** — assess whether any decisions exceed the risk threshold requiring human approval
    3. **Proposal Quality Rules** — verify output meets quality standards
  Checkpoint: All governance checks pass, or human approval obtained for exceptions
  Output:     Governance clearance or list of items requiring human decision

### Stage 9 — Output Generation (Quality Gate)
  Skill:      Review & Challenge Thinking (MANDATORY)
  Input:      Full output from all prior stages + governance clearance
  Checkpoint: Gap classification complete, submission readiness confirmed
  Output:     Challenged, reviewed output ready for delivery
  Post-gate:  Executive Communication skill (if executive-facing output required)

### Stage 10 — System Learning
  Purpose:    Improve the QE OS based on engagement experience
  Actions:
    1. Identify findings that were missed during evidence extraction
    2. Identify reasoning weaknesses in agent or skill outputs
    3. Identify workflow inefficiencies or sequencing problems
    4. Generate improvement proposals for the QE OS
  Output:     Improvement proposals recorded in `improvements.md`
  Rule:       Agents propose improvements only — they do not directly modify system files

**This workflow is a recommendation, not a lock.** Explicit user instructions override any stage or sequence.
```

**Critical notes for the implementing agent:**
- The existing Stages 1–7 map to the new Stages 4–9. The content of those stages is preserved in meaning, but reorganized.
- Stages 0–3, 8, and 10 are entirely new additions.
- Stage 8 (Governance Validation) is new and incorporates Evidence Reconciliation.
- Stage 10 (System Learning) is new and feeds into `improvements.md`.
- The code-block format of the old workflow is replaced with heading-based format for each stage. This is intentional — the new format supports checkpoints per stage.

---

### Task 5: Add Governance Layer Section

**What:** Add a formal Governance Layer section defining the governance rules that run during workflow execution.

**Where:** `.claude/AGENTS.md` — insert as a new section **after** Mandatory Quality Gate, **before** Inter-Agent Conflict Resolution.

**Content to insert:**

```md
---

## Governance Layer

Governance rules are system-level policies enforced during workflow execution. They supplement (not replace) the guardrails in `copilot-instructions.md`.

### Gap Coverage Enforcement (Stage 3 + Stage 8)
- All High-confidence findings in `memory.md` must be either:
  - **Addressed** in the solution design, or
  - **Explicitly acknowledged** as out of scope with stated rationale
- No known gap may disappear silently between evidence extraction and output generation
- Gap coverage is checked at Stage 3 (before agent analysis) and again at Stage 8 (before output)

### Evidence Reconciliation (Stage 8)
Before producing final outputs, verify:
- Every High-confidence finding from `memory.md` has a traceable resolution
- Findings that were present in evidence but absent from the solution are flagged
- Unresolved findings are surfaced under *"Unresolved Findings — Decision Required"*

### Proposal Quality Rules
Outputs intended for client submission must:
- Pass the Review & Challenge Thinking quality gate (Stage 9)
- Have all assumptions declared per `copilot-instructions.md` §1
- Have all dependencies surfaced per Assumption & Dependency Management skill
- Have all client-sensitive content labelled per `copilot-instructions.md` §5

### System File Protection
Agents must **never directly modify** system files:
- `.claude/AGENTS.md`
- `.claude/copilot-instructions.md`
- `.claude/CLAUDE.md`
- Any file in `.claude/skills/`
- Any file in `.claude/agents/`
- `.claude/settings.json`

Instead, agents record proposed changes in `improvements.md`. System file updates occur **only after explicit human approval**.
```

---

### Task 6: Add Decision-Centric HITL Model

**What:** Add the human-in-the-loop decision model that pauses execution when decision risk exceeds a threshold.

**Where:** `.claude/AGENTS.md` — insert as a new section **after** Governance Layer, **before** Inter-Agent Conflict Resolution.

**Content to insert:**

```md
---

## Decision-Centric Human-in-the-Loop (HITL) Model

Human intervention is triggered based on **decision risk**, not workflow position. Any agent at any stage may trigger a HITL pause.

### Decision Risk Categories

| Category | Description | Example |
|---|---|---|
| Business Logic Impact | Decision changes how business rules are interpreted or applied | Recommending a different teller transaction limit structure |
| Compliance Exposure | Decision touches regulatory, audit, or legal territory | Assuming PCI DSS compliance scope without client confirmation |
| Coverage Reduction | Decision reduces test coverage or removes a testing layer | Recommending removal of manual regression in favour of automation-only |
| Behavioral Change | Decision alters user-facing behavior or workflow | Proposing a different approval chain for teller overrides |
| Release Risk | Decision affects release timing, rollback capability, or deployment | Recommending a big-bang cutover vs. phased rollout |
| Data Sensitivity | Decision involves handling of PII, financial data, or credentials | Proposing test data strategies that use production data |
| Traceability Impact | Decision breaks or weakens audit trail or requirement traceability | Removing traceability links between requirements and test cases |

### HITL Rule
If a decision touches **any** of the above categories and the agent cannot confirm from provided inputs that the decision is safe, the system must:

1. **Pause** — do not proceed with the decision
2. **State the decision** — what is being decided
3. **State the risk category** — which category applies
4. **State what is needed** — what confirmation or approval is required
5. **Wait** — do not assume approval; require explicit human confirmation

Format:
```
⚠ HITL PAUSE — Decision Requires Human Approval

Decision: [what is being decided]
Risk Category: [which category]
Why: [why this exceeds the threshold]
Required: [what confirmation is needed to proceed]
```

### HITL Scope
- HITL pauses apply during Stages 4–8 of the workflow (agent analysis and governance)
- HITL does not apply to memory operations (Stages 0–3) or system learning (Stage 10)
- User may explicitly waive HITL for specific decisions, but this must be logged in `decisions.md`
```

---

### Task 7: Add Continuous Learning Section

**What:** Formalize the continuous learning feedback loop (Stage 10) and define the `improvements.md` schema.

**Where:** `.claude/AGENTS.md` — insert as a new section **after** Sequencing Rules (System Level), at the **end** of the file.

**Content to insert:**

```md
---

## Continuous Learning & Feedback Loop

After output generation (Stage 9), the system performs Stage 10 — System Learning. This is not optional for full RFP review workflows.

### Stage 10 Responsibilities
1. **Missed findings** — identify evidence from `memory.md` that was not addressed by any agent
2. **Reasoning weaknesses** — identify where agents produced shallow, assumed, or unsourced analysis
3. **Workflow inefficiencies** — identify stages that were redundant, out of order, or produced low-value output
4. **Improvement proposals** — generate specific, actionable improvement proposals for the QE OS

### improvements.md Schema

Each improvement proposal must follow this format:

```
### Improvement Proposal: [ID]
- **Observation:** [what was observed during the engagement]
- **Root Cause:** [why the system produced a suboptimal result]
- **Suggested Change:** [specific change to agent, skill, or workflow]
- **Impact:** High / Medium / Low
- **Status:** Proposed / Approved / Implemented / Rejected
```

### System File Protection Rule (Repeated for Emphasis)
Agents record improvement proposals in `improvements.md`. They do **not** directly modify:
- `AGENTS.md`, `copilot-instructions.md`, skill files, or agent definitions
- System updates occur only after explicit human review and approval

---

## Workspace Initialization

If required workspace files or folders do not exist, the system may create them when first needed during workflow execution. Do not create files prematurely or speculatively.

### Initialization Order
1. Check if `claude-memory/` directory exists — create if absent
2. Check for required memory files — create with header template when first write is needed
3. `plan.md` at root — create if absent when task tracking begins
4. Never create agent or skill files during initialization — these are system-managed

### File Templates (for creation on first use)

**decisions.md:**
```
# Decisions Log
> Tracks major decisions made during engagement analysis.
```

**artifacts.md:**
```
# Artifact Index
> Registers all knowledge source artifacts entering the system.

| ID | Name | Type | Source | Date Received | Status |
|---|---|---|---|---|---|
```

**improvements.md:**
```
# QE OS Improvement Proposals
> Records proposed improvements to the QE RFP Operating System.
> Agents propose changes here. System updates require human approval.
```
```

---

### Task 8: Add Memory Usage and Context Loading Rules

**What:** Add explicit rules for how agents should load and use workspace memory.

**Where:** `.claude/AGENTS.md` — insert as a new section **after** the Knowledge vs Memory section (added in Task 2), **before** Artifact Index.

**Content to insert:**

```md
---

## Memory Usage Rules

### Before Starting Work
Every agent must, before beginning substantive analysis:
1. Load `memory.md` — check for existing findings relevant to the current task
2. Load `artifacts.md` (if it exists) — check artifact coverage status
3. Load `insights.md` — check for relevant patterns from prior engagements
4. Load `notes.md` — check for in-progress analysis or context from earlier stages

### After Completing Work
Every agent must, after completing its analysis:
1. Write significant findings to `memory.md` with source, timestamp, and confidence level
2. Log major decisions to `decisions.md` with rationale
3. Update `notes.md` with in-progress observations for downstream agents
4. Update `artifacts.md` status if any artifact review status changed

### Context Loading Priority
When context budget is constrained, load files in this priority order:
1. `memory.md` — highest priority (structured findings)
2. Primary artifact (RFP document or content being analyzed)
3. `artifacts.md` — artifact inventory
4. `insights.md` — prior engagement patterns
5. `notes.md` — working context
6. `decisions.md` — decision trail
7. `improvements.md` — lowest priority (system improvement proposals)
```

---

### Task 9: Add Review Checkpoints to Existing Sections

**What:** The prompt requires that every stage has a mandatory review checkpoint. The expanded workflow (Task 4) already includes checkpoints per stage. This task adds a summary checkpoint reference section.

**Where:** `.claude/AGENTS.md` — insert as a new section **after** Governance Layer (Task 5), **before** Decision-Centric HITL Model (Task 6).

**Content to insert:**

```md
---

## Review Checkpoints

Every workflow stage includes a mandatory review checkpoint. The system must confirm the checkpoint condition is met before advancing to the next stage.

| Stage | Checkpoint | Blocks If |
|---|---|---|
| 0 — Artifact Discovery | Artifact inventory confirmed complete | Artifacts remain unregistered |
| 1 — Evidence Extraction | All artifacts have extraction status | Artifacts stuck in Pending Review |
| 2 — Memory Initialization | Minimum context available for downstream agents | Memory files empty or uninitialized |
| 3 — Gap Coverage | All High-confidence findings accounted for | Findings neither addressed nor acknowledged |
| 4 — Solution Design | Architecture layer completeness confirmed | Missing layers not identified |
| 5 — Architecture Validation | Adoption risks classified and surfaced | Feasibility not assessed |
| 6 — Delivery Validation | All delivery dependencies identified | Dependencies unclassified |
| 7 — Client Perspective | Scoring risks and defensibility gaps surfaced | No evaluator review performed |
| 8 — Governance Validation | All governance checks pass or human-approved | Unresolved governance items |
| 9 — Output Generation | Quality gate passed (Review & Challenge) | Output not challenged |
| 10 — System Learning | Improvement proposals recorded | No retrospective performed |

Checkpoint enforcement is at the **conductor level** — violations are flagged but do not hard-block unless a skill-level HALT applies.
```

---

### Task 10: Update settings.json Permissions

**What:** Add permissions for the new memory files that may be created during workflow execution.

**Where:** `.claude/settings.json`

**Current permissions include:**
- `EDIT (claude-memory/**)`  — already covers new files in that directory
- `EDIT (plan.md)` — already exists

**Check:** The current `EDIT (claude-memory/**)` glob already covers `decisions.md`, `artifacts.md`, and `improvements.md`. **No change needed** unless the implementing agent determines the glob doesn't match.

---

## Implementation Order

Execute tasks in this sequence. Dependencies are noted.

| Order | Task | Depends On | Files Modified |
|---|---|---|---|
| 1 | Task 1: Restructure header | None | `.claude/AGENTS.md` |
| 2 | Task 2: Knowledge vs Memory | Task 1 | `.claude/AGENTS.md` |
| 3 | Task 8: Memory Usage Rules | Task 2 | `.claude/AGENTS.md` |
| 4 | Task 3: Artifact Index + Evidence Extraction | Task 2 | `.claude/AGENTS.md` |
| 5 | Task 4: Expand Workflow to 11 stages | Tasks 2, 3 | `.claude/AGENTS.md` |
| 6 | Task 5: Governance Layer | Task 4 | `.claude/AGENTS.md` |
| 7 | Task 9: Review Checkpoints | Tasks 4, 5 | `.claude/AGENTS.md` |
| 8 | Task 6: HITL Model | Task 5 | `.claude/AGENTS.md` |
| 9 | Task 7: Continuous Learning + Workspace Init | Task 4 | `.claude/AGENTS.md` |
| 10 | Task 10: Verify settings.json | Task 7 | `.claude/settings.json` (verify only) |

---

## Expected Final Structure of AGENTS.md

After all tasks are complete, the file should have these sections in this order:

```
# AGENTS.md — QE RFP Operating System          ← Task 1 (rewritten header)
## Agent Roster                                  ← Existing (unchanged)
## Skill Roster                                  ← Existing (unchanged)
## Knowledge vs Memory                           ← Task 2 (new)
## Memory Usage Rules                            ← Task 8 (new)
## Artifact Index (artifacts.md)                 ← Task 3 (new)
## Evidence Extraction                           ← Task 3 (new)
## Agent Selection — Routing Guide               ← Existing (unchanged)
## Canonical Multi-Agent Workflow                ← Task 4 (expanded from 7 to 11 stages)
## Mandatory Quality Gate                        ← Existing (unchanged)
## Governance Layer                              ← Task 5 (new)
## Review Checkpoints                            ← Task 9 (new)
## Decision-Centric HITL Model                   ← Task 6 (new)
## Inter-Agent Conflict Resolution               ← Existing (unchanged)
## Sequencing Rules (System Level)               ← Existing (unchanged)
## Continuous Learning & Feedback Loop           ← Task 7 (new)
## Workspace Initialization                      ← Task 7 (new)
```

---

## Validation Checklist

After implementation, verify:

- [ ] All 5 existing agents are preserved in the Agent Roster (unchanged)
- [ ] All 9 existing skills are preserved in the Skill Roster (unchanged)
- [ ] Agent Selection — Routing Guide is unchanged
- [ ] Inter-Agent Conflict Resolution table is unchanged
- [ ] Sequencing Rules are unchanged (including two-level enforcement)
- [ ] Mandatory Quality Gate section is unchanged
- [ ] No content from `copilot-instructions.md` is duplicated into `AGENTS.md`
- [ ] Workflow stages match: 0 (Artifact Discovery), 1 (Evidence Extraction), 2 (Memory Init), 3 (Gap Coverage), 4 (Solution Design), 5 (Architecture Validation), 6 (Delivery Validation), 7 (Client Perspective), 8 (Governance Validation), 9 (Output Generation/Quality Gate), 10 (System Learning)
- [ ] Every stage has a checkpoint
- [ ] HITL model includes all 7 decision risk categories
- [ ] System file protection rule is present
- [ ] Workspace initialization section defines lazy creation
- [ ] `improvements.md` schema is defined with required fields
- [ ] `memory.md` finding format includes: source artifact, timestamp, confidence level
- [ ] `artifacts.md` schema includes: ID, Name, Type, Source, Date Received, Status
- [ ] `decisions.md` template is defined
- [ ] Context loading priority order is defined (7 levels)
- [ ] File is valid Markdown with no broken formatting

---

## What NOT to Change

These items must be preserved exactly as they are:

1. **Agent Roster table** — 5 agents, file paths, primary roles
2. **Skill Roster table** — 9 skills, when-to-apply rules
3. **Agent Selection — Routing Guide** — routing table and "select by primary concern" rules
4. **Mandatory Quality Gate** — client-facing vs working draft definitions, gate requirements
5. **Inter-Agent Conflict Resolution** — 4 conflict types with resolution hierarchy
6. **Sequencing Rules** — 6 rules with two-level enforcement (skill HALT + conductor flagging)
7. **`copilot-instructions.md`** — no changes to this file
8. **Agent files** (`.claude/agents/*.md`) — no changes
9. **Skill files** (`.claude/skills/*/SKILL.md`) — no changes
10. **Pointer stubs** (`CLAUDE.md`, root `AGENTS.md`, `.github/copilot-instructions.md`) — no changes

---

## Size Budget

The current `AGENTS.md` is **158 lines / 1,162 words / ~1,500 tokens**.

The upgraded file will be substantially larger. Target: **under 400 lines / ~3,500 tokens**. This is acceptable because:
- `AGENTS.md` is the execution harness — it needs to be comprehensive
- It is always-loaded alongside `copilot-instructions.md` (~1,400 tokens)
- Combined always-loaded budget: ~4,900 tokens — still under 3% of context for any modern model
- Agent and skill files are loaded on-demand, not always-on

If the implementing agent finds the file exceeding 400 lines, prioritize cutting verbose descriptions over removing structural sections.

---

## Task & Sub-Task Tracker

### Task 1: Restructure AGENTS.md Header and System Purpose

| # | Sub-Task | Status |
|---|---|---|
| 1.1 | Read current AGENTS.md header (lines 1–4) and confirm content | Complete |
| 1.2 | Replace title from "System Conductor" to "QE RFP Operating System" | Complete |
| 1.3 | Replace single-line description with multi-line system purpose block (8 governance areas + guardrail pointer + user override rule) | Complete |
| 1.4 | Verify content below original line 4 is untouched after edit | Complete |

### Task 2: Add Knowledge vs Memory Definitions

| # | Sub-Task | Status |
|---|---|---|
| 2.1 | Identify insertion point — after Skill Roster section, before Agent Selection — Routing Guide | Complete |
| 2.2 | Insert Knowledge Sources subsection with 6 external input types | Complete |
| 2.3 | Insert Memory subsection with 7-file table (plan.md, memory.md, notes.md, insights.md, decisions.md, artifacts.md, improvements.md) including "When Created" column | Complete |
| 2.4 | Insert Memory Rules (5 rules: storage location, lazy creation, read-before-work, write-after-work, workspace scope) | Complete |

### Task 3: Add Artifact Index and Evidence Extraction Definitions

| # | Sub-Task | Status |
|---|---|---|
| 3.1 | Identify insertion point — after Knowledge vs Memory (Task 2), before Agent Selection — Routing Guide | Complete |
| 3.2 | Insert Artifact Index section with 6-field schema table (ID, Name, Type, Source, Date Received, Status) | Complete |
| 3.3 | Insert "system must function with only an RFP" minimum-artifact rule | Complete |
| 3.4 | Insert Evidence Extraction section header + 6 extraction responsibilities | Complete |
| 3.5 | Insert Extraction Output Format template (Finding title, Source, Extracted, Confidence, Type, Detail) | Complete |

### Task 4: Expand the Execution Workflow from 7 Stages to 11

| # | Sub-Task | Status |
|---|---|---|
| 4.1 | Identify current workflow section boundaries (start: `## Canonical Multi-Agent Workflow`, end: user-override closing statement) | Complete |
| 4.2 | Replace workflow introduction paragraph with expanded version (adds checkpoint language and "do not skip or reorder" rule) | Complete |
| 4.3 | Insert Stage 0 — Artifact Discovery (new: register artifacts in artifacts.md) | Complete |
| 4.4 | Insert Stage 1 — Evidence Extraction (new: scan artifacts, populate memory.md) | Complete |
| 4.5 | Insert Stage 2 — Memory Initialization (new: verify memory readiness) | Complete |
| 4.6 | Insert Stage 3 — Gap Coverage Enforcement (new: cross-reference memory.md vs requirements) | Complete |
| 4.7 | Remap old Stage 1 → Stage 4 — Solution Design (Test Architect + QE Architect Thinking) | Complete |
| 4.8 | Remap old Stage 2 → Stage 5 — Architecture Validation (QA Manager + Assumption & Dependency) | Complete |
| 4.9 | Remap old Stage 3 → Stage 6 — Delivery Validation (Project Manager + Estimation & Sizing) | Complete |
| 4.10 | Remap old Stage 4 → Stage 7 — Client Perspective Review (Client/RFP Evaluator + Outcome & Risk Framing → Structuring) | Complete |
| 4.11 | Insert Stage 8 — Governance Validation (new: evidence reconciliation + HITL check + proposal quality) | Complete |
| 4.12 | Remap old Stages 5–6 → Stage 9 — Output Generation / Quality Gate (Review & Challenge + Executive Communication) | Complete |
| 4.13 | Insert Stage 10 — System Learning (new: missed findings, reasoning weaknesses, workflow inefficiencies, improvement proposals) | Complete |
| 4.14 | Preserve closing statement: "This workflow is a recommendation, not a lock." | Complete |

### Task 5: Add Governance Layer Section

| # | Sub-Task | Status |
|---|---|---|
| 5.1 | Identify insertion point — after Mandatory Quality Gate, before Inter-Agent Conflict Resolution | Complete |
| 5.2 | Insert Gap Coverage Enforcement rules (dual check at Stage 3 + Stage 8; no silent gap disappearance) | Complete |
| 5.3 | Insert Evidence Reconciliation rules (traceable resolution of all High-confidence findings at Stage 8) | Complete |
| 5.4 | Insert Proposal Quality Rules (4 requirements: quality gate, assumptions, dependencies, confidentiality labelling) | Complete |
| 5.5 | Insert System File Protection rule with 6-item protected file/folder list + improvements.md redirect | Complete |

### Task 6: Add Decision-Centric HITL Model

| # | Sub-Task | Status |
|---|---|---|
| 6.1 | Identify insertion point — after Governance Layer (Task 5), before Inter-Agent Conflict Resolution | Complete |
| 6.2 | Insert Decision Risk Categories table with 7 categories (Business Logic, Compliance, Coverage Reduction, Behavioral Change, Release Risk, Data Sensitivity, Traceability Impact) | Complete |
| 6.3 | Insert HITL Rule — 5-step pause protocol (Pause → State Decision → State Category → State Need → Wait) | Complete |
| 6.4 | Insert HITL Pause format template (⚠ block with Decision, Risk Category, Why, Required) | Complete |
| 6.5 | Insert HITL Scope rules (applies Stages 4–8 only; does not apply Stages 0–3 or 10; waiver must be logged in decisions.md) | Complete |

### Task 7: Add Continuous Learning + Workspace Initialization

| # | Sub-Task | Status |
|---|---|---|
| 7.1 | Identify insertion point — after Sequencing Rules (System Level), at end of file | Complete |
| 7.2 | Insert Continuous Learning section header + Stage 10 Responsibilities (4 items: missed findings, reasoning weaknesses, workflow inefficiencies, improvement proposals) | Complete |
| 7.3 | Insert improvements.md schema (5 required fields: Observation, Root Cause, Suggested Change, Impact, Status) | Complete |
| 7.4 | Insert System File Protection Rule (repeated for emphasis — agents do not modify system files) | Complete |
| 7.5 | Insert Workspace Initialization section with 4-step initialization order + "never create agent/skill files" guard | Complete |
| 7.6 | Insert file templates for lazy creation: decisions.md header, artifacts.md header + table, improvements.md header | Complete |

### Task 8: Add Memory Usage and Context Loading Rules

| # | Sub-Task | Status |
|---|---|---|
| 8.1 | Identify insertion point — after Knowledge vs Memory (Task 2), before Artifact Index (Task 3) | Complete |
| 8.2 | Insert "Before Starting Work" rules (4 mandatory loads: memory.md, artifacts.md, insights.md, notes.md) | Complete |
| 8.3 | Insert "After Completing Work" rules (4 mandatory writes: memory.md findings, decisions.md rationale, notes.md observations, artifacts.md status) | Complete |
| 8.4 | Insert Context Loading Priority list (7-level priority order from memory.md highest to improvements.md lowest) | Complete |

### Task 9: Add Review Checkpoints

| # | Sub-Task | Status |
|---|---|---|
| 9.1 | Identify insertion point — after Governance Layer (Task 5), before Decision-Centric HITL Model (Task 6) | Complete |
| 9.2 | Insert checkpoint summary table — 11 rows (one per stage 0–10) with Stage, Checkpoint condition, and Blocks-If columns | Complete |
| 9.3 | Insert conductor-level enforcement note (violations flagged, not hard-blocked unless skill HALT applies) | Complete |

### Task 10: Verify settings.json Permissions

| # | Sub-Task | Status |
|---|---|---|
| 10.1 | Read current `.claude/settings.json` | Complete |
| 10.2 | Verify `EDIT (claude-memory/**)` glob covers decisions.md, artifacts.md, improvements.md | Complete |
| 10.3 | Apply permission changes if glob does not match; confirm no change needed if it does | Complete |

---

### Summary

| Task | Sub-Tasks | Completed | Status |
|---|---|---|---|
| Task 1 — Header & System Purpose | 4 | 4 | Complete |
| Task 2 — Knowledge vs Memory | 4 | 4 | Complete |
| Task 3 — Artifact Index & Evidence Extraction | 5 | 5 | Complete |
| Task 4 — Expand Workflow (7 → 11 stages) | 14 | 14 | Complete |
| Task 5 — Governance Layer | 5 | 5 | Complete |
| Task 6 — HITL Model | 5 | 5 | Complete |
| Task 7 — Continuous Learning + Workspace Init | 6 | 6 | Complete |
| Task 8 — Memory Usage Rules | 4 | 4 | Complete |
| Task 9 — Review Checkpoints | 3 | 3 | Complete |
| Task 10 — Verify settings.json | 3 | 3 | Complete |
| **Total** | **53** | **53** | **Complete** |

---

## Pre-Upgrade Phase: Three Foundational Skills

> **Execution order:** This phase must complete **before** Phase 2 (QE OS Architecture Hardening).  
> **Purpose:** Create three new skills required by the QE OS workflow so that Stages 1, 3.5, and 8 have defined executors and reusable reasoning patterns.  
> **Rules:** Additive only — no modifications to existing skill or agent files. Skills are reasoning patterns, not orchestrators.

### Task P1 — Evidence Extraction & Normalization Skill

- [x] P1.1 — Create directory `.claude/skills/evidence-extraction/`
- [x] P1.2 — Create `.claude/skills/evidence-extraction/SKILL.md` with title and purpose (powers Stage 1 — Evidence Extraction)
- [x] P1.3 — Add Activation Conditions (4 triggers: Stage 1 begins, artifacts.md has artifacts, user requests artifact analysis, conductor invokes)
- [x] P1.4 — Add Context Scope (allowed: artifacts.md, referenced artifact files, memory.md, notes.md; must not load other memory files unless necessary)
- [x] P1.5 — Add Responsibilities (8 items: read artifacts, identify types, extract findings, assign Finding IDs, assign confidence levels, detect contradictions, normalize findings, write to memory.md)
- [x] P1.6 — Add Finding Structure template (F[ID] with Source Artifact, Evidence Type, Confidence, Description, Implication)
- [x] P1.7 — Add Guardrails (no inferred facts, no overwriting findings, no modifying artifacts, no deleting findings; contradictions as ⚠ CONFLICTING FINDING)
- [x] P1.8 — Add Handoff (→ Stage 2 — Memory Initialization; handoff artifact: memory.md)
- [x] P1.9 — Add Failure Handling (no artifacts → output message, workflow continues)

### Task P2 — Capability Coverage Thinking Skill

- [x] P2.1 — Create directory `.claude/skills/capability-coverage/`
- [x] P2.2 — Create `.claude/skills/capability-coverage/SKILL.md` with title and purpose (powers Stage 3.5 — Capability Coverage Check)
- [x] P2.3 — Add Activation Conditions (3 triggers: Stage 3 gap coverage completes, workflow reaches Stage 3.5, Test Architect begins solution design)
- [x] P2.4 — Add Context Scope (allowed: memory.md, qe-capability-map.md, architecture artifacts if needed; must not load unnecessary files)
- [x] P2.5 — Add Responsibilities (4 items: load QE capability baseline, compare evidence against expected capabilities, identify missing capabilities, recommend improvements)
- [x] P2.6 — Add Capability Map Reference (→ `.claude/references/qe-capability-map.md`)
- [x] P2.7 — Add Capability Domains (8: QE Strategy, Shift-left Testing, Automation Strategy, CI/CD Integration, Test Data Management, Environment Strategy, Observability, Non-functional Testing)
- [x] P2.8 — Add Output Format (Capability / Status / Recommendation table with example row)
- [x] P2.9 — Add Guardrails (no assuming capability without evidence, no marking present without verification; statuses: Present / Partial / Missing)
- [x] P2.10 — Add Handoff (→ Stage 4 — Solution Design)

### Task P3 — Evidence Reconciliation Thinking Skill

- [x] P3.1 — Create directory `.claude/skills/evidence-reconciliation/`
- [x] P3.2 — Create `.claude/skills/evidence-reconciliation/SKILL.md` with title and purpose (powers Stage 8 — Governance Validation)
- [x] P3.3 — Add Activation Conditions (3 triggers: solution output produced, governance validation begins, Stage 8 reached)
- [x] P3.4 — Add Context Scope (allowed: memory.md, solution output, notes.md gap report)
- [x] P3.5 — Add Responsibilities (5 items: load all findings from memory.md, check if each is addressed, identify unresolved findings, detect conflicting findings, enforce traceability)
- [x] P3.6 — Add Traceability Rule (all addressed findings must reference Finding ID; example: Resolution F14 → Introduce CI/CD pipeline QA gates)
- [x] P3.7 — Add Output Structure (4 sections: Resolved Findings, Unresolved Findings, Conflicting Findings, Medium-confidence Findings)
- [x] P3.8 — Add Guardrails (no marking resolved without evidence, no deleting findings, no ignoring medium-confidence findings)
- [x] P3.9 — Add Handoff (→ Stage 9 — Output Generation)

### Task P4 — Skill Registration in AGENTS.md

- [x] P4.1 — Read current Skill Roster table in `.claude/AGENTS.md` (currently 9 rows)
- [x] P4.2 — Add `evidence-extraction` row: "Stage 1 — extract and normalize evidence from artifacts"
- [x] P4.3 — Add `capability-coverage` row: "Stage 3.5 — evaluate QE capability coverage against baseline"
- [x] P4.4 — Add `evidence-reconciliation` row: "Stage 8 — reconcile all findings before output generation"
- [x] P4.5 — Add Skill Interaction Rules note after roster (3 pairs: Evidence Extraction ↔ Assumption Management, Capability Coverage ↔ QE Architect Thinking, Evidence Reconciliation ↔ Review & Challenge Thinking)

### Task P5 — Validation

- [x] P5.1 — Verify 3 skill directories exist under `.claude/skills/`
- [x] P5.2 — Verify 3 SKILL.md files exist with content
- [x] P5.3 — Verify guardrails defined in all 3 SKILL.md files
- [x] P5.4 — Verify context scopes defined in all 3 SKILL.md files
- [x] P5.5 — Verify activation conditions defined in all 3 SKILL.md files
- [x] P5.6 — Verify handoffs defined in all 3 SKILL.md files
- [x] P5.7 — Verify Skill Roster in AGENTS.md now lists 12 skills
- [x] P5.8 — Verify workflow stage references are consistent (Stage 1 → evidence-extraction, Stage 3.5 → capability-coverage, Stage 8 → evidence-reconciliation)
- [x] P5.9 — Confirm no existing skill files were modified
- [x] P5.10 — Confirm no existing agent files were modified

### Pre-Upgrade Phase Summary

| Task | Sub-Tasks | Completed | Status |
|---|---|---|---|
| Task P1 — Evidence Extraction Skill | 9 | 9 | Complete |
| Task P2 — Capability Coverage Skill | 10 | 10 | Complete |
| Task P3 — Evidence Reconciliation Skill | 9 | 9 | Complete |
| Task P4 — Skill Registration | 5 | 5 | Complete |
| Task P5 — Validation | 10 | 10 | Complete |
| **Total** | **43** | **43** | **Complete** |

### Expected System State After Pre-Upgrade Phase

| Component | Count |
|---|---|
| Agents | 5 |
| Skills | 12 |
| Governance Layer | Enabled |
| Memory Layer | Enabled |
| Evidence Traceability | Enabled |

### Implementation Order

| Order | Task | Depends On | Parallel? |
|---|---|---|---|
| 1 | P1 — Evidence Extraction | None | Yes — parallel with P2, P3 |
| 1 | P2 — Capability Coverage | None | Yes — parallel with P1, P3 |
| 1 | P3 — Evidence Reconciliation | None | Yes — parallel with P1, P2 |
| 2 | P4 — Skill Registration | P1, P2, P3 | No — sequential |
| 3 | P5 — Validation | P4 | No — sequential |

---

## Phase 2 — Architecture Hardening

> **Execution order:** This phase executes **after** the Pre-Upgrade Phase (foundational skills) completes.  
> **Purpose:** Strengthen QE OS by addressing context explosion risks, memory integrity, evidence reconciliation traceability, agent context scoping, executor ownership, capability coverage, and improvement backlog governance.  
> **Principles:**
> - Additive only — do not remove or rewrite working sections
> - Preserve: Agent Roster, Skill Roster, Routing Guide, Quality Gate, Conflict Resolution, Sequencing Rules, `copilot-instructions.md` guardrails
> - All new logic must support context scoping and summarization
> - Workspace memory remains in `claude-memory/`
> - System files remain human-governed

### P2 Task 1 — Memory Integrity Governance

- [x] P2-1.1 — Identify insertion point — under Governance Layer section in AGENTS.md, after System File Protection
- [x] P2-1.2 — Insert Memory Integrity Rule: agents must never modify or delete existing findings written by another agent
- [x] P2-1.3 — Insert append-only contradiction format (⚠ CONFLICTING FINDING block with: Original Finding ID, Source, New Finding, Explanation, Resolution Status)
- [x] P2-1.4 — Verify existing Governance Layer subsections are untouched

### P2 Task 2 — Context Summarization Mechanism

- [x] P2-2.1 — Identify insertion point — after Memory Usage Rules section, before Artifact Index section
- [x] P2-2.2 — Insert Context Summarization section header and ~250-line threshold trigger
- [x] P2-2.3 — Insert 4-step summarization procedure (summarize completed-stage findings, move to insights.md, retain active findings only, preserve finding IDs)
- [x] P2-2.4 — Verify Memory Usage Rules and Artifact Index sections are untouched

### P2 Task 3 — Agent Context Scoping

- [x] P2-3.1 — Identify insertion point — after Agent Selection — Routing Guide, before Canonical Multi-Agent Workflow
- [x] P2-3.2 — Insert Agent Context Scope Table (5 rows: Test Architect, QA Manager, Project Manager, Client Evaluator, Tooling Recommender — each with Required Context column)
- [x] P2-3.3 — Insert rule: "Agents must not load unrelated memory files — load only what is listed in the scope table"
- [x] P2-3.4 — Verify Routing Guide and Workflow sections are untouched

### P2 Task 4 — Executor Ownership for Stages 0–3

- [x] P2-4.1 — Identify insertion point — within Canonical Multi-Agent Workflow, before Stage 0
- [x] P2-4.2 — Insert System Stage Executors block: Stage 0 → Conductor, Stage 1 → Conductor (using Evidence Extraction skill logic), Stage 2 → Conductor, Stage 3 → Conductor
- [x] P2-4.3 — Insert rule: "Agents begin execution at Stage 4. Stages 0–3 are conductor-managed."
- [x] P2-4.4 — Verify Stage 0–3 definitions are not modified, only executor ownership added

### P2 Task 5 — Capability Coverage Map (Reference File)

- [x] P2-5.1 — Create `.claude/references/qe-capability-map.md`
- [x] P2-5.2 — Add Strategy section (test strategy, quality governance, metrics framework)
- [x] P2-5.3 — Add Shift Left section (requirement validation, API testing, contract testing)
- [x] P2-5.4 — Add Automation section (UI automation, API automation, test pyramid)
- [x] P2-5.5 — Add CI/CD Integration section (pipeline test execution, QA quality gates, pipeline validation)
- [x] P2-5.6 — Add Test Data section (masking, synthetic data, provisioning)
- [x] P2-5.7 — Add Environment Strategy section (service virtualization, ephemeral environments)
- [x] P2-5.8 — Add Observability section (telemetry validation, production monitoring)
- [x] P2-5.9 — Add Non-Functional Testing section (performance, security, accessibility)

### P2 Task 6 — Capability Coverage Stage (Stage 3.5)

- [x] P2-6.1 — Identify insertion point — within Canonical Multi-Agent Workflow, between Stage 3 (Gap Coverage) and Stage 4 (Solution Design)
- [x] P2-6.2 — Insert Stage 3.5 — Capability Coverage Check (Purpose, Action, Checkpoint, Output)
- [x] P2-6.3 — Define output format: Capability / Status / Recommendation table
- [x] P2-6.4 — Update Review Checkpoints table — add row for Stage 3.5
- [x] P2-6.5 — Verify Stage 3 and Stage 4 definitions are unchanged

### P2 Task 7 — Evidence Traceability Requirement

- [x] P2-7.1 — Identify insertion point — under Governance Layer, after Evidence Reconciliation subsection
- [x] P2-7.2 — Insert Evidence Traceability rule: outputs must reference Finding IDs when addressing extracted evidence
- [x] P2-7.3 — Insert example format showing Finding ID → Resolution → Resolution Reference linkage
- [x] P2-7.4 — Verify Evidence Reconciliation subsection is untouched

### P2 Task 8 — Medium Confidence Handling

- [x] P2-8.1 — Identify insertion point — under Governance Layer, after Gap Coverage Enforcement subsection
- [x] P2-8.2 — Insert Medium-Confidence Findings rule: must appear in a section titled "Unresolved or Unverified Findings"
- [x] P2-8.3 — Insert clarification: do not require full reconciliation but must remain visible in output
- [x] P2-8.4 — Verify Gap Coverage Enforcement subsection is untouched

### P2 Task 9 — Gap Coverage Storage

- [x] P2-9.1 — Identify insertion point — within Stage 3 (Gap Coverage Enforcement) definition in workflow
- [x] P2-9.2 — Add storage rule: gap coverage report written to `memory.md` under heading `## Gap Coverage`
- [x] P2-9.3 — Define storage structure: Finding ID / Status / Resolution table
- [x] P2-9.4 — Verify Stage 3 checkpoint and purpose are unchanged

### P2 Task 10 — Improvement Backlog Limit

- [x] P2-10.1 — Identify insertion point — within Continuous Learning & Feedback Loop section, after improvements.md Schema
- [x] P2-10.2 — Insert backlog governance rule: maximum 10 active proposals
- [x] P2-10.3 — Insert archival rule: resolved/rejected proposals must be moved to an archive section within improvements.md
- [x] P2-10.4 — Add Priority field to improvements.md schema (alongside existing: Observation, Root Cause, Suggested Change, Impact, Status)
- [x] P2-10.5 — Verify existing improvements.md schema fields are preserved

### Phase 2 — Implementation Order

| Order | Task | Depends On | Files Modified |
|---|---|---|---|
| 1 | P2 Task 1: Memory Integrity | None | `.claude/AGENTS.md` |
| 2 | P2 Task 2: Context Summarization | None | `.claude/AGENTS.md` |
| 3 | P2 Task 3: Agent Context Scoping | None | `.claude/AGENTS.md` |
| 4 | P2 Task 4: Executor Ownership | None | `.claude/AGENTS.md` |
| 5 | P2 Task 5: Capability Coverage Map | None | `.claude/references/qe-capability-map.md` (new) |
| 6 | P2 Task 6: Capability Coverage Stage | P2 Task 5 | `.claude/AGENTS.md` |
| 7 | P2 Task 7: Evidence Traceability | None | `.claude/AGENTS.md` |
| 8 | P2 Task 8: Medium Confidence Handling | None | `.claude/AGENTS.md` |
| 9 | P2 Task 9: Gap Coverage Storage | None | `.claude/AGENTS.md` |
| 10 | P2 Task 10: Improvement Backlog | None | `.claude/AGENTS.md` |

### Phase 2 — Validation Checklist

- [x] All 5 existing agents remain unchanged in Agent Roster
- [x] All 12 skills remain unchanged in Skill Roster (9 original + 3 from Pre-Upgrade)
- [x] Guardrails remain in `copilot-instructions.md` (no duplication)
- [x] Memory Integrity rule exists under Governance Layer
- [x] Context Summarization section exists with ~250-line threshold
- [x] Agent Context Scope table exists after Routing Guide
- [x] Executor ownership defined for Stages 0–3 (all = Conductor)
- [x] `qe-capability-map.md` reference file created with 8 capability areas
- [x] Stage 3.5 (Capability Coverage Check) inserted between Stage 3 and Stage 4
- [x] Review Checkpoints table updated with Stage 3.5 row
- [x] Evidence Traceability rule exists with Finding ID → Resolution format
- [x] Medium-Confidence Findings rule exists under Governance Layer
- [x] Gap Coverage storage location defined (memory.md under `## Gap Coverage`)
- [x] Improvement backlog capped at 10 active proposals with archival rule
- [x] Priority field added to improvements.md schema

### Phase 2 — Summary

| Task | Sub-Tasks | Completed | Status |
|---|---|---|---|
| P2 Task 1 — Memory Integrity | 4 | 4 | Complete |
| P2 Task 2 — Context Summarization | 4 | 4 | Complete |
| P2 Task 3 — Agent Context Scoping | 4 | 4 | Complete |
| P2 Task 4 — Executor Ownership | 4 | 4 | Complete |
| P2 Task 5 — Capability Coverage Map | 9 | 9 | Complete |
| P2 Task 6 — Capability Coverage Stage | 5 | 5 | Complete |
| P2 Task 7 — Evidence Traceability | 4 | 4 | Complete |
| P2 Task 8 — Medium Confidence Handling | 4 | 4 | Complete |
| P2 Task 9 — Gap Coverage Storage | 4 | 4 | Complete |
| P2 Task 10 — Improvement Backlog | 5 | 5 | Complete |
| **Phase 2 Total** | **47** | **47** | **Complete** |

---

## Phase 3 — Optional Question → Capability Mapping Skill

> **Execution order:** This phase executes **after** Phase 2 (Architecture Hardening) completes.  
> **Purpose:** Implement the optional `question-capability-mapping` skill, which interprets RFP questions to determine which QE capabilities the client is evaluating — ensuring solution design addresses evaluation intent, not only literal question wording.  
> **Principles:**
> - Additive only — do not modify existing workflow stage numbering
> - Lightweight and optional — this is a skill invoked conditionally, not a mandatory workflow stage
> - Only the Test Architect agent invokes it
> - Context scope is strictly constrained
> - Must not run if activation conditions are not met

### P3 Task 1 — Create Skill Folder and SKILL.md

- [x] P3-1.1 — Create folder `.claude/skills/question-capability-mapping/`
- [x] P3-1.2 — Create `.claude/skills/question-capability-mapping/SKILL.md` with full skill definition
- [x] P3-1.3 — Verify folder is under `.claude/skills/` (not agents, not references)
- [x] P3-1.4 — Verify file is named `SKILL.md` (not the skill name)

### P3 Task 2 — Skill Purpose and Context Scope

- [x] P3-2.1 — Define skill purpose: interpret RFP questions to identify which capability domains are being evaluated, ensuring responses address evaluation intent
- [x] P3-2.2 — Define context scope (load only): RFP question text, `memory.md`, `.claude/references/qe-capability-map.md`, `notes.md`
- [x] P3-2.3 — Add explicit rule: skill must not load full artifact documents unnecessarily
- [x] P3-2.4 — Add explicit rule: skill must not load `insights.md`, `decisions.md`, `improvements.md`, or agent files

### P3 Task 3 — Activation Conditions (Guardrail)

- [x] P3-3.1 — Define three required activation conditions: (1) RFP questions exist in artifacts, (2) Solution design has not yet started, (3) Capability coverage has already been evaluated
- [x] P3-3.2 — Add HALT rule: if any activation condition is not met, the skill must not run and must state which condition failed
- [x] P3-3.3 — Define how condition (1) is verified: check `artifacts.md` for artifact type containing questions, or check `notes.md` for extracted question inventory
- [x] P3-3.4 — Define how condition (3) is verified: check `memory.md` for a Capability Coverage section or `notes.md` for Stage 3.5 output
- [x] P3-3.5 — Verify activation conditions do not conflict with the Stage 3.5 Capability Coverage Check in AGENTS.md workflow

### P3 Task 4 — Skill Responsibilities

- [x] P3-4.1 — Define responsibility 1: parse each RFP question and identify the capability domains it evaluates
- [x] P3-4.2 — Define responsibility 2: determine the evaluation intent behind each question (what is the client actually assessing?)
- [x] P3-4.3 — Define responsibility 3: map each question to one or more capability domains from `qe-capability-map.md`
- [x] P3-4.4 — Define responsibility 4: identify the evaluation dimension(s) per question (Architecture maturity / Execution scalability / Tooling maturity / Governance discipline)
- [x] P3-4.5 — Define responsibility 5: produce the structured capability mapping output and evaluation dimension statement

### P3 Task 5 — Capability Mapping Output Format

- [x] P3-5.1 — Define mandatory output section header: `### Question Capability Mapping`
- [x] P3-5.2 — Define per-question output format: full question text, then a table with columns: Capability Domain / Capability / Why This Applies
- [x] P3-5.3 — Define evaluation dimension output: freeform label per question (e.g., Architecture maturity, Execution scalability, Tooling maturity, Governance discipline)
- [x] P3-5.4 — Add example output block to SKILL.md showing a complete mapping for one question with table + evaluation dimension
- [x] P3-5.5 — Verify output format is consistent with the column structure used in `qe-capability-map.md`

### P3 Task 6 — Skill Guardrails

- [x] P3-6.1 — Add guardrail: skill must not assume capabilities without traceable reasoning — every mapped capability must cite a phrase or element from the question that supports it
- [x] P3-6.2 — Add guardrail: skill must not infer domain expectations not supported by question wording
- [x] P3-6.3 — Add guardrail: skill must not override or contradict evidence extracted from artifacts in `memory.md`
- [x] P3-6.4 — Add guardrail: if a question cannot be mapped to any capability domain in `qe-capability-map.md`, record it as unmapped and note the reason — do not force a mapping
- [x] P3-6.5 — Verify all four guardrails are explicitly named in the SKILL.md (not implied)

### P3 Task 7 — Memory Integration

- [x] P3-7.1 — Define storage target: mapping results written to `notes.md` under heading `## Question Capability Mapping`
- [x] P3-7.2 — Define storage format: one line per question in shorthand notation `Q[n] → [Domain] + [Domain]` (e.g., `Q1 → Automation Strategy + CI/CD Integration`)
- [x] P3-7.3 — Add rule: if `## Question Capability Mapping` section already exists in `notes.md`, append to it — do not overwrite
- [x] P3-7.4 — Add rule: full structured table is written to `notes.md` below the shorthand index for downstream agent reference
- [x] P3-7.5 — Verify storage rule does not conflict with Memory Integrity Rule added in Phase 2 Task 1

### P3 Task 8 — Handoff Rule

- [x] P3-8.1 — Define handoff: after mapping, execution continues with Stage 4 — Solution Design
- [x] P3-8.2 — Add rule: the Test Architect must consider both Capability Coverage output (Stage 3.5) AND Question Capability Mapping output when designing the solution
- [x] P3-8.3 — Add rule: if Question Capability Mapping reveals a capability domain not surfaced in Stage 3.5, it must be added to the solution scope — not silently ignored
- [x] P3-8.4 — Verify handoff rule does not create a circular dependency with Stage 3.5 or Stage 4 definitions in AGENTS.md

### P3 Task 9 — Register Skill in AGENTS.md Skill Roster

- [x] P3-9.1 — Add `question-capability-mapping` to AGENTS.md Skill Roster table with activation condition: `Optional — when RFP questions exist and capability coverage is complete`
- [x] P3-9.2 — Add skill interaction rule in Skill Interaction Rules table: `question-capability-mapping | Optional skill applied when RFP questions exist; informs Test Architect solution design`
- [x] P3-9.3 — Add activation note in the Canonical Multi-Agent Workflow, between Stage 3.5 and Stage 4: `If RFP questions exist, the Test Architect may invoke Question → Capability Mapping before Solution Design.`
- [x] P3-9.4 — Verify Skill Roster count updates to 13
- [x] P3-9.5 — Verify existing Skill Interaction Rules rows are unchanged

### Phase 3 — Implementation Order

| Order | Task | Depends On | Files Modified |
|---|---|---|---|
| 1 | P3 Task 1: Create Skill Folder + SKILL.md | None | `.claude/skills/question-capability-mapping/SKILL.md` (new) |
| 2 | P3 Task 2: Purpose + Context Scope | P3 Task 1 | SKILL.md |
| 3 | P3 Task 3: Activation Conditions | P3 Task 1 | SKILL.md |
| 4 | P3 Task 4: Skill Responsibilities | P3 Task 1 | SKILL.md |
| 5 | P3 Task 5: Output Format | P3 Task 4 | SKILL.md |
| 6 | P3 Task 6: Guardrails | P3 Task 5 | SKILL.md |
| 7 | P3 Task 7: Memory Integration | P3 Task 6 | SKILL.md |
| 8 | P3 Task 8: Handoff Rule | P3 Task 7 | SKILL.md |
| 9 | P3 Task 9: Register in AGENTS.md | P3 Tasks 1–8 | `.claude/AGENTS.md` |

### Phase 3 — Validation Checklist

- [x] `.claude/skills/question-capability-mapping/SKILL.md` exists
- [x] Skill purpose statement is present and correct
- [x] Context scope defined — only 4 permitted file types
- [x] All three activation conditions are defined with HALT rule
- [x] All five responsibilities are explicitly defined
- [x] Output format includes per-question table + evaluation dimension
- [x] All four guardrails are explicitly named
- [x] Memory integration defined — written to `notes.md ## Question Capability Mapping`
- [x] Handoff rule links to Stage 4 and references both Stage 3.5 + mapping outputs
- [x] `question-capability-mapping` added to Skill Roster (count = 13)
- [x] Skill Interaction Rule added
- [x] Activation note added in workflow between Stage 3.5 and Stage 4

### Phase 3 — Summary

| Task | Sub-Tasks | Completed | Status |
|---|---|---|---|
| P3 Task 1 — Skill Folder + SKILL.md | 4 | 4 | Complete |
| P3 Task 2 — Purpose + Context Scope | 4 | 4 | Complete |
| P3 Task 3 — Activation Conditions | 5 | 5 | Complete |
| P3 Task 4 — Skill Responsibilities | 5 | 5 | Complete |
| P3 Task 5 — Output Format | 5 | 5 | Complete |
| P3 Task 6 — Guardrails | 5 | 5 | Complete |
| P3 Task 7 — Memory Integration | 5 | 5 | Complete |
| P3 Task 8 — Handoff Rule | 4 | 4 | Complete |
| P3 Task 9 — Register in AGENTS.md | 5 | 5 | Complete |
| **Phase 3 Total** | **42** | **42** | **Complete** |

---

## Ongoing — Evidence-First Reasoning Enforcement

> **Execution order:** Begins after Phase 2 completes. Runs continuously across all future workflow executions.  
> **Purpose:** Prevent the QE OS from degrading over time by requiring every major conclusion to trace back to evidence, a capability baseline, or an explicit assumption. Without this rule, agent systems gradually shift from evidence-based reasoning to pattern guessing and inference drift.  
> **Principle:** This is not a one-time implementation. It is a standing enforcement rule that must be embedded in governance, workflow, and skill behaviour.

### EF Task 1 — Define the Evidence-First Reasoning Rule

- [x] EF-1.1 — Define the rule: every major conclusion must trace back to one of three sources — Evidence (Finding ID), Capability Baseline (domain from `qe-capability-map.md`), or Explicit Assumption (declared per `assumption-dependency-management` skill)
- [x] EF-1.2 — Define what constitutes a "major conclusion" for enforcement purposes: any architectural recommendation, capability gap identification, risk rating, or delivery feasibility assessment
- [x] EF-1.3 — Define the rejection rule: if a conclusion cannot be traced to one of the three sources, it must be rejected and the agent must state which source is missing
- [x] EF-1.4 — Define the three degradation patterns this rule prevents: (1) hallucinated assumptions, (2) missing capability gaps, (3) confidence drift

### EF Task 2 — Add Evidence Validation Step to Stage 8

- [x] EF-2.1 — Identify insertion point: within Stage 8 — Governance Validation in AGENTS.md, add a fourth governance action after the existing three (Evidence Reconciliation, HITL check, Proposal Quality Rules)
- [x] EF-2.2 — Add action 4: Evidence Validation — every architectural recommendation in the output must reference at least one of: a Finding ID, a capability domain from `qe-capability-map.md`, or an explicit declared assumption
- [x] EF-2.3 — Define the non-compliance format: recommendations that fail evidence validation must be flagged with a `⚠ EVIDENCE GAP` marker before the output is cleared
- [x] EF-2.4 — Define the `⚠ EVIDENCE GAP` block format:
  ```
  ⚠ EVIDENCE GAP
  Recommendation: [what was recommended]
  Missing Source: Finding ID / Capability Baseline / Explicit Assumption
  Action Required: Provide traceability or reclassify as assumption
  ```
- [x] EF-2.5 — Verify that EF-2.2 does not duplicate or conflict with the existing Evidence Reconciliation action already in Stage 8

### EF Task 3 — Add Evidence-First Rule to AGENTS.md Governance Layer

- [x] EF-3.1 — Add a new governance subsection `### Evidence-First Reasoning Rule` under the Governance Layer in AGENTS.md
- [x] EF-3.2 — State the three permitted reasoning sources: Evidence (sourced Finding ID), Capability Baseline (domain reference), Explicit Assumption (declared)
- [x] EF-3.3 — State the rejection rule with the `⚠ EVIDENCE GAP` marker reference
- [x] EF-3.4 — Add the degradation warning: inference + pattern guessing without evidence leads to hallucinated assumptions, missing capability gaps, and confidence drift
- [x] EF-3.5 — Verify new subsection is placed after Memory Integrity Rule and before the Review Checkpoints section

### EF Task 4 — Define Traceability Format for Recommendations

- [x] EF-4.1 — Define the mandatory recommendation format for Stage 4 (Solution Design) output:
  ```
  Recommendation: [what is being recommended]
  Evidence: F[ID] — [brief description of finding]
  Capability Baseline: [domain name] domain — [brief reason]
  Assumption: [if no finding or baseline applies, declare the assumption explicitly]
  ```
- [x] EF-4.2 — Add rule: at least one of the three sources must be present — recommendations with none are invalid and must not appear in client-facing output
- [x] EF-4.3 — Add rule: when multiple sources apply, list all — traceability is additive, not exclusive
- [x] EF-4.4 — Add example to AGENTS.md showing a complete recommendation block (e.g., Introduce CI/CD QA gates → F14 + CI/CD Integration domain)
- [x] EF-4.5 — Verify format is consistent with Evidence Traceability Rule added in Phase 2 Task 7

### EF Task 5 — Add Review Checkpoint for Evidence-First Compliance

- [x] EF-5.1 — Add a check to the Stage 8 row in the Review Checkpoints table: Blocks If: `Architectural recommendations lack Finding ID, capability baseline, or declared assumption`
- [x] EF-5.2 — Update Stage 9 checkpoint to confirm evidence-first compliance was verified during Stage 8 before output delivery
- [x] EF-5.3 — Verify checkpoint update does not break the existing table formatting in AGENTS.md

### EF Task 6 — Add Evidence-First Rule as Sequencing Constraint

- [x] EF-6.1 — Add rule 7 to the Sequencing Rules section in AGENTS.md: `evidence-first validation always runs during Stage 8 — no architectural recommendation may be delivered without traceable source`
- [x] EF-6.2 — Verify new sequencing rule follows the existing 6 rules and is numbered 7
- [x] EF-6.3 — Verify new rule is consistent with the Stage 8 governance action added in EF Task 2

### EF Task 7 — Continuous Compliance Monitoring (Ongoing Behaviour)

- [x] EF-7.1 — Add a Stage 10 responsibility: after output generation, identify any conclusions delivered in the output that lacked evidence traceability and record them as improvement proposals in `improvements.md`
- [x] EF-7.2 — Define the improvement proposal format for evidence gaps: use existing `improvements.md` schema with Root Cause = "Reasoning without evidence source" and Suggested Change = "Add Finding ID or capability baseline reference"
- [x] EF-7.3 — Add rule: if more than 3 evidence gap proposals accumulate in `improvements.md`, this signals a systemic reasoning quality problem requiring human review before the next engagement
- [x] EF-7.4 — Verify EF-7.1 integrates with the Stage 10 responsibilities already defined in AGENTS.md without modifying existing responsibilities 1–4

### Ongoing — Implementation Order

| Order | Task | Depends On | Files Modified |
|---|---|---|---|
| 1 | EF Task 1: Define the Rule | None | `.claude/AGENTS.md` |
| 2 | EF Task 2: Stage 8 Evidence Validation Step | EF Task 1 | `.claude/AGENTS.md` |
| 3 | EF Task 3: Governance Layer Section | EF Task 1 | `.claude/AGENTS.md` |
| 4 | EF Task 4: Recommendation Traceability Format | EF Tasks 1–3 | `.claude/AGENTS.md` |
| 5 | EF Task 5: Review Checkpoint Update | EF Tasks 2–4 | `.claude/AGENTS.md` |
| 6 | EF Task 6: Sequencing Rule 7 | EF Tasks 2–3 | `.claude/AGENTS.md` |
| 7 | EF Task 7: Continuous Compliance (Stage 10) | EF Tasks 1–6 | `.claude/AGENTS.md` |

### Ongoing — Validation Checklist

- [x] Evidence-First Reasoning Rule defined with three permitted sources
- [x] Definition of "major conclusion" stated
- [x] Rejection rule with `⚠ EVIDENCE GAP` marker defined
- [x] `⚠ EVIDENCE GAP` block format defined
- [x] Stage 8 governance action 4 (Evidence Validation) added
- [x] `### Evidence-First Reasoning Rule` section added to Governance Layer
- [x] Recommendation traceability format defined with example
- [x] Stage 8 Review Checkpoint updated
- [x] Stage 9 checkpoint references evidence-first verification
- [x] Sequencing Rule 7 added
- [x] Stage 10 responsibility for evidence gap monitoring added
- [x] Systemic quality threshold (3 gaps = human review trigger) defined

### Ongoing — Summary

| Task | Sub-Tasks | Completed | Status |
|---|---|---|---|
| EF Task 1 — Define the Rule | 4 | 4 | Complete |
| EF Task 2 — Stage 8 Evidence Validation | 5 | 5 | Complete |
| EF Task 3 — Governance Layer Section | 5 | 5 | Complete |
| EF Task 4 — Recommendation Traceability Format | 5 | 5 | Complete |
| EF Task 5 — Review Checkpoint Update | 3 | 3 | Complete |
| EF Task 6 — Sequencing Rule 7 | 3 | 3 | Complete |
| EF Task 7 — Continuous Compliance Monitoring | 4 | 4 | Complete |
| **Ongoing Total** | **29** | **29** | **Complete** |

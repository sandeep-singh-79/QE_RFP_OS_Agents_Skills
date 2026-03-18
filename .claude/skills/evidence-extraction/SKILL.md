---
name: evidence-extraction
description: Extract structured findings from artifacts and normalize them into the QE OS memory format. Powers Stage 1 — Evidence Extraction in the canonical workflow. Activates when artifacts are available for analysis, when Stage 1 begins, or when the conductor invokes evidence extraction. Writes all findings to claude-memory/memory.md with Finding IDs, confidence levels, and source traceability. Also builds and writes the Technology Inventory (named tools/platforms classified as Confirmed/Present/Legacy) to claude-memory/memory.md. Does not perform orchestration or invoke other agents.
---

# Skill: Evidence Extraction & Normalization

## Purpose

Extract structured findings from artifacts and normalize them into the QE OS memory format.

This skill powers **Stage 1 — Evidence Extraction** in the canonical workflow. It ensures every artifact registered in `claude-memory/artifacts.md` is analyzed, every finding is assigned a traceable ID and confidence level, and all output is written to `claude-memory/memory.md` in a consistent structure that downstream agents and governance stages can rely on.

Without this skill, evidence extraction produces inconsistent output that breaks traceability at Stage 8.

---

## Activation Conditions

This skill activates when **any** of the following are true:

1. Stage 1 of the canonical workflow begins
2. `claude-memory/artifacts.md` contains one or more artifacts with status `Pending Review`
3. The user requests artifact analysis or evidence extraction explicitly
4. The conductor invokes evidence extraction as part of workflow execution

---

## Context Scope

This skill may load **only**:

- `claude-memory/artifacts.md` — to identify artifacts to analyze
- The artifact files referenced in `claude-memory/artifacts.md` — the actual content to extract from
- `claude-memory/memory.md` — to check for existing findings before writing (avoid overwriting)
- `claude-memory/notes.md` — to check for in-progress context from earlier stages
- `.claude/references/domain-regulatory-map.md` — for implicit domain detection and regulatory framework inference (Steps 10 and 12 of Responsibilities)

It must **not** load other memory files (`claude-memory/insights.md`, `claude-memory/decisions.md`, `claude-memory/improvements.md`) unless a specific extraction task requires them. Context must be minimal and purposeful.

---

## Responsibilities

When activated, this skill must:

1. **Read artifacts** — load each artifact listed in `claude-memory/artifacts.md` with status `Pending Review`
1a. Skip artifacts whose status is already "Evidence Extracted" unless explicitly re-run.
2. **Identify artifact types** — classify each as: RFP Document / Clarification / Architecture Diagram / Test Asset / Transcript / KEDB / Other
3. **Extract structured findings** — scan each artifact for requirements, constraints, risks, gaps, and opportunities
4. **Assign Finding IDs** — assign a sequential ID in the format `F[N]` (e.g., F1, F2, F3) to every finding; IDs must be unique and never reused
5. **Assign confidence levels** — rate each finding as High, Medium, or Low based on how clearly it is stated in the source artifact
6. **Detect contradictions** — identify findings that conflict with existing entries in `claude-memory/memory.md`; do not overwrite — record as a conflicting finding
7. **Normalize findings** — apply the standard finding structure (see below) to all extracted findings
8. **Write results to `claude-memory/memory.md`** — append all findings; never overwrite existing content
9. **Detect explicit regulations** — scan artifacts for named regulatory frameworks (e.g., GDPR, PCI DSS, HIPAA, SOC 2, ISO 27001). If found, set `Regulatory Context = Explicit` in `claude-memory/memory.md` and record each regulatory reference as a finding with Evidence Type `Compliance Requirement`.
10. **Detect implicit regulatory domains** — if no explicit regulation is detected, check for domain terms indicating strongly regulated industries (see `.claude/references/domain-regulatory-map.md`). If a regulated domain is confirmed, set `Regulatory Context = Inferred`. Do not override `Explicit` once set.
11. **Record client domain** — when domain terms appear in artifacts (e.g., digital banking platform, card payment processing, patient data platform, energy grid system), record `Client Domain: [Domain]` in `claude-memory/memory.md`. Domain labels must be drawn from artifact content — never inferred without textual evidence.
12. **Apply regulatory framework context** — this step behaves differently depending on whether Stage 0 has already run:

   **Full workflow (Stage 0 completed):** Read `Regulatory Context` from `plan.md` Engagement Details (set at Stage 0). Use the value to tag compliance-related findings during extraction. Do not re-run domain × geography inference — it was completed at Stage 0.

   **Spot-task / Mode 2 (no Stage 0):** If `plan.md` does not exist or has no `Regulatory Context` field, run domain × geography inference independently: after domain (Step 11) and geography signals are extracted, cross-reference the **Domain × Geography → Regulatory Framework Inference** table in `.claude/references/domain-regulatory-map.md`. If a matching combination is found, write inferred frameworks to `claude-memory/memory.md` under `## Regulatory Context (Inferred)` using the format defined in that table. If geography cannot be determined from artifacts, skip inference.

   > **Mode 2 canonical definition:** The full Spot-Task operating mode rules (No-Memory Disclosure, Input Validation Gate, quality gate applicability, and scope declaration requirements) are defined in `.claude/AGENTS.md` — `## Operating Modes — Mode 2`. This step covers only the regulatory inference path for Mode 2. See `AGENTS.md` for the complete governing rules.

   In both paths: do not overwrite `Regulatory Context = Explicit` if already set — add inferred frameworks as supplementary context only.

13. **Build Technology Inventory** — scan all artifacts for named tools, platforms, frameworks, and infrastructure components. Classify each as:
   - `Confirmed` — explicitly stated as currently in use (e.g., "we currently use Katalon for regression testing")
   - `Present` — mentioned in artifacts but usage context is unclear (e.g., tool named in a list without deployment confirmation)
   - `Legacy` — mentioned in a historical context (e.g., "migrated away from Selenium in 2024", "previously used")

   Write results to `claude-memory/memory.md` under `## Technology Inventory` using the format:

   ```md
   ## Technology Inventory
   | Tool / Platform | Classification | Source Reference | Notes |
   |---|---|---|---|
   | [name] | Confirmed / Present / Legacy | [Artifact ID + section] | [usage context or migration note] |
   ```

   **Rules:**
   - A tool may appear in only one classification — if a tool is both currently cited and historically retired, classify as `Legacy` and note the migration.
   - If no tools are mentioned in any artifact, write `## Technology Inventory` with the note: `No tools identified in artifacts — to be confirmed in Phase 0.` Record this as a missing evidence entry under `## Missing Evidence`.
   - Section 3 of the Stage 9 output sources exclusively from this inventory. Stage 9 must not re-extract tools from artifacts.

---

## Finding Structure

All findings written to `claude-memory/memory.md` must follow this structure:

```md
### Finding F[ID]

**Source Artifact:** [Artifact ID + name]
**Extracted:** [timestamp or stage reference]
**Evidence Type:** Gap / Capability / Risk / Constraint / Requirement / Opportunity / Compliance Requirement
**Confidence:** High / Medium / Low
**Binding Status:** Mandatory / Advisory / Unknown

**Description:**
[Clear explanation of the finding as stated in or directly supported by the source artifact.]

**Implication:**
[Impact on QA architecture, delivery planning, or solution design if this finding is not addressed.]
```

**Example — Compliance Requirement finding:**
```md
### Finding F15

**Source Artifact:** A1 — RFP Document
**Extracted:** Stage 1
**Evidence Type:** Compliance Requirement
**Confidence:** High
**Binding Status:** Mandatory

**Description:**
GDPR compliance requirement stated in RFP Section 6.

**Implication:**
Solution must address data protection obligations; output framing may reference GDPR by name.
```

## Value Claim Trace Block (Canonical Schema)

If the Description or Implication of a finding contains a quantified claim (%, $, × times, days, or hours), a Value Claim Trace block is **mandatory**. Write it to the `## Value Claim Traces` section at the bottom of `claude-memory/memory.md` — **not inline with the finding**.

In the finding block itself, add only a reference line:
```md
**Value Claim Trace:** Ref → ## Value Claim Traces — F[ID]
```

In the `## Value Claim Traces` section of `claude-memory/memory.md`, write the full block:
```md
### Value Claim Trace — F[ID]
- Claim: [the stated outcome or improvement benefit]
- Baseline: [current-state measure this claim improves from]
- Formula: [how the improvement figure is calculated]
- Measurement Source: [data source or artifact section that supports this]
- Confidence: High / Medium / Low
```

If a quantified claim is present and this block is absent or incomplete, append the following entry under the `## Missing Evidence` section in `claude-memory/memory.md` (create the section if it does not yet exist — do not repeat the section header for each entry):

```md
### Missing: Value Claim Trace for Finding F[ID]

**Expected Evidence:** Baseline measure, calculation formula, and data source for the quantified claim in F[ID]
**Source Reference:** [Artifact ID + section]
**Implication:** The quantified benefit claim in F[ID] cannot be validated or defended without this trace. It must not appear in client-facing output without this evidence.
```

---

## Confidence Level Guidance

| Level | Meaning |
|---|---|
| High | Explicitly stated in the artifact with clear intent |
| Medium | Implied or partially stated — requires interpretation |
| Low | Inferred from context, not directly stated |

### Binding Status Guidance

| Status | Meaning |
|---|---|
| Mandatory | Requirement is contractually binding — non-compliance is a proposal disqualifier or delivery failure |
| Advisory | Requirement is non-binding — described with language such as "should", "consider", or "where applicable" |
| Unknown | Binding status cannot be determined from artifact language alone — requires client clarification |

**Combined use example — Confidence: High + Binding Status: Advisory:**
```md
### Finding F8

**Source Artifact:** A1 — RFP Document
**Extracted:** Stage 1
**Evidence Type:** Opportunity
**Confidence:** High
**Binding Status:** Advisory

**Description:**
"The vendor should consider the use of BDD frameworks where applicable." (RFP Section 5.2)

**Implication:**
BDD adoption may strengthen the response but is not contractually required. Treat as an enhancement opportunity, not a compliance obligation.
```

---

## RFP Question Extraction

### Rule: Individual Question Extraction

RFP questions must be extracted as **individual findings** — one finding per question. Grouping multiple questions into a single finding is not permitted.

### Mandatory Per-Question Finding Format

Each extracted RFP question must follow this structure:

```md
### Finding F[ID]

**Source Artifact:** [Artifact ID + name], Section [reference]
**Extracted:** Stage 1
**Evidence Type:** Requirement
**Confidence:** High
**Binding Status:** Mandatory

**Description:**
Question — [full question text as stated in the RFP]

**Implication:**
[What capability, approach, or evidence is likely required to answer this question satisfactorily.]
```

**Rationale:** Formally posed questions in an RFP are always High confidence — they are explicit evaluation criteria. Their Binding Status is Mandatory — they require a response as part of the submission.

**Compatibility note:** Individual question extraction ensures each question is available as a discrete finding for the `question-capability-mapping` skill, which maps question wording to underlying capability expectations. Grouped questions cannot be individually mapped.

---

## Missing Evidence Structure

Missing evidence is evidence that is **referenced or implied** by artifacts but not provided. It is not the same as a finding — it does not receive a Finding ID. Instead, it is recorded under a dedicated `## Missing Evidence` heading in `claude-memory/memory.md`.

### Rule: Record All Missing Evidence

If an artifact references something relevant to the solution but not provided (e.g., a pipeline description mentioned but not included, a test inventory referenced but absent), record it as a missing evidence block.

### Missing Evidence Block Format

```md
## Missing Evidence

### Missing: [short label]

**Expected Evidence:** [what should have been provided]
**Source Reference:** [Artifact ID + section where the reference appears]
**Implication:** [what cannot be assessed or validated without this evidence]
```

**Example:**
```md
## Missing Evidence

### Missing: CI/CD Pipeline Description

**Expected Evidence:** Description of the client's CI/CD toolchain and pipeline structure
**Source Reference:** A1 — RFP Document, Section 7.4 (footnote references "current CI/CD toolchain")
**Implication:** CI/CD integration cannot be validated. Stage 4 architecture design for pipeline quality gates will require a declared assumption about CI/CD toolchain type.
```

**Rule:** Missing evidence blocks must **not** be assigned a Finding ID. They are not findings — they are absences. Their purpose is to flag gaps in artifact coverage so downstream agents can treat dependent conclusions as assumptions rather than evidence-based claims.

---

## Contradiction Handling

When a new finding contradicts an existing finding in `claude-memory/memory.md`, the skill must **not** overwrite the original. Instead, append a conflicting finding block immediately after the original:

```md
### ⚠ CONFLICTING FINDING

**Original Finding ID:** F[original ID]
**Source of Conflict:** [Artifact ID + name]
**New Finding:** [what the new artifact states]
**Explanation:** [why this conflicts with the original]
**Resolution Status:** Unresolved — requires human review
```

Conflicting findings must be surfaced at Stage 8 (Governance Validation) by the Evidence Reconciliation skill.

---

## Guardrails

This skill must not:

- Infer facts that are not present in or directly supported by a source artifact
- Overwrite or delete existing findings in `claude-memory/memory.md`
- Modify the artifact files being analyzed
- Assign a Finding ID that already exists in `claude-memory/memory.md`
- Proceed silently past an artifact that cannot be loaded — report the failure

If a finding cannot be classified with confidence above Low, it must still be recorded — omission is worse than a low-confidence finding.

---

## Handoff

After execution, this skill hands off to:

**Stage 2 — Memory Initialization**

The handoff artifact is `claude-memory/memory.md`, which must contain at minimum:
- One entry per extracted finding with a valid Finding ID
- Confidence level on every finding
- Source artifact reference on every finding
- `Client Domain` field (if detectable from artifacts, otherwise omit)
- `Regulatory Context` field set to `Explicit`, `Inferred`, or `Unknown`

**Extraction Completeness Declaration:**
Write the following statement to `claude-memory/memory.md` before handoff. If an `## Extraction Completeness` section already exists (from a prior run), **overwrite it** — do not append a second instance.

```md
## Extraction Completeness

- Artifacts processed: [N]
- Artifacts skipped (Not Applicable or failed to load): [N, with reason if any]
- Findings extracted: [N]
- Value Claim Trace blocks created: [N]
- Missing Evidence entries recorded: [N]
- Extraction status: Complete / Partial (reason: [...])
```

If Extraction status = `Partial`, Stage 2 must flag minimum context as incomplete and note which artifacts were not processed.

Downstream agents (Starting at Stage 4) must not begin analysis until Stage 2 confirms memory readiness.

---

## Failure Handling

If no artifacts are available or all artifacts have status `Not Applicable`:

```
Output: "No artifacts available for evidence extraction. claude-memory/memory.md has not been populated by this skill. Workflow may continue if claude-memory/memory.md contains pre-existing findings from a prior run."
```

The workflow continues — it does not hard-block. However, if `claude-memory/memory.md` is also empty, Stage 2 will flag minimum context unavailable.

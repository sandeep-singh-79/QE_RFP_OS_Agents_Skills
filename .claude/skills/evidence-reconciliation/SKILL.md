---
name: evidence-reconciliation
description: Ensure all findings extracted during evidence extraction are addressed before final outputs are produced. Powers Stage 8 — Governance Validation in the canonical workflow. Activates when solution output is produced and governance validation begins. Checks every finding in claude-memory/memory.md for resolution, surfaces unresolved and conflicting findings, and enforces traceability by requiring Finding ID references on all addressed findings. Does not mark findings resolved without evidence. Does not perform orchestration.
---

# Skill: Evidence Reconciliation Thinking

## Purpose

Ensure all findings extracted during evidence extraction are addressed before final outputs are produced.

This skill powers **Stage 8 — Governance Validation** in the canonical workflow. It acts as the evidence closure gate — verifying that nothing extracted during Stage 1 has been silently dropped between extraction and output. Without this skill, Stage 8 relies entirely on governance rules without structured checking of finding-by-finding resolution status.

---

## Activation Conditions

This skill activates when **any** of the following are true:

1. Solution output has been produced by agent stages (Stages 4–7) and governance validation is beginning
2. Stage 8 — Governance Validation is reached in the canonical workflow
3. The user explicitly requests evidence reconciliation or governance validation

---

## Context Scope

This skill may load **only**:

- `claude-memory/memory.md` — the complete set of extracted findings to reconcile against
- `outputs/staged-proposal.md` — the staged solution output written progressively by Stages 4–7; this is the primary check target. If this file does not exist, raise `⚠ BLOCKING HITL — Stage 8: No staged output found. Stages 4–7 must write their outputs to outputs/staged-proposal.md before Stage 8 can proceed.`
- `claude-memory/notes.md` — specifically the gap report section (`## Gap Coverage`), if present; and Discovery Maturity header line needed for deferral validation

It must not load `claude-memory/insights.md`, `claude-memory/improvements.md`, `claude-memory/decisions.md`, or artifacts unless a specific finding cannot be traced without them. Context must remain minimal.

---

## Responsibilities

When activated, this skill must:

1. **Load all findings from `claude-memory/memory.md`** — retrieve every entry with a Finding ID (F1, F2, ...) regardless of confidence level
2. **Check if each finding is addressed** — review the solution output for explicit or traceable resolution of each finding
3. **Identify unresolved findings** — findings present in `claude-memory/memory.md` with no corresponding resolution in the solution output
4. **Detect conflicting findings** — findings flagged as `⚠ CONFLICTING FINDING` that have not been resolved or acknowledged
5. **Enforce traceability** — all resolutions in the solution output must reference the Finding ID they address

---

## Traceability Rule

Every addressed finding in the solution output must reference its Finding ID. The reference must appear in the output content itself — not only in this reconciliation report.

**Required format:**

```
Resolution: F[ID]
[Description of how this finding is addressed in the solution.]
```

**Example:**

```
Resolution: F14
Introduce CI/CD pipeline QA gates at the build and release stages to address the missing pipeline validation capability.
```

If a finding is addressed but the resolution does not reference the Finding ID, it is treated as **unresolved** until the ID reference is added.

**Disambiguation:** When scanning for resolved findings, match only `Resolution: F[ID]` blocks. `Evidence: F[ID]` citations in recommendation blocks (Stage 4 — Recommendation Traceability Format) are traceability references, not resolution claims. A finding cited via `Evidence:` but not addressed via `Resolution:` remains unresolved.

Multiple findings may reference the same resolution if a single architectural change addresses them.

```
Example:
Resolution: F12, F14, F21
Introduce centralized CI/CD pipeline quality gates covering UI, API, and performance validation.
```

---

## Output Structure

The reconciliation output must always contain four sections. Sections with no items must still appear with an explicit "None" statement.

### Resolved Findings

List all findings from `claude-memory/memory.md` that have a traceable resolution with a Finding ID reference in the solution output.

```
| Finding ID | Description | Resolution Reference |
|---|---|---|
| F[ID] | [Short description] | [Section or quote from solution output] |
```

### Unresolved Findings

List all findings from `claude-memory/memory.md` that have no traceable resolution in the solution output.

```
| Finding ID | Confidence | Description | Action Required |
|---|---|---|---|
| F[ID] | High / Medium / Low | [Short description] | Address in solution or explicitly acknowledge as out of scope |
```

### Conflicting Findings

List all findings flagged as `⚠ CONFLICTING FINDING` in `claude-memory/memory.md` that have not been resolved or acknowledged.

```
| Original Finding ID | Conflicting Source | Resolution Status |
|---|---|---|
| F[ID] | [Artifact name] | Unresolved — requires human review |
```

### Medium-confidence Findings

List all Medium-confidence findings separately. These do not require full reconciliation but must remain visible.

```
| Finding ID | Description | Visibility Status |
|---|---|---|
| F[ID] | [Short description] | Visible — carried forward to "Unresolved or Unverified Findings" section |
```

Medium-confidence findings must appear in a section titled **"Unresolved or Unverified Findings"** in any client-facing output. They must not be silently dropped.

---

## Phased Finding Sets

When findings were extracted in multiple phases (e.g., an initial RFP extraction followed by a vendor questionnaire phase), reconciliation MUST report coverage **per phase**, not only in aggregate.

### Phase Identification

Findings tagged with `Phase:` in `claude-memory/memory.md` belong to a named phase. If no `Phase:` tag exists on a finding, it belongs to the default phase (`Phase: Initial`).

Before running standard reconciliation, identify all distinct phase labels present in `claude-memory/memory.md` and list them:

```
Phases detected: [Phase 1 label], [Phase 2 label], ...
```

### Phase Coverage Summary

After completing the standard reconciliation scan, append a Phase Coverage Summary to the reconciliation output:

```
## Phase Coverage Summary
| Phase | Total Findings | Addressed | Partially Addressed | Not Addressed | Not Required |
|---|---|---|---|---|---|
| [Phase label] | N | N | N | N | N |
```

Each phase must have its own row. A phase with zero findings must not appear.

### Inter-Phase Contradiction Report

After completing the cross-finding consistency check, append an Inter-Phase Contradiction Report if any findings carry a `SUPERSEDED` or `CONTRADICTED` relationship tag:

```
## Inter-Phase Contradictions
| Later Finding | Earlier Finding | Relationship | Resolution |
|---|---|---|---|
| F[new ID] | F[prior ID] | SUPERSEDED / CONTRADICTED | [how the conflict is handled in the output] |
```

If no inter-phase contradictions exist, state: `Inter-Phase Contradictions: None`.

An unresolved `CONTRADICTED` relationship (where neither finding has been acknowledged as superseded) blocks Stage 8 clearance — raise Blocking HITL.

**CONTRADICTED is resolved when any one of the following conditions is met:**
1. One finding is marked `Status: SUPERSEDED — see [new Finding ID]` (the superseding finding becomes the authoritative record)
2. Both findings are re-examined and one is reclassified — e.g., downgraded from HIGH to LOW confidence with documented rationale in `claude-memory/notes.md`. Executor: evidence-reconciliation skill re-examines; Conductor validates and updates the finding record.
3. The conductor explicitly acknowledges the unresolved contradiction and adds it to the proposal as an Open Condition in Appendix B — format: `OC-[n]: Conflicting findings [F-ID-A] and [F-ID-B] on [subject] — both retained; client input required in Phase 0 to determine authoritative position.` **Stage 8 clears on the act of acknowledgement (OC logged), not on Phase 0 confirmation.** The OC carries the contradiction forward as a tracked delivery-phase item; it does not remain a workflow blocker after acknowledgement.

Once any one condition is met, the Blocking HITL may be cleared.

---

## Cross-Finding Consistency Check (Stage 8)

After completing the finding-to-output reconciliation scan, perform a cross-finding consistency check:

1. **Group findings by topic:** Identify findings that address the same domain, capability, or architectural concern (e.g., multiple findings about CI/CD, multiple findings about environment strategy).
2. **Check for contradictions within each group:**
   - Findings that recommend opposite actions (e.g., F12 says "introduce CI/CD gates" while F27 says "CI/CD pipeline is mature — no changes needed")
   - Findings from different agents that assign conflicting risk levels to the same concern
   - Architecture recommendations from Stage 4 that contradict adoption risk findings from Stage 5
3. **Flag contradictions:**
   ```
   ⚠ CROSS-FINDING CONFLICT
   Finding A: F[ID] — [summary]
   Finding B: F[ID] — [summary]
   Conflict: [what they disagree on]
   Resolution Required: [which agent/stage should reconcile]
   ```
4. Any `⚠ CROSS-FINDING CONFLICT` with no resolution blocks Stage 8 clearance — raise Blocking HITL.

---

## Guardrails

This skill must not:

- Mark a finding as **Resolved** without a traceable Finding ID reference in the solution output
- Delete any finding from `claude-memory/memory.md` — findings are append-only
- Ignore Medium-confidence findings — they must appear in the output even if reconciliation is not required
- Treat a conflicting finding as resolved unless a human has explicitly approved the resolution

If a finding ID referenced in the solution output does not exist in `claude-memory/memory.md`, flag it as a **phantom reference** and require correction before output is delivered.

## Deferred to Transition — Validation Gate

**This skill MUST read deferral status from `claude-memory/notes.md` (`## Gap Coverage`) for each Finding ID. Do not assume a `status` field exists in `claude-memory/memory.md` for deferral purposes — the canonical finding schema does not define a deferral status field. Note: evidence-extraction may append relationship-tracking `Status:` annotations (e.g., `Status: SUPERSEDED — see [Finding ID]`) to individual finding blocks when new evidence supersedes or contradicts an existing finding. These are relationship annotations, not deferral status fields, and are valid additions to `claude-memory/memory.md`.**

**Discovery Maturity read:** Before validating any deferred findings, read the `Discovery Maturity:` header line from the `## Gap Coverage` section in `claude-memory/notes.md` (written by the conductor at Stage 3). When Discovery Maturity = `Constrained`, expected gaps are candidates for deferral — but the three required fields are still mandatory and must still be verified. If the `Discovery Maturity:` line is absent from the notes, treat as `Moderate`.

When a finding in `claude-memory/memory.md` has a corresponding entry in `claude-memory/notes.md` under the `## Gap Coverage` section whose status is `Deferred to Transition — Explicitly Declared`, this skill must verify that all three required fields are present before accepting it as resolved:

1. `Discovery Limitation` — what access or evidence was not available pre-award
2. `Pre-award constraint rationale` — why validation was not possible before award
3. `Transition validation deliverable` — what will be produced post-award to close this gap

**If all three fields are declared:** Accept as resolved. List in the Resolved Findings section with status note `Deferred — all required fields declared`.

**If any field is missing:** Do not accept as resolved. Mark with:

```
⚠ INCOMPLETE DEFERRAL
Finding ID: F[ID]
Missing field(s): [Discovery Limitation / Pre-award constraint rationale / Transition validation deliverable]
Action Required: Declare all three fields or reclassify as Unresolved
```

An `⚠ INCOMPLETE DEFERRAL` triggers Governance HITL — the finding is treated as Unresolved until resolved by the human.

---

## Regulatory Validation Check

During reconciliation, also verify regulatory framing correctness:

1. Check the `Regulatory Context` field in `claude-memory/memory.md` (`Explicit`, `Implicit`, or `Unknown`)
2. Check the solution output for any references to named regulations (e.g., GDPR, PCI DSS, HIPAA)
3. If the output references a named regulation **not present in `claude-memory/memory.md`** as a Compliance Requirement finding, flag with:

```
⚠ REGULATORY EVIDENCE GAP
Output references: [regulation name]
Evidence found: None in claude-memory/memory.md Compliance Requirement findings
Regulatory Context in claude-memory/memory.md: [Explicit / Implicit / Unknown]
Action Required: Remove the regulation reference or provide the artifact source that justifies it
```

4. If `Regulatory Context = Unknown` and any regulatory framing appears in the output, flag with `⚠ REGULATORY EVIDENCE GAP`
5. If `Regulatory Context = Implicit` and the output uses a named regulation (not generic phrasing), flag with `⚠ REGULATORY EVIDENCE GAP`

This check does not block Stage 9 if the regulatory context is `Implicit` and generic phrasing is used correctly.

---

## Regulatory Control Mapping Check

This check runs in addition to the Regulatory Validation Check above.

If **any** finding in `claude-memory/memory.md` meets **both** of these conditions:
- Evidence Type = `Compliance Requirement`
- The `Regulatory Context` field in `claude-memory/memory.md` = `Explicit`

...then a **Control Mapping Table** is required before Stage 9 is cleared.

**If the Control Mapping Table is present in the solution output:** Validate that each named regulation or framework in the Compliance Requirement findings has at least one row in the table.

**If the Control Mapping Table is absent:** Flag with:

```
⚠ REGULATORY TRACE GAP
Trigger: [N] Compliance Requirement finding(s) with Regulatory Context = Explicit found in memory.md
Required: Control Mapping Table in solution output
Format required: | Regulation / Framework | Control Objective | Proposal Mechanism | Evidence Source | Gap / Confirmed |
Action Required: Add Control Mapping Table to solution output, or reclassify Regulatory Context as Implicit with rationale
```

An `⚠ REGULATORY TRACE GAP` blocks Stage 9 clearance. Governance HITL is required before output is released.

---

## Handoff

After completion, the workflow proceeds to:

**Stage 9 — Output Generation (Quality Gate)**

The reconciliation report is part of the governance clearance package. Stage 9 (Review & Challenge Thinking quality gate) must have access to this report when evaluating the final output.

If unresolved High-confidence findings remain, a HITL pause is triggered before Stage 9 proceeds.

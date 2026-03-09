---
name: evidence-extraction
description: Extract structured findings from artifacts and normalize them into the QE OS memory format. Powers Stage 1 — Evidence Extraction in the canonical workflow. Activates when artifacts are available for analysis, when Stage 1 begins, or when the conductor invokes evidence extraction. Writes all findings to memory.md with Finding IDs, confidence levels, and source traceability. Does not perform orchestration or invoke other agents.
---

# Skill: Evidence Extraction & Normalization

## Purpose

Extract structured findings from artifacts and normalize them into the QE OS memory format.

This skill powers **Stage 1 — Evidence Extraction** in the canonical workflow. It ensures every artifact registered in `artifacts.md` is analyzed, every finding is assigned a traceable ID and confidence level, and all output is written to `memory.md` in a consistent structure that downstream agents and governance stages can rely on.

Without this skill, evidence extraction produces inconsistent output that breaks traceability at Stage 8.

---

## Activation Conditions

This skill activates when **any** of the following are true:

1. Stage 1 of the canonical workflow begins
2. `artifacts.md` contains one or more artifacts with status `Pending Review`
3. The user requests artifact analysis or evidence extraction explicitly
4. The conductor invokes evidence extraction as part of workflow execution

---

## Context Scope

This skill may load **only**:

- `artifacts.md` — to identify artifacts to analyze
- The artifact files referenced in `artifacts.md` — the actual content to extract from
- `memory.md` — to check for existing findings before writing (avoid overwriting)
- `notes.md` — to check for in-progress context from earlier stages

It must **not** load other memory files (`insights.md`, `decisions.md`, `improvements.md`) unless a specific extraction task requires them. Context must be minimal and purposeful.

---

## Responsibilities

When activated, this skill must:

1. **Read artifacts** — load each artifact listed in `artifacts.md` with status `Pending Review`
1a. Skip artifacts whose status is already "Evidence Extracted" unless explicitly re-run.
2. **Identify artifact types** — classify each as: RFP Document / Clarification / Architecture Diagram / Test Asset / Transcript / KEDB / Other
3. **Extract structured findings** — scan each artifact for requirements, constraints, risks, gaps, and opportunities
4. **Assign Finding IDs** — assign a sequential ID in the format `F[N]` (e.g., F1, F2, F3) to every finding; IDs must be unique and never reused
5. **Assign confidence levels** — rate each finding as High, Medium, or Low based on how clearly it is stated in the source artifact
6. **Detect contradictions** — identify findings that conflict with existing entries in `memory.md`; do not overwrite — record as a conflicting finding
7. **Normalize findings** — apply the standard finding structure (see below) to all extracted findings
8. **Write results to `memory.md`** — append all findings; never overwrite existing content

---

## Finding Structure

All findings written to `memory.md` must follow this structure:

```md
### Finding F[ID]

**Source Artifact:** [Artifact ID + name]
**Extracted:** [timestamp or stage reference]
**Evidence Type:** Gap / Capability / Risk / Constraint / Requirement / Opportunity
**Confidence:** High / Medium / Low

**Description:**
[Clear explanation of the finding as stated in or directly supported by the source artifact.]

**Implication:**
[Impact on QA architecture, delivery planning, or solution design if this finding is not addressed.]
```

### Confidence Level Guidance

| Level | Meaning |
|---|---|
| High | Explicitly stated in the artifact with clear intent |
| Medium | Implied or partially stated — requires interpretation |
| Low | Inferred from context, not directly stated |

---

## Contradiction Handling

When a new finding contradicts an existing finding in `memory.md`, the skill must **not** overwrite the original. Instead, append a conflicting finding block immediately after the original:

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
- Overwrite or delete existing findings in `memory.md`
- Modify the artifact files being analyzed
- Assign a Finding ID that already exists in `memory.md`
- Proceed silently past an artifact that cannot be loaded — report the failure

If a finding cannot be classified with confidence above Low, it must still be recorded — omission is worse than a low-confidence finding.

---

## Handoff

After execution, this skill hands off to:

**Stage 2 — Memory Initialization**

The handoff artifact is `memory.md`, which must contain at minimum:
- One entry per extracted finding with a valid Finding ID
- Confidence level on every finding
- Source artifact reference on every finding

Downstream agents (Starting at Stage 4) must not begin analysis until Stage 2 confirms memory readiness.

---

## Failure Handling

If no artifacts are available or all artifacts have status `Not Applicable`:

```
Output: "No artifacts available for evidence extraction. memory.md has not been populated by this skill. Workflow may continue if memory.md contains pre-existing findings from a prior run."
```

The workflow continues — it does not hard-block. However, if `memory.md` is also empty, Stage 2 will flag minimum context unavailable.

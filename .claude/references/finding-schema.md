# Finding Schema Reference

> **Used by:** `evidence-extraction` skill (Stage 1) for writing findings, and `evidence-reconciliation` skill (Stage 8) for verifying traceability.
> **Do not pre-load.** Load on-demand when producing or validating findings.

This file defines the canonical formats for all structured output written to `claude-memory/memory.md` during evidence extraction and subsequent phases.

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

---

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

## Missing Evidence Block Format

Missing evidence is evidence that is **referenced or implied** by artifacts but not provided. It is not the same as a finding — it does not receive a Finding ID. Record missing evidence under a dedicated `## Missing Evidence` heading in `claude-memory/memory.md`.

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

**Rule:** Missing evidence blocks must **not** be assigned a Finding ID. They are absences, not findings. Their purpose is to flag gaps in artifact coverage so downstream agents treat dependent conclusions as assumptions rather than evidence-based claims.

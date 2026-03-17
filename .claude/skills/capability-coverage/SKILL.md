---
name: capability-coverage
description: Evaluate QE capability coverage by comparing client evidence against a baseline of expected QA engineering capabilities. Powers Stage 3.5 — Capability Coverage Check in the canonical workflow. Activates after Stage 3 Gap Coverage completes. Outputs a Capability / Status / Recommendation table covering nine QE domains. Does not assume capabilities are present without evidence. Does not perform orchestration or invoke other agents.
---

# Skill: Capability Coverage Thinking

## Purpose

Ensure the system evaluates expected QE capabilities even if they are not mentioned in the client's artifacts.

This skill powers **Stage 3.5 — Capability Coverage Check** in the canonical workflow. It acts as a structured gap-filling lens between evidence extraction (what the client said) and solution design (what we recommend). Without this skill, the solution design may address only what was explicitly raised, missing entire capability areas the client has not thought to mention.

---

## Activation Conditions

This skill activates when **any** of the following are true:

1. Stage 3 (Gap Coverage Enforcement) has completed and the workflow reaches Stage 3.5
2. The Test Architect agent begins solution design and capability coverage has not yet been evaluated
3. The user explicitly requests a capability coverage assessment

---

## Context Scope

This skill may load **only**:

- `claude-memory/memory.md` — to compare extracted findings against the capability baseline
- `.claude/references/qe-capability-map.md` — the QE capability baseline reference
- `claude-memory/artifacts.md` — to identify architecture artifacts relevant to a specific capability domain (conditional; only when a domain-specific artifact reference is needed)
- `claude-memory/notes.md` — to check for declared remediation paths during HALT Protocol Step 2 (conditional; loaded only when `Missing` domains are found)
- Architecture artifacts referenced in `claude-memory/artifacts.md` that are directly relevant to a specific capability domain

It must **not** load unnecessary files. If `qe-capability-map.md` does not yet exist, the skill must use the nine capability domains defined in this file as the baseline and note the absence.

---

## Responsibilities

When activated, this skill must:

1. **Load the QE capability baseline** — from `qe-capability-map.md` or from the Capability Domains section below if the file is absent
2. **Compare client evidence against expected capabilities** — review `claude-memory/memory.md` findings against each of the nine capability domains
3. **Identify missing capabilities** — flag any domain with no supporting evidence as `Missing`; flag domains with partial evidence as `Partial`
4. **Recommend improvements** — for each Missing or Partial capability, produce a specific, actionable recommendation

---

## Capability Map Reference

The baseline capability reference file is:

```
.claude/references/qe-capability-map.md
```

If this file does not exist, the skill uses the nine domains defined below as its operating baseline and appends a note to the output:
If qe-capability-map.md exists, its contents override the built-in baseline.
This allows organizations to customize the QE capability model without modifying this skill.

```
Note: qe-capability-map.md not found. Using built-in capability domain baseline.
```

---

## Capability Domains

Evaluate coverage across all nine domains. Every domain must appear in the output — even if the status is Present.

| Domain | Description |
|---|---|
| **QE Strategy** | Test strategy, quality governance model, metrics framework |
| **Shift-left Testing** | Requirement validation, API contract testing, early defect detection |
| **Automation Strategy** | UI automation, API automation, test pyramid alignment |
| **CI/CD Integration** | Pipeline test execution, QA quality gates, pipeline validation |
| **Test Data Management** | Data masking, synthetic data generation, data provisioning |
| **Environment Strategy** | Service virtualization, ephemeral environments, environment parity |
| **Observability** | Telemetry validation, production monitoring, test observability |
| **Non-functional Testing** | Performance, security, accessibility testing coverage |
| **AI-Assisted Quality Engineering** | AI/GenAI test generation, self-healing automation, AI-driven exploratory testing, intelligent defect analysis |

---

## Output Format

The output of this skill must be a structured table for each capability domain:

```
### Capability Coverage Assessment

| Capability | Status | Evidence | Recommendation |
|---|---|---|---|
| QE Strategy | Present / Partial / Missing | [Finding IDs or "None"] | [Recommendation or "No action required"] |
| Shift-left Testing | Present / Partial / Missing | [Finding IDs or "None"] | [Recommendation or "No action required"] |
| Automation Strategy | Present / Partial / Missing | [Finding IDs or "None"] | [Recommendation or "No action required"] |
| CI/CD Integration | Present / Partial / Missing | [Finding IDs or "None"] | [Recommendation or "No action required"] |
| Test Data Management | Present / Partial / Missing | [Finding IDs or "None"] | [Recommendation or "No action required"] |
| Environment Strategy | Present / Partial / Missing | [Finding IDs or "None"] | [Recommendation or "No action required"] |
| Observability | Present / Partial / Missing | [Finding IDs or "None"] | [Recommendation or "No action required"] |
| Non-functional Testing | Present / Partial / Missing | [Finding IDs or "None"] | [Recommendation or "No action required"] |
| AI-Assisted Quality Engineering | Present / Partial / Missing | [Finding IDs or "None"] | [Recommendation or "No action required"] |
```

Example row:

```
| CI/CD Integration | Missing | None | Introduce pipeline quality gate validation at build and release stages. |
```

---

## Status Definitions

| Status | Meaning |
|---|---|
| `Present` | Evidence in `claude-memory/memory.md` clearly confirms this capability is addressed **and all four depth criteria are satisfied** (see Depth Criteria below) |
| `Partial` | Some evidence exists but one or more depth criteria are not satisfied, or coverage is surface-level only |
| `Missing` | No evidence in `claude-memory/memory.md` supports this capability being addressed |

**Classification rule:** A capability may not be classified `Present` on the basis of narrative breadth alone. All four depth criteria must be satisfied before `Present` may be assigned. A finding that mentions a capability area without providing strategy, ownership, metrics, and execution mechanism details must be classified `Partial`.

---

## Depth Criteria

For a capability to be classified `Present`, evidence in `claude-memory/memory.md` must demonstrate all four of the following:

| Criterion | Definition | What "satisfied" looks like |
|---|---|---|
| **Strategy** | A defined approach for how this capability will be delivered | A named methodology, testing approach, or framework is stated |
| **Ownership** | A named role, team, or function is accountable for this capability | Explicit role assignment (e.g., "QA Lead", "Test Architect", "vendor team") |
| **Metrics** | At least one measurable outcome or success criterion is stated | KPI, coverage target, threshold, or quality gate referenced |
| **Execution Mechanism** | A concrete delivery mechanism or tooling approach is described | A process, pipeline integration, framework, or toolset is named |

If only some criteria are satisfied, classify as `Partial` and state which criteria are missing in the Recommendation column.

**Domain-specific depth callouts:**

| Domain | Additional depth requirement |
|---|---|
| **Observability** | Must include telemetry or monitoring integration (not just a statement that observability is important). Production monitoring or test observability tooling must be referenced. |
| **Non-functional Testing** | Must name at least one NFR type in scope (performance, security, accessibility) with a stated approach. A generic "we do NFR testing" statement is insufficient for `Present`. |

---

## Guardrails

This skill must not:

- Assume a capability is `Present` without referencing a specific finding in `claude-memory/memory.md`
- Mark a capability as `Present` based on the skill's own knowledge of the client's industry — only artifact evidence counts
- Omit any of the nine domains from the output, even if status is `Present`
- Propose tooling solutions — this skill identifies coverage gaps, not tools; tooling decisions belong to the Test Architect

---

## HALT Protocol

After producing the capability coverage table, apply the following check before declaring Stage 3.5 complete:

**Step 1 — Identify `Missing` domains.** Collect every row in the output table where Status = `Missing`.

**Step 2 — Check for declared remediation.** For each `Missing` domain, check whether the engagement context (current session, `claude-memory/notes.md`, or explicit user statement) includes one of the following:
- The domain is explicitly declared out of scope for this engagement (with stated reason)
- The domain will be addressed in Stage 4 solution design
- Discovery Maturity = `Constrained` and the gap is acknowledged as expected

**Step 3 — Apply gate.** If any `Missing` domain has no declared remediation matching Step 2:

```
⚠ BLOCKING HITL — Stage 3.5 Capability Gap
Domain(s): [list each Missing domain without declared remediation]
Issue: One or more capability domains have no evidence and no declared remediation path.
Impact: Stage 4 (Solution Design) cannot proceed — the Test Architect would design an architecture
        with no baseline for these domains, producing a structurally incomplete output.
Required: Confirm one of the following for each listed domain before advancing:
  (a) "Out of scope — reason: [state reason]"
  (b) "Will be addressed in Stage 4 solution design"
  (c) "Discovery Maturity = Constrained; deferring to transition"
```

### Minimum Remediation Declaration Requirements

A valid remediation declaration for a `Missing` domain must meet all three of the following criteria:

| Requirement | Description | Minimum Content |
|---|---|---|
| **(a) Remedy action** | What will be done to address the gap | Named action: e.g., "include in Stage 4 architecture", "out of scope — reason: [stated reason]", "accept known gap — deferring to post-award transition" |
| **(b) Target phase** | When the gap will be addressed | A named stage, phase, or explicit deferral: e.g., "Stage 4", "Phase 2 delivery", "post-award transition", "not applicable to this engagement" |
| **(c) Owner** | Who is accountable for the declaration | One of: client, vendor delivery team, out-of-scope (no owner required), or user confirming explicitly |

A declaration that only acknowledges the gap (e.g., "we know this is missing") without specifying the action, target phase, and owner does **not** satisfy the gate.

**What does NOT count as a valid remediation declaration:**
- "We will address this later" — no phase, no action, no owner
- "This is noted" — acknowledgement only; no action specified
- "The client doesn't need this" — no owner, no stated reason for out-of-scope ruling
- A single-word confirmation (e.g., "ok") — no structure; cannot be traced or audited

**Valid examples:**
- ✓ `"Test Data Management — will be addressed in Stage 4 solution design by the Test Architect; target Phase 1 delivery; owner: vendor team"`
- ✓ `"Environment Strategy — out of scope for this engagement; client uses shared environments managed inhouse; confirmed by user"`
- ✓ `"Observability — Discovery Maturity = Constrained; no client evidence available; deferring acknowledgement to post-award transition plan; owner: joint"`

**Stage 3.5 is not complete until every `Missing` domain has a declared remediation or human confirmation.**

This skill must not pass control to Stage 4 while any `Missing` domain is undeclared.

---

## Handoff

After the HALT Protocol is satisfied (all `Missing` domains acknowledged), the workflow proceeds to:

**Stage 4 — Solution Design**

The Test Architect agent uses the capability coverage output alongside the gap coverage report (Stage 3) to ensure the architecture addresses both explicitly raised gaps and coverage-level omissions.

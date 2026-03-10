---
name: capability-coverage
description: Evaluate QE capability coverage by comparing client evidence against a baseline of expected QA engineering capabilities. Powers Stage 3.5 — Capability Coverage Check in the canonical workflow. Activates after Stage 3 Gap Coverage completes. Outputs a Capability / Status / Recommendation table covering eight QE domains. Does not assume capabilities are present without evidence. Does not perform orchestration or invoke other agents.
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

- `memory.md` — to compare extracted findings against the capability baseline
- `.claude/references/qe-capability-map.md` — the QE capability baseline reference
- `artifacts.md` — to identify architecture artifacts relevant to a specific capability domain (conditional; only when a domain-specific artifact reference is needed)
- Architecture artifacts referenced in `artifacts.md` that are directly relevant to a specific capability domain

It must **not** load unnecessary files. If `qe-capability-map.md` does not yet exist, the skill must use the eight capability domains defined in this file as the baseline and note the absence.

---

## Responsibilities

When activated, this skill must:

1. **Load the QE capability baseline** — from `qe-capability-map.md` or from the Capability Domains section below if the file is absent
2. **Compare client evidence against expected capabilities** — review `memory.md` findings against each of the eight capability domains
3. **Identify missing capabilities** — flag any domain with no supporting evidence as `Missing`; flag domains with partial evidence as `Partial`
4. **Recommend improvements** — for each Missing or Partial capability, produce a specific, actionable recommendation

---

## Capability Map Reference

The baseline capability reference file is:

```
.claude/references/qe-capability-map.md
```

If this file does not exist, the skill uses the eight domains defined below as its operating baseline and appends a note to the output:
If qe-capability-map.md exists, its contents override the built-in baseline.
This allows organizations to customize the QE capability model without modifying this skill.

```
Note: qe-capability-map.md not found. Using built-in capability domain baseline.
```

---

## Capability Domains

Evaluate coverage across all eight domains. Every domain must appear in the output — even if the status is Present.

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
```

Example row:

```
| CI/CD Integration | Missing | None | Introduce pipeline quality gate validation at build and release stages. |
```

---

## Status Definitions

| Status | Meaning |
|---|---|
| `Present` | Evidence in `memory.md` clearly confirms this capability is addressed |
| `Partial` | Some evidence exists but coverage is incomplete or surface-level only |
| `Missing` | No evidence in `memory.md` supports this capability being addressed |

---

## Guardrails

This skill must not:

- Assume a capability is `Present` without referencing a specific finding in `memory.md`
- Mark a capability as `Present` based on the skill's own knowledge of the client's industry — only artifact evidence counts
- Omit any of the eight domains from the output, even if status is `Present`
- Propose tooling solutions — this skill identifies coverage gaps, not tools; tooling decisions belong to the Test Architect

---

## Handoff

After completion, the workflow proceeds to:

**Stage 4 — Solution Design**

The Test Architect agent uses the capability coverage output alongside the gap coverage report (Stage 3) to ensure the architecture addresses both explicitly raised gaps and coverage-level omissions.

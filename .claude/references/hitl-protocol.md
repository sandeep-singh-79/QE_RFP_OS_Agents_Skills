# HITL Protocol Reference

> **Used by:** Conductor, all agents. Load when a HITL condition is triggered or when HITL format or trigger taxonomy is needed.
> This is the canonical single source of truth for all HITL types, triggers, and output formats.

---

## HITL Type Taxonomy

| Type | Decision Weight | Action |
|---|---|---|
| **Blocking HITL** | High — no safe forward path without human decision | Halt stage advancement; surface the decision requirement; do not proceed or infer the answer |
| **Advisory HITL** | Medium — system can continue but human review is recommended | Surface with explicit label; record in `claude-memory/notes.md` as an Open Condition; allow workflow to continue |
| **Governance HITL** | High — decision touches a risk category that exceeds agent authority | Pause; state decision and risk category; require explicit human confirmation before proceeding |

---

## Blocking HITL

### When to Raise

Raise a Blocking HITL when **any** of the following conditions are detected:

| Trigger | Stage | Raised by |
|---|---|---|
| No artifact provided at start | Stage 0 | Input Validation Gate |
| `plan.md` Engagement Fields unset or at template defaults | Stage 0 / Stage 9 | Conductor |
| Regulatory Context confidence < 1.0 (Open Condition required) | Stage 0 | Conductor |
| Incumbent Vendor status unconfirmed (Section 15 suppression risk) | Stage 0 | Conductor |
| `Unresolved` High-confidence finding with no acknowledged path | Stage 3 | Conductor |
| `Missing` capability domain with no declared remediation | Stage 3.5 | Capability Coverage skill |
| Stage 8 governance failure — `⚠ INCOMPLETE DEFERRAL`, `⚠ EVIDENCE GAP`, `⚠ REGULATORY TRACE GAP` | Stage 8 | Evidence-reconciliation |
| Conflicting architectural findings unresolvable by evidence alone | Stages 4–7 | Any agent |
| Undefined delivery dependency blocks planning | Stage 6 | Project Manager |
| Contradictory constraints in source artifacts | Any | Any agent |

A Blocking HITL must halt all stage advancement. The system must not assume a default resolution.

### Canonical Format

```
⚠ BLOCKING HITL — [Short condition label]
Stage: [Stage N — Name]
Issue: [one sentence — what condition has not been met or is unresolvable]
Impact: [one sentence — what cannot proceed safely without resolution]
Required Decision: [explicit decision or confirmation needed from the user]
```

**Example:**
```
⚠ BLOCKING HITL — Conflicting findings on change governance constraint
Stage: Stage 6 — Delivery Validation
Issue: F04 (automation sprint 1 start) conflicts with F07 (6-week change governance constraint) — cannot be resolved by evidence alone.
Impact: Stage 6 delivery planning cannot proceed — any timeline produced would be built on an unresolved conflict.
Required Decision: Confirm whether change governance applies to QA tooling. If yes, automation start must be deferred to Week 7 or later.
```

---

## Advisory HITL → Open Condition Recording

When an Advisory HITL is raised, record an Open Condition in `claude-memory/notes.md`:

```
OC-[n] — [Stage N]: [description]. Resolution: [what would close this condition].
```

Reference the OC number in relevant output sections so the Project Manager and Stage 9 can track it.

**Advisory HITL is not a stage blocker.** The workflow continues; the OC is carried forward and resolved when the stated condition is confirmed.

---

## Governance HITL

### When to Raise

Raise a Governance HITL when a decision touches **any** of the following risk categories and the agent cannot confirm from provided inputs that the decision is safe:

| Category | Description | Example |
|---|---|---|
| Business Logic Impact | Decision changes how business rules are interpreted or applied | Recommending a different teller transaction limit structure |
| Compliance Exposure | Decision touches regulatory, audit, or legal territory | Assuming PCI DSS compliance scope without client confirmation |
| Coverage Reduction | Decision reduces test coverage or removes a testing layer | Recommending removal of manual regression in favour of automation-only |
| Behavioral Change | Decision alters user-facing behavior or workflow | Proposing a different approval chain for teller overrides |
| Release Risk | Decision affects release timing, rollback capability, or deployment | Recommending a big-bang cutover vs. phased rollout |
| Data Sensitivity | Decision involves handling of PII, financial data, or credentials | Proposing test data strategies that use production data |
| Traceability Impact | Decision breaks or weakens audit trail or requirement traceability | Removing traceability links between requirements and test cases |

### 5-Step Pause Protocol

When a Governance HITL is triggered:
1. **Pause** — do not proceed with the decision
2. **State the decision** — what is being decided
3. **State the risk category** — which category applies
4. **State what is needed** — what confirmation or approval is required
5. **Wait** — do not assume approval; require explicit human confirmation

### Canonical Format

```
⚠ GOVERNANCE HITL — Decision Requires Human Approval
Decision: [what is being decided]
Risk Category: [which category from the table above]
Why: [why this exceeds the agent's authority to decide unilaterally]
Required: [what confirmation is needed to proceed]
```

### Scope

- Governance HITL applies during Stages 4–8 (agent analysis and governance validation)
- Does not apply to memory operations (Stages 0–3) or system learning (Stage 10)
- User may explicitly waive a Governance HITL for a specific decision — this must be logged in `claude-memory/decisions.md`

---

## Relationship Between HITL Types

| Type | Stops Stage Advancement? | When it Clears |
|---|---|---|
| Blocking HITL | Yes — hard stop | After explicit human decision resolves the named condition |
| Governance HITL | Conditional — Stage 8 specific | After human approval at Stage 8; output may not be released until cleared |
| Advisory HITL | No — workflow continues | After OC is logged; closes when stated condition is confirmed |

**Precedence:** Blocking HITL > Governance HITL > Advisory HITL. If multiple HITL types apply to the same condition, raise the highest-precedence type only.

---

## Contract-Driven HITL Routing

When a decision is governed by a contract in `.claude/references/decision-contracts.md`, the contract's `Risk Level` field determines the default HITL type to raise:

| Risk Level | HITL Type | Behaviour |
|---|---|---|
| High | Blocking HITL | Halt stage advancement; require explicit human decision before proceeding |
| Medium | Advisory HITL | Surface with label; log Open Condition in `claude-memory/notes.md`; workflow continues |
| Low | No HITL required | Execute outcome directly; log decision to `claude-memory/decisions.md` |

**Engagement-level overrides:** The conductor may declare a Risk Level override in `plan.md` under `## Contract Risk Overrides`. Overrides take precedence over the contract default for the duration of that engagement. Downgrades (reducing Risk Level below default) require a stated justification in `plan.md`.

**Mode 2 (Spot-Task):** Contract Risk Level is treated as informational only. It qualifies the output with an appropriate disclosure rather than triggering a blocking gate — no upstream stage completion is required.

**Dependency check:** Before executing a contract outcome, verify any `Depends On:` field requirements are met. If the dependency contract has not yet resolved to the required outcome (e.g., TA-01 has not Approved before TA-04 is invoked), raise a HITL at the current contract's Risk Level before proceeding.

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

**Invalidation cascade check (Mode 1 — conductor):** Before advancing any stage gate, the conductor must check whether any contract currently in `Approved` or `Executed` state has had its `Invalidated By:` condition met since the last checkpoint. If invalidation is required:
1. Mark the contract `Invalidated` in the Decision State Register
2. Cascade automatically to all downstream dependents (e.g., TA-01 → TA-04 → TR-01)
3. Log each cascaded contract individually in the Decision Log — no bulk entries
4. Raise a Blocking HITL before continuing stage advancement

In Mode 2, the owning agent must self-declare any invalidation inline and mark downstream contracts as `[INVALIDATED — cascade from {Contract ID}]`.

**Re-evaluation trigger check:** At each Blocking HITL checkpoint and every stage gate, the conductor (Mode 1) or active agent (Mode 2) must review the `Re-evaluation Trigger:` values for all contracts currently in `Approved` or `Executed` state. Confirm with the user whether any trigger condition has been met since the last recorded outcome. If a trigger has fired, the affected contract must be transitioned to `Invalidated` before the gate clears, with cascade applied.

**State Register freshness:** Before writing any state transition, read the current plan.md State Register from file — never write from a cached or in-memory copy. The conductor is the sole writer of the State Register in Mode 1. In Mode 2, the owning agent must re-read plan.md before writing.

---

## Decision Rollback Protocol

Use this protocol when a previously `Approved` or `Executed` decision must be retracted — due to new evidence, a scope change, or a failed execution outcome — and the system needs to return to a prior valid state.

### When to invoke
Invoke the rollback protocol when:
- A contract is found to have been `Approved` or `Executed` on the basis of information that has since been shown to be incorrect or superseded
- A staged output based on an `Executed` contract is rejected by the user and the contract must be re-evaluated
- An `Executed` contract's downstream effect (e.g., a tooling recommendation, an architecture decision) has been explicitly revoked by the user

**Do not** invoke for routine invalidations triggered by a `Re-evaluation Trigger:` condition — those follow the standard cascade procedure above. Rollback is for deliberate, user-initiated retraction of a prior decision outcome.

### Step 1 — Identify the rollback target
Confirm with the user which contract is being retracted and the specific outcome being revoked. Record the Contract ID, the current State, the current Version number, and the Decision Log entry timestamp that recorded the outcome being rolled back.

### Step 2 — Transition to Invalidated
Transition the target contract to `Invalidated` (increment Version). Add a Decision Log entry with:
- From State: current state (typically `Approved` or `Executed`)
- To State: `Invalidated`
- Version: incremented
- Reason: `Rollback — [brief reason confirmed with user]`

### Step 3 — Apply downstream cascade
Apply the standard invalidation cascade: identify all contracts that depend (directly or transitively) on the rolled-back contract via their `Depends On:` field. Transition each to `Invalidated` or `Created` as appropriate (use `Created` when the dependent contract will need to be re-evaluated from scratch). Add individual Decision Log entries per cascaded contract. Raise a Blocking HITL.

### Step 4 — Identify the rollback target version
Using the Decision Log snapshot blocks (written at each stage `Complete` boundary), identify the most recent snapshot in which the target contract was in a valid prior state (typically `Created` or a prior `Approved`). State the snapshot Stage and date explicitly in the HITL message to the user.

### Step 5 — Confirm recovery path with user
Present the user with:
1. Which contract(s) are now `Invalidated`
2. Which snapshot version represents the rollback target
3. Which downstream work (stages, outputs) may need to be reworked

Do not re-execute any downstream work without explicit user confirmation of the recovery path. Record the confirmed recovery path in the Decision Log as a narrative entry under the target contract.

---

## State Conflict Resolution Protocol

Use this protocol when a concurrent state update is detected — either by the optimistic concurrency check in `conductor.md — ### State Write Procedure`, or when a review of the Decision Log reveals two entries for the same Contract ID with the same or overlapping timestamps and different resulting states.

This is always a HITL operation. No automatic conflict resolution.

### When to invoke
- The State Write Procedure detects a Version mismatch (pre-write Version ≠ initial read Version)
- A developer or agent reviewing the Decision Log finds two entries for the same Contract ID with the same `From State` and `Timestamp` (LINT-L06 violation)
- Any other evidence that two competing state transitions were written without mutual awareness

### Step 1 — Detect
Identify the conflicting Decision Log entries: same Contract ID, same or overlapping timestamp, different `To State` values. Record both entries' full details (Timestamp, From State, To State, Version, Reason, Updated By).

### Step 2 — Surface
Present both entries to the user side by side with:
- Contract ID and Decision name
- Entry A: Timestamp, From→To, Version, Reason, Updated By
- Entry B: Timestamp, From→To, Version, Reason, Updated By
- Current State Register value for this contract

### Step 3 — Resolve
The user selects which entry is canonical. Do not infer or default — explicit selection is required.

### Step 4 — Correct
1. Add a corrective Decision Log entry for the non-canonical entry: `[SUPERSEDED — conflict resolution — canonical entry: [timestamp of canonical entry]]`
2. Update the State Register to reflect the canonical entry's To State and Version
3. If the canonical state is `Invalidated`, apply the standard cascade procedure (see `## Contract-Driven HITL Routing` above) after correction

### Step 5 — Confirm
Re-read `plan.md` and verify:
- The State Register shows the canonical state and correct Version
- The Decision Log contains both original entries plus the corrective `[SUPERSEDED]` entry
- No downstream contract is in a state inconsistent with the resolved canonical state

Only after confirmation may the interrupted write (that triggered the conflict detection) be retried.


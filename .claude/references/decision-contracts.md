# Decision Contracts

> Centralised decision contracts for all agents in the QE RFP Operating System.
> Each contract defines the decision identity (name, owner), governance metadata (risk level, dependencies), execution conditions (trigger, required evidence), outcomes, and context (escalation path, mode applicability) for a named decision.
> Agent files reference this file via the `Decision Contracts →` line in each agent's `## Decision Authority` section.
>
> **Mode note:** Escalation paths marked `— Mode 1 only` are binding gates in full workflow mode. In Mode 2 (Spot-Task), those escalations become scope-limitation disclosures — the agent states what is missing or unresolved and qualifies output accordingly. No upstream agent or stage completion is required before an agent can produce output in Mode 2.
>
> **Risk Level default and override rule:** Each contract carries a default `Risk Level` (High / Medium / Low). This classification drives HITL routing: High → Blocking HITL, Medium → Advisory HITL, Low → no HITL required. The default is set at authoring time.
>
> Engagement-level overrides: The conductor may declare an override in `plan.md` under `## Contract Risk Overrides` when engagement context warrants a different classification. Overrides that reduce Risk Level below the default require a stated justification. Overrides that raise Risk Level above the default require no justification.
>
> **Dependency graph constraints:** The `Depends On:` fields in this file form a directed acyclic graph (DAG). Three rules govern its integrity:
> - **No cycles (LINT-D01):** Every chain must terminate at a `Depends On: None` contract. No contract may appear twice in any traversal.
> - **Upstream outcome required (LINT-D02):** Before a downstream decision executes, the upstream contract's outcome must be recorded. Unresolved upstream outcomes block execution (Mode 1) or trigger a scope-limitation disclosure (Mode 2).
> - **Max depth 3 (LINT-D03):** No dependency chain may exceed 3 levels. A chain requiring depth > 4 is a signal to restructure the decision model.
>
> **Decision lifecycle model:** Every contract transitions through the following states during an engagement. `Escalated` is an optional path — contracts may resolve directly from `Created` to `Approved` or `Rejected` without passing through `Escalated`:
>
> - Direct path: `Created → Approved / Rejected → Executed → Invalidated / Closed`
> - Via HITL/conductor: `Created → Escalated → Approved / Rejected → Executed → Invalidated / Closed`
> - Re-evaluation path: `Rejected → Created` (only permitted reverse transition)
> - Early close: `Executed → Closed`, `Invalidated → Closed` (at engagement teardown)
>
> State definitions and writers:
> - `Created` — contract active; decision not yet made. Writer: system (pre-populated in plan.md template)
> - `Escalated` — raised to HITL or conductor; awaiting resolution. Writer: owning agent (raises the HITL); conductor confirms transition
> - `Approved` — positive outcome recorded; downstream may proceed. Writer: owning agent. Applies to outcomes: `Approve`, `Authorize`, `Recommend`, `Flag`, `Surface`
> - `Rejected` — negative outcome recorded; no downstream action; re-submission resets to `Created`. Writer: owning agent. Applies to outcomes: `Reject`, `Decline`
> - `Executed` — downstream action taken under this approval. Writer: conductor (Mode 1); owning agent (Mode 2)
> - `Invalidated` — approval revoked; downstream must not proceed; re-execution required. Writer: conductor only (Mode 1); owning agent self-declaration (Mode 2)
> - `Closed` — engagement complete; record archived. Writer: conductor at teardown (closes all contracts not already Closed)
>
> Permitted transitions: Created → Escalated / Approved / Rejected. Escalated → Approved / Rejected. Approved → Executed / Invalidated. Rejected → Created (only permitted reverse). Executed → Invalidated / Closed. Invalidated → Created / Closed. Closed is terminal.
>
> Outcome-to-state mapping — all valid `Allowed Outcomes` values and the lifecycle state they produce:
>
> | Allowed Outcome | Lifecycle State Entered |
> |---|---|
> | Approve / Authorize / Recommend / Flag / Surface | `Approved` |
> | Reject / Decline | `Rejected` |
> | Escalate | `Escalated` (awaiting conductor/HITL resolution) |
>
> **Invalidation cascade:** Invalidating a contract automatically invalidates all contracts whose `Depends On:` chain passes through it. Cascade order: TA-01 → TA-04 → TR-01. In Mode 1, the conductor logs each cascade step individually in the Decision Log. In Mode 2, the owning agent self-declares cascade inline and marks downstream contracts as `[INVALIDATED — cascade from {Contract ID}]`.
>
> **Rollback declaration:** Invalidating an Executed decision does not reverse actions already taken. It signals that re-execution is required and that any outputs produced under the prior approval must be treated as provisional until re-approval.
>
> **Concurrent engagement scope:** This file defines schema only — no runtime state is stored here. Runtime state lives in `plan.md` Decision State Register, which is per-engagement and reset at teardown. Contracts are not shared across engagements.
>
> **Mode 2 trigger protocol:** In Mode 2, before actioning any decision, the agent must surface the `Re-evaluation Trigger:` values for all referenced contracts and ask the user to confirm whether any trigger conditions have been met since the last recorded outcome.

---

## Test Architect Contracts

### Contract TA-01: Architecture Readiness Gate

```
Decision:          Architecture Readiness Gate
Owner:             Test Architect
Trigger:           All four architecture assessment areas complete (§1 Layer Completeness,
                   §2 Scalability, §3 Enterprise Integration, §4 Architectural Coherence)
Required Evidence: QE Architect Thinking skill output confirming all layers addressed;
                   §1–§4 assessment results
Risk Level:        High
Depends On:        None
Allowed Outcomes:  Approve / Reject
Escalation Path:   Approve → proceed to tooling validation (Contract TA-04)
                   Reject → raise to conductor — Mode 1 only;
                   in Mode 2, state as scope limitation disclosure
Mode Applicability: Both
Invalidated By:    Client requirements change materially after approval (new integrations,
                   scope expansion, technology pivot); or architecture evidence found
                   incomplete or inaccurate after approval
Re-evaluation Trigger: Any confirmed change to application scope, integration landscape,
                   or technology stack after approval date
```

### Contract TA-02: Scalability Gap Flag

```
Decision:          Scalability Gap Flag
Owner:             Test Architect
Trigger:           Any gap in enterprise scale, growth accommodation, or governance
                   scalability found in §2 Scalability Beyond Pilot
Required Evidence: §2 assessment output identifying the specific scalability gap
Risk Level:        Medium
Depends On:        None
Allowed Outcomes:  Flag
Escalation Path:   Flagged to proposal record — conductor decision on hold/proceed
                   in Mode 1; in Mode 2, state as scope limitation disclosure
Mode Applicability: Both
Invalidated By:    Gap resolved — revised architecture accepted or client confirms
                   scale requirements removed from scope
Re-evaluation Trigger: Client confirms scale requirements have changed; architecture
                   revised to address the original gap
```

### Contract TA-03: Integration Dependency Flag

```
Decision:          Integration Dependency Flag
Owner:             Test Architect
Trigger:           Any unresolved integration dependency with client ecosystems found
                   in §3 Enterprise Integration
Required Evidence: §3 assessment output naming the specific unresolved dependency
Risk Level:        Medium
Depends On:        None
Allowed Outcomes:  Flag
Escalation Path:   Flagged to proposal record — conductor decision on hold/proceed
                   in Mode 1; in Mode 2, state as scope limitation disclosure
Mode Applicability: Both
Invalidated By:    Dependency resolved — client confirms integration feasibility
                   or removes integration from scope
Re-evaluation Trigger: Client confirms integration scope or constraints have changed
                   after the flag was recorded
```

### Contract TA-04: Tooling Validation Authorization

```
Decision:          Tooling Validation Authorization
Owner:             Test Architect
Trigger:           All four architecture assessment areas complete with no Reject outcome
                   and no unresolved critical flags
Required Evidence: Architecture assessment confirming §1–§4 complete and internally coherent
Risk Level:        Low
Depends On:        TA-01 (Approve outcome required)
Allowed Outcomes:  Authorize
Escalation Path:   Routes to Tooling & Technology Recommender — both modes
Mode Applicability: Both
Invalidated By:    TA-01 invalidated (automatic cascade); architecture layers
                   change materially after authorization
Re-evaluation Trigger: TA-01 re-evaluated; architecture changes affecting tooling
                   compatibility confirmed after authorization
```

---

## QA Manager Contracts

### Contract QM-01: Adoption Risk Escalation

```
Decision:          Adoption Risk Escalation
Owner:             QA Manager
Trigger:           Team capability gaps identified in §1 that could delay adoption or
                   reduce quality outcomes
Required Evidence: §1 Adoption Realism and Skill Availability assessment output naming
                   specific gaps
Risk Level:        Medium
Depends On:        None
Allowed Outcomes:  Escalate / Flag
Escalation Path:   Conductor — Mode 1 only;
                   in Mode 2, state as scope limitation disclosure
Mode Applicability: Both
Invalidated By:    Team capability gap resolved — confirmed resource change,
                   accepted training plan, or scope reduced to match capabilities
Re-evaluation Trigger: Team composition changes; delivery scope changes materially;
                   timeline extends beyond original planning horizon
```

### Contract QM-02: Sustainability Escalation

```
Decision:          Sustainability Escalation
Owner:             QA Manager
Trigger:           Operational sustainability concerns in §2 that exceed what the team
                   can reasonably absorb
Required Evidence: §2 Operational Sustainability and Maintenance Burden assessment output
                   naming specific concerns
Risk Level:        Medium
Depends On:        None
Allowed Outcomes:  Escalate / Flag
Escalation Path:   Conductor — Mode 1 only;
                   in Mode 2, state as scope limitation disclosure
Mode Applicability: Both
Invalidated By:    Sustainability concern resolved — operational model change
                   accepted by conductor or scope reduced accordingly
Re-evaluation Trigger: Operational model, team size, or tooling support changes
                   after escalation was recorded
```

### Contract QM-03: Adoption Resistance Flag

```
Decision:          Adoption Resistance Flag
Owner:             QA Manager
Trigger:           Proposed practices in §3 that depend on client-side behaviour changes
                   not within the vendor's control, or that face likely cultural resistance
Required Evidence: §3 Adoption Resistance Risk assessment output naming the specific
                   resistance condition
Risk Level:        Low
Depends On:        None
Allowed Outcomes:  Flag
Escalation Path:   Flagged to proposal record — not a blocking gate in either mode
Mode Applicability: Both
Invalidated By:    Client confirms cultural barrier removed or scope adjusted
                   to eliminate the resistance condition
Re-evaluation Trigger: Client delivery practices or change management commitments
                   confirmed or revised after flag was recorded
```

---

## Client / RFP Evaluator Contracts

### Contract CE-01: Scoring Risk Surface

```
Decision:          Scoring Risk Surface
Owner:             Client / RFP Evaluator
Trigger:           One or more evaluation dimensions show Low confidence in the Decision
                   Readiness Matrix, or findings categorised as Scoring Risk, Credibility
                   Gap, or Defensibility Concern in the Output Format taxonomy
Required Evidence: Decision Readiness Matrix completed; Output Format taxonomy applied
                   to all findings
Risk Level:        Medium
Depends On:        None
Allowed Outcomes:  Surface / Flag
Escalation Path:   Surfaced to proposal team — not a blocking gate; remediation decision
                   belongs to Test Architect (architecture gaps) or Project Manager
                   (delivery gaps)
Mode Applicability: Both
Invalidated By:    Scoring risk remediated — proposal section revised and verified
                   by responsible agent (Test Architect or Project Manager)
Re-evaluation Trigger: Proposal section revised; new RFP questions or evaluation
                   criteria published by client after surface was recorded
```

### Contract CE-02: Red Flag Surface

```
Decision:          Red Flag Surface
Owner:             Client / RFP Evaluator
Trigger:           Finding meets the Red Flag category threshold — non-compliance
                   indicator, omission of mandatory requirement, unrealistic commitment,
                   or contradictory statement
Required Evidence: Output Format finding explicitly labelled Red Flag with the specific
                   triggering text identified
Risk Level:        High
Depends On:        None
Allowed Outcomes:  Surface
Escalation Path:   Surfaced to proposal team — potential disqualifier or major scoring
                   downgrade; remediation decision belongs to the responsible agent
Mode Applicability: Both
Invalidated By:    Red flag remediated — specific triggering text removed or
                   corrected in the proposal by responsible agent
Re-evaluation Trigger: Proposal revised; client clarification received that changes
                   interpretation of the flagged content
```

---

## Project Manager Contracts

### Contract PM-01: Plan Feasibility Flag

```
Decision:          Plan Feasibility Flag
Owner:             Project Manager
Trigger:           Timelines, sequencing, or resource assumptions identified in §1–§2
                   that cannot be realistically met
Required Evidence: §1 Sequencing & Dependency Mapping + §2 Timeline Realism assessment
                   output naming specific infeasibility
Risk Level:        Medium
Depends On:        None
Allowed Outcomes:  Flag / Escalate
Escalation Path:   Conductor — Mode 1 only;
                   in Mode 2, state as scope limitation disclosure
Mode Applicability: Both
Invalidated By:    Plan revised to resolve feasibility concern — timeline or
                   resource assumptions corrected and accepted by conductor
Re-evaluation Trigger: Delivery scope, timeline, or resource assumptions change
                   after the flag was recorded
```

### Contract PM-02: Client Dependency Escalation

```
Decision:          Client Dependency Escalation
Owner:             Project Manager
Trigger:           Client-controlled dependencies present in the plan but not flagged
                   as client-owned, creating post-award delivery risk
Required Evidence: §1 Sequencing assessment + §4 Risk & Contingency Visibility output
                   naming the dependency and ownership gap
Risk Level:        High
Depends On:        None
Allowed Outcomes:  Escalate / Flag
Escalation Path:   Conductor — Mode 1 only;
                   in Mode 2, state as scope limitation disclosure
Mode Applicability: Both
Invalidated By:    Client dependency formally acknowledged with ownership
                   documented in plan; or dependency removed from scope
Re-evaluation Trigger: Client confirms or revises ownership of dependencies;
                   scope revision affects the dependency list
```

---

## Tooling & Technology Recommender Contracts

### Contract TR-01: Tooling Recommendation Handback

```
Decision:          Tooling Recommendation Handback
Owner:             Tooling & Technology Recommender
Trigger:           Test Architect has provided confirmed capability requirements list and
                   architecture layers; all Invocation Protocol inputs are present
Required Evidence: Confirmed capability requirements from QE Architect Thinking skill;
                   architecture layers defined by Test Architect; client constraints documented
Risk Level:        Low
Depends On:        TA-04 (Authorize outcome required)
Allowed Outcomes:  Recommend
Escalation Path:   Handback summary returned to Test Architect — both modes
Mode Applicability: Both
Invalidated By:    TA-04 invalidated (automatic cascade); capability requirements
                   revised by Test Architect after recommendation made; client
                   technology constraints change materially
Re-evaluation Trigger: Architecture changes affecting tooling compatibility; client
                   confirms new technology constraints or vendor restrictions
```

### Contract TR-02: Scope Protection Decline

```
Decision:          Scope Protection Decline
Owner:             Tooling & Technology Recommender
Trigger:           Request to recommend tools before capability requirements have been
                   defined by the Test Architect
Required Evidence: Absence of confirmed capability requirements list — invocation inputs
                   checked per Invocation Protocol
Risk Level:        Low
Depends On:        None
Allowed Outcomes:  Decline
Escalation Path:   Redirect to Test Architect to complete architecture definition first
                   — both modes
Mode Applicability: Both
Invalidated By:    Capability requirements list confirmed by Test Architect —
                   condition for decline no longer present
Re-evaluation Trigger: Test Architect confirms capability requirements are now defined
```

### Contract TR-03: Capability Clarification Escalation

```
Decision:          Capability Clarification Escalation
Owner:             Tooling & Technology Recommender
Trigger:           Capability requirements are present but too ambiguous to produce
                   credible tool recommendations
Required Evidence: Invocation inputs reviewed — specific ambiguities or gaps in
                   capability definitions identified
Risk Level:        Low
Depends On:        TR-01 attempted
Allowed Outcomes:  Escalate
Escalation Path:   Return to Test Architect with a specific clarification request
                   — both modes; does not block output, qualifies recommendations
                   until clarification is received
Mode Applicability: Both
Invalidated By:    Capability clarification provided by Test Architect —
                   ambiguity fully resolved
Re-evaluation Trigger: Test Architect revises capability definitions or scope
                   after escalation was recorded
```

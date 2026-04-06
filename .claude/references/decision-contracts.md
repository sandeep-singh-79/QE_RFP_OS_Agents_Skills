# Decision Contracts

> Centralised decision contracts for all agents in the QE RFP Operating System.
> Each contract defines the trigger, required evidence, allowed outcomes, escalation path, and mode applicability for a named decision.
> Agent files reference this file via the `Decision Contracts →` line in each agent's `## Decision Authority` section.
>
> **Mode note:** Escalation paths marked `— Mode 1 only` are binding gates in full workflow mode. In Mode 2 (Spot-Task), those escalations become scope-limitation disclosures — the agent states what is missing or unresolved and qualifies output accordingly. No upstream agent or stage completion is required before an agent can produce output in Mode 2.

---

## Test Architect Contracts

### Contract TA-01: Architecture Readiness Gate

```
Decision:          Architecture Readiness Gate
Trigger:           All four architecture assessment areas complete (§1 Layer Completeness,
                   §2 Scalability, §3 Enterprise Integration, §4 Architectural Coherence)
Required Evidence: QE Architect Thinking skill output confirming all layers addressed;
                   §1–§4 assessment results
Allowed Outcomes:  Approve / Reject
Escalation Path:   Approve → proceed to tooling validation (Contract TA-04)
                   Reject → raise to conductor — Mode 1 only;
                   in Mode 2, state as scope limitation disclosure
Mode Applicability: Both
```

### Contract TA-02: Scalability Gap Flag

```
Decision:          Scalability Gap Flag
Trigger:           Any gap in enterprise scale, growth accommodation, or governance
                   scalability found in §2 Scalability Beyond Pilot
Required Evidence: §2 assessment output identifying the specific scalability gap
Allowed Outcomes:  Flag
Escalation Path:   Flagged to proposal record — conductor decision on hold/proceed
                   in Mode 1; in Mode 2, state as scope limitation disclosure
Mode Applicability: Both
```

### Contract TA-03: Integration Dependency Flag

```
Decision:          Integration Dependency Flag
Trigger:           Any unresolved integration dependency with client ecosystems found
                   in §3 Enterprise Integration
Required Evidence: §3 assessment output naming the specific unresolved dependency
Allowed Outcomes:  Flag
Escalation Path:   Flagged to proposal record — conductor decision on hold/proceed
                   in Mode 1; in Mode 2, state as scope limitation disclosure
Mode Applicability: Both
```

### Contract TA-04: Tooling Validation Authorization

```
Decision:          Tooling Validation Authorization
Trigger:           All four architecture assessment areas complete with no Reject outcome
                   and no unresolved critical flags
Required Evidence: Architecture assessment confirming §1–§4 complete and internally coherent
Allowed Outcomes:  Authorize
Escalation Path:   Routes to Tooling & Technology Recommender — both modes
Mode Applicability: Both
```

---

## QA Manager Contracts

### Contract QM-01: Adoption Risk Escalation

```
Decision:          Adoption Risk Escalation
Trigger:           Team capability gaps identified in §1 that could delay adoption or
                   reduce quality outcomes
Required Evidence: §1 Adoption Realism and Skill Availability assessment output naming
                   specific gaps
Allowed Outcomes:  Escalate / Flag
Escalation Path:   Conductor — Mode 1 only;
                   in Mode 2, state as scope limitation disclosure
Mode Applicability: Both
```

### Contract QM-02: Sustainability Escalation

```
Decision:          Sustainability Escalation
Trigger:           Operational sustainability concerns in §2 that exceed what the team
                   can reasonably absorb
Required Evidence: §2 Operational Sustainability and Maintenance Burden assessment output
                   naming specific concerns
Allowed Outcomes:  Escalate / Flag
Escalation Path:   Conductor — Mode 1 only;
                   in Mode 2, state as scope limitation disclosure
Mode Applicability: Both
```

### Contract QM-03: Adoption Resistance Flag

```
Decision:          Adoption Resistance Flag
Trigger:           Proposed practices in §3 that depend on client-side behaviour changes
                   not within the vendor's control, or that face likely cultural resistance
Required Evidence: §3 Adoption Resistance Risk assessment output naming the specific
                   resistance condition
Allowed Outcomes:  Flag
Escalation Path:   Flagged to proposal record — not a blocking gate in either mode
Mode Applicability: Both
```

---

## Client / RFP Evaluator Contracts

### Contract CE-01: Scoring Risk Surface

```
Decision:          Scoring Risk Surface
Trigger:           One or more evaluation dimensions show Low confidence in the Decision
                   Readiness Matrix, or findings categorised as Scoring Risk, Credibility
                   Gap, or Defensibility Concern in the Output Format taxonomy
Required Evidence: Decision Readiness Matrix completed; Output Format taxonomy applied
                   to all findings
Allowed Outcomes:  Surface / Flag
Escalation Path:   Surfaced to proposal team — not a blocking gate; remediation decision
                   belongs to Test Architect (architecture gaps) or Project Manager
                   (delivery gaps)
Mode Applicability: Both
```

### Contract CE-02: Red Flag Surface

```
Decision:          Red Flag Surface
Trigger:           Finding meets the Red Flag category threshold — non-compliance
                   indicator, omission of mandatory requirement, unrealistic commitment,
                   or contradictory statement
Required Evidence: Output Format finding explicitly labelled Red Flag with the specific
                   triggering text identified
Allowed Outcomes:  Surface
Escalation Path:   Surfaced to proposal team — potential disqualifier or major scoring
                   downgrade; remediation decision belongs to the responsible agent
Mode Applicability: Both
```

---

## Project Manager Contracts

### Contract PM-01: Plan Feasibility Flag

```
Decision:          Plan Feasibility Flag
Trigger:           Timelines, sequencing, or resource assumptions identified in §1–§2
                   that cannot be realistically met
Required Evidence: §1 Sequencing & Dependency Mapping + §2 Timeline Realism assessment
                   output naming specific infeasibility
Allowed Outcomes:  Flag / Escalate
Escalation Path:   Conductor — Mode 1 only;
                   in Mode 2, state as scope limitation disclosure
Mode Applicability: Both
```

### Contract PM-02: Client Dependency Escalation

```
Decision:          Client Dependency Escalation
Trigger:           Client-controlled dependencies present in the plan but not flagged
                   as client-owned, creating post-award delivery risk
Required Evidence: §1 Sequencing assessment + §4 Risk & Contingency Visibility output
                   naming the dependency and ownership gap
Allowed Outcomes:  Escalate / Flag
Escalation Path:   Conductor — Mode 1 only;
                   in Mode 2, state as scope limitation disclosure
Mode Applicability: Both
```

---

## Tooling & Technology Recommender Contracts

### Contract TR-01: Tooling Recommendation Handback

```
Decision:          Tooling Recommendation Handback
Trigger:           Test Architect has provided confirmed capability requirements list and
                   architecture layers; all Invocation Protocol inputs are present
Required Evidence: Confirmed capability requirements from QE Architect Thinking skill;
                   architecture layers defined by Test Architect; client constraints documented
Allowed Outcomes:  Recommend
Escalation Path:   Handback summary returned to Test Architect — both modes
Mode Applicability: Both
```

### Contract TR-02: Scope Protection Decline

```
Decision:          Scope Protection Decline
Trigger:           Request to recommend tools before capability requirements have been
                   defined by the Test Architect
Required Evidence: Absence of confirmed capability requirements list — invocation inputs
                   checked per Invocation Protocol
Allowed Outcomes:  Decline
Escalation Path:   Redirect to Test Architect to complete architecture definition first
                   — both modes
Mode Applicability: Both
```

### Contract TR-03: Capability Clarification Escalation

```
Decision:          Capability Clarification Escalation
Trigger:           Capability requirements are present but too ambiguous to produce
                   credible tool recommendations
Required Evidence: Invocation inputs reviewed — specific ambiguities or gaps in
                   capability definitions identified
Allowed Outcomes:  Escalate
Escalation Path:   Return to Test Architect with a specific clarification request
                   — both modes; does not block output, qualifies recommendations
                   until clarification is received
Mode Applicability: Both
```

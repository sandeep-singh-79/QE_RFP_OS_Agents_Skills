---
name: assumption-dependency-management
description: Identify, classify, and surface assumptions and dependencies that affect feasibility, timelines, and delivery outcomes in QA proposals, RFP responses, and transformation planning. Use this skill whenever an output needs to declare what it is relying on, when planning realism is being assessed, or when hidden risks need to be made explicit. Trigger on any RFP response section, roadmap, or estimate that contains unverified inputs or client-controlled factors.
---

# Skill: Assumption & Dependency Management

## Purpose
Surface, structure, and qualify the assumptions and dependencies that materially affect feasibility, timelines, and outcomes — so that hidden risks become explicit before they create delivery failures.

Unstated assumptions are the most common source of post-award disputes. Making them explicit upfront is what separates a defensible proposal from a risky one.

---

## Identify Assumptions

Capture assumptions across these areas:
- Scope and coverage boundaries
- Data and environment readiness
- Tooling and access availability
- Stakeholder participation and availability
- Governance and approval workflows

For each assumption, assign both a **Criticality** rating and a **Validation Requirement**:

**Criticality**
- High — if this assumption is wrong, the plan or estimate breaks
- Medium — if wrong, timeline or scope is materially affected
- Low — if wrong, a workaround is available with minimal impact

**Validation Requirement**
- Requires client confirmation before proceeding
- Requires discovery or analysis to resolve
- Can be deferred without blocking progress

---

## Identify Dependencies

Capture dependencies across:
- Upstream systems, teams, or data feeds
- Downstream consumers relying on QA outputs
- Environment availability and readiness
- Approval or governance checkpoints
- Third-party or vendor inputs

Classify every dependency as one of:
- **Gating** — progress cannot continue if this is unmet; flag immediately
- **Sequencing** — determines the order work can proceed; flag in planning
- **Parallel** — can progress concurrently; note but does not block

If a dependency is ambiguous between types, default to the more restrictive classification and note the uncertainty explicitly. This avoids underestimating risk.

**Ambiguous Case Guidance:**
- If unclear whether Gating or Sequencing → Classify as **Gating** and flag: "May be sequencing-only; requires clarification"
- If unclear whether Sequencing or Parallel → Classify as **Sequencing** and flag: "May be parallelizable; requires validation"
- If classification depends on missing information → State: "Classification blocked by [specify missing input]; defaulting to Gating until confirmed"

---

## Assign Control Ownership

Assign every dependency to an owner category — this is what prevents accountability gaps post-award:
- **Client-controlled** — the client must act for this to resolve
- **Vendor-controlled** — the proposing team owns resolution
- **Shared** — joint action required; define who leads

---

## Output Expectations

Produce:
- A clearly listed set of assumptions, each with criticality and validation requirement
- A clearly listed set of dependencies, each with type and control owner
- A highlighted list of any items that must be validated before commitment is safe
- Gating items called out explicitly for reviewer attention

---

### Estimation Traceability Mapping (Conditional)

**Activation:** Produce this output when invoked in the context of an estimation or sizing engagement — i.e., when `estimation-sizing-thinking` or `pert-estimation` is active or has produced output. Silent when invoked outside an estimation context.

For each **High-criticality assumption**, produce a traceability row mapping assumption → affected dependency → risk → directional effort impact:

| Assumption | Dependency | Risk if Invalid | Effort Impact | Confidence |
|---|---|---|---|---|
| [assumption text] | [which dependency is affected] | [what goes wrong if assumption is violated] | [directional % impact, e.g. "+15% regression effort"] | [Evidenced / Inferred / Assumed] |

**Column rules:**
- **Assumption** — exact text from the Identify Assumptions output above
- **Dependency** — the specific dependency affected if the assumption fails; sourced from the Identify Dependencies output
- **Risk if Invalid** — business or delivery consequence; if `outcome-risk-framing` is active in the same workflow, reference its framing; otherwise state the consequence directly
- **Effort Impact** — directional percentage or phase-specific impact (e.g., "+15% regression effort", "+10% framework establishment"); not a precise recalculation — a defensible order-of-magnitude indicator
- **Confidence** — evidence tier for the effort impact estimate per PR-4: `Evidenced` / `Inferred` / `Assumed`

**Coverage rules:**
- All High-criticality assumptions require a traceability row
- Medium-criticality assumptions may include rows if the effort impact is material
- Low-criticality assumptions: no traceability row required
- The mapping extends CCR flags in the Assumptions Block — it does not replace them
- If no High-criticality assumptions exist, state: “No High-criticality assumptions — Estimation Traceability Mapping not required.”

**Cross-reference rule:** All CCR-flagged assumptions with High criticality must have a corresponding traceability row. If a CCR assumption has no row, flag as incomplete: “`[CCR assumption ID]` is High-criticality and CCR-flagged but has no traceability row — effort impact must be declared.”

---

## Explicit Exclusions

Do not:
- Resolve or mitigate identified dependencies
- Assign named individuals as owners
- Estimate effort required to resolve gaps
- Create mitigation plans
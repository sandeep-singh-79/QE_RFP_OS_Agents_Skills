---
name: estimation-sizing-thinking
description: Provide directional, defensible sizing and timelines for QA initiatives by accounting for enablement effort, execution effort, test complexity, scale, ramp-up, and uncertainty. Use this skill for RFP responses, pilot planning, QA transformation roadmaps, and feasibility assessments where estimates must be credible under governance and procurement scrutiny. Always apply when sizing is requested or when a proposal contains timelines or effort assumptions that need to be validated for realism.
---

# Skill: Estimation & Sizing Thinking

## Purpose
Produce directional, defensible sizing for QA initiatives — accounting for enablement effort, execution effort, test complexity, scale, and uncertainty — without creating false delivery commitments.

Estimates that hide complexity or front-load optimism are a primary cause of post-award credibility loss. This skill exists to prevent underestimation and make confidence levels explicit.

> Use this skill to answer: *"Is this estimate realistic once test complexity, ramp-up, scale, and dependency risk are fully considered?"*

---

## Step 1 — Separate Enablement from Execution

Always distinguish these two effort categories. Conflating them is the most common sizing error.

**Enablement Effort** (typically front-loaded):
- Framework and platform setup
- Environment readiness and configuration
- Test data strategy
- Reporting and dashboards
- CI/CD integration
- Team onboarding and standards definition

**Execution Effort** (assumes enablement is complete):
- Test design and scripting
- Execution and maintenance cycles
- Regression creation and upkeep
- Defect validation and support

Never fold enablement into execution estimates — doing so makes the first delivery phase look faster than it is, which damages credibility when reality hits.

---

## Step 2 — Classify Tests by Complexity Before Sizing

Apply the Test Complexity Matrix to all major test groups before calculating any execution effort. Uniform productivity assumptions across test groups will produce estimates that are wrong for the hardest work.

### Test Complexity Matrix

| Complexity Level | Steps      | Verifications | Inputs/Step | Screens  |
|------------------|------------|---------------|-------------|----------|
| Simple           | ≤ 5        | ≤ 5           | ≤ 10        | 1        |
| Medium           | > 5–≤ 10   | > 5–≤ 10      | ≤ 15        | > 1–< 3  |
| Complex          | > 10–≤ 25  | > 10–≤ 25     | ≤ 25        | > 3–< 5  |
| Highly Complex   | > 25–≤ 35  | > 25–≤ 35     | ≤ 30        | ≥ 5      |

**Multiplier Rule:** Any test case exceeding Highly Complex thresholds on one or more dimensions counts as **two standard test cases** — flag these explicitly as high-maintenance risk items.

Sizing must reflect:
- Distribution of cases across complexity levels
- Concentration of highly complex tests, which amplify both initial effort and ongoing maintenance
- Instability risk in high-complexity areas

---

## Step 3 — Account for Ramp-Up

Never assume full productivity from Day 1. Ramp-up is not optional — it is a cost of every QA engagement.

Include:
- Onboarding time
- Domain learning curve specific to the client environment
- Tool and framework familiarization
- Gradual productivity stabilization period

High-complexity test concentration extends ramp-up. State the expected stabilization point explicitly.

---

## Step 4 — Apply Scale and Dependency Adjustments

Adjust estimates for:
- Number of applications, platforms, or integration points in scope
- Complexity variation across systems (pilot scope vs enterprise rollout)
- Parallel team execution and coordination overhead
- Environment availability and data dependency readiness
- Client-controlled inputs that affect timeline

High complexity amplifies dependency risk — unresolved dependencies in complex areas carry disproportionate schedule exposure. Where dependencies are unresolved, explicitly reduce confidence level and state why.

---


## Estimation Guardrails & Exclusions

Follow these principles and exclusions to ensure estimates are defensible and realistic:

- Use ranges, never point estimates — precision implies certainty that does not exist at proposal stage
- Separate near-term (pilot/enablement) and long-term (scaled execution) views
- State confidence levels explicitly with rationale
- Justify deviations using complexity and dependency evidence
- Do not assume uniform test complexity across an estate
- Do not average out or ignore highly complex scenarios
- Do not commit fixed timelines or delivery dates
- Do not present estimates as delivery plans
- Do not create detailed project schedules or assign named resources
- Do not override project governance or replace the Project Manager Agent's planning function

---

## Composable Sub-Skills

When detailed sizing or measurement content is required, invoke the following sub-skills before producing the final estimate output. These skills are composable — they do not perform orchestration or invoke agents.

### `pert-estimation`
**When to invoke:** When test case categorisation by tier and complexity, PERT variance calculation, or project phase effort breakdown is required.
**What it produces:** PERT summary table (tier × complexity × phase), variance ranges (E ± σ), tier-level effort multipliers, and phase effort allocation.
**Rule:** Invoke before producing effort figures — do not estimate test case effort without PERT categorisation when detailed sizing is in scope.

### `kpi-baseline`
**When to invoke:** When KPIs, success metrics, or baseline measurements need to be included in the estimation or proposal output.
**What it produces:** Client-specified KPI targets (from `memory.md`), `⚠ NO CLIENT KPI TARGETS FOUND` flag if absent, sourced industry benchmark KPIs with confidence scores, and pre-project baseline capture.
**Rule:** Always invoke before finalising any estimation output that will contain KPI or quality targets for client submission. Never insert KPI figures without first checking client-specified targets.

---

## Output Structure

Every estimate must include:
1. Enablement vs execution split
2. Complexity distribution summary across test groups (use `pert-estimation` output when detailed sizing is in scope)
3. Key assumptions and unresolved dependencies
4. Confidence qualifier — High / Medium / Low with rationale
5. Flagged high-maintenance or high-risk scenarios
6. Scale caveats where pilot differs from enterprise scope
7. KPI targets and baseline state (use `kpi-baseline` output when metrics are in scope)
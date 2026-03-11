---
name: pert-estimation
description: Provide PERT-based effort estimation for QA initiatives using optimistic/most-likely/pessimistic inputs, test case categorisation by tier and complexity, effort multipliers, and project phase breakdowns. Use as a composable sub-skill invoked by estimation-sizing-thinking when detailed test case sizing or phase-based effort calculation is required. Always declare assumptions; never produce point estimates without a variance range.
---

# Skill: PERT Estimation

## Purpose

Produce defensible, variance-aware effort estimates for QA engagements using PERT (Program Evaluation and Review Technique) — combining test case categorisation by tier and complexity with project phase effort allocation.

This skill is a **composable sub-skill**. It is invoked by `estimation-sizing-thinking` when detailed sizing is required. It does not perform orchestration, invoke agents, or replace the Project Manager agent's delivery planning function.

> Use this skill to answer: *"What is the estimated effort range, across test tiers and project phases, with explicit variance and declared assumptions?"*

---

## Activation Conditions

This skill activates when **any** of the following are true:

1. `estimation-sizing-thinking` requires detailed test case sizing or phase-based effort breakdown
2. The user explicitly requests PERT estimation, effort breakdown by test category, or phase-level sizing
3. A proposal requires defensible effort ranges rather than point estimates

---

## Context Scope

This skill may load **only**:

- `memory.md` — for findings relevant to scope, scale, test complexity, and platform count
- `notes.md` — for any sizing context or scoping decisions from earlier stages
- Artifacts referenced in `artifacts.md` that contain sizing-relevant information (e.g., test inventory, application count, CI/CD pipeline description)

It must **not** load `insights.md`, `decisions.md`, or `improvements.md` unless a specific sizing task requires prior engagement patterns.

---

## PERT Formula

### Expected Effort (E)

$$E = \frac{O + 4M + P}{6}$$

Where:
- **O** = Optimistic estimate (best case — minimal blockers, smooth execution)
- **M** = Most Likely estimate (realistic case based on evidence)
- **P** = Pessimistic estimate (worst case — dependency delays, complexity surprises)

All three values must be declared explicitly. If any value cannot be determined from available evidence, declare it as an assumption with rationale.

### Variance

$$\text{Variance} = \left(\frac{P - O}{6}\right)^2$$

### Standard Deviation

$$\sigma = \frac{P - O}{6}$$

### Estimate Range

Express all final estimates as: **E ± σ** (i.e., E − σ to E + σ)

**Rule:** Never present a point estimate without the accompanying range. Point estimates imply certainty that does not exist at proposal stage.

---

## Test Case Categorisation Tiers

Every engagement must assess all eight tiers. If a tier is out of scope, declare it explicitly — do not silently omit.

| Tier | Description | Typical Complexity Profile |
|---|---|---|
| **Smoke** | Minimal viability checks — system starts, critical paths navigable | Low — predominantly Simple |
| **Sanity** | Targeted checks after build/change — verify core functionality unbroken | Low-Medium — Simple to Medium |
| **Regression** | Broad coverage of existing functionality to catch regressions | Medium — mix of all complexity levels |
| **Functional** | Business rule and use-case validation against requirements | Medium-High — predominantly Medium to Complex |
| **Integration** | Interface-level validation between components, APIs, or third-party systems | High — predominantly Complex to Highly Complex |
| **E2E (End-to-End)** | Full user journey validation across multiple systems | High — mix of Complex and Highly Complex |
| **Performance** | Load, stress, soak, and spike testing against defined thresholds | Specialist — complexity determined by scenario count and data volume |
| **Security** | Vulnerability scanning, penetration testing, authentication/authorisation validation | Specialist — complexity determined by attack surface and compliance scope |

**Out-of-scope declaration format:**
```
Tier: [name] — Out of Scope
Rationale: [why this tier is not in scope for this engagement]
```

---

## Effort Multipliers

Apply per-test-case effort estimates based on tier × complexity level. Values are in person-hours per test case and represent ranges, not fixed points.

| Tier | Simple | Medium | Complex | Highly Complex |
|---|---|---|---|---|
| Smoke | 0.25–0.5h | 0.5–1h | — | — |
| Sanity | 0.5–1h | 1–2h | — | — |
| Regression | 0.5–1h | 1–2h | 2–4h | 4–8h |
| Functional | 1–2h | 2–4h | 4–8h | 8–16h |
| Integration | 2–4h | 4–8h | 8–16h | 16–32h |
| E2E | 4–8h | 8–16h | 16–32h | 32–64h |
| Performance | — | 8–16h/scenario | 16–32h/scenario | — |
| Security | — | Consultant-led (declare separately) | — | — |

**Multiplier rules:**
- Use the lower bound of the range for well-defined, stable requirements
- Use the upper bound for poorly defined, unstable, or integration-heavy scenarios
- Highly Complex test cases (exceeding the `estimation-sizing-thinking` Highly Complex thresholds on one or more dimensions) count as **two standard test cases** for effort planning
- Performance and Security are costed per scenario/scope, not per test case — declare assumptions explicitly

---

## Project Phase Effort Breakdown

Every estimate must include a phase-level breakdown. Phases must appear even if effort is zero — zero phases must be declared with rationale.

| Phase | Description | Typical % of Total Effort | Notes |
|---|---|---|---|
| **Discovery** | Artifact review, scope definition, risk analysis, environment assessment | 5–10% | Front-loaded; longer for Constrained Discovery engagements |
| **Framework Establishment** | Test framework setup, CI/CD integration, test data strategy, reporting configuration | 15–25% | Enablement effort — never fold into execution estimates |
| **Script Development** | Test case design and scripting across all tiers in scope | 40–55% | Largest phase; effort scaled by tier and complexity distribution |
| **Execution & Reporting** | Test execution cycles, defect logging, defect re-test, progress reporting | 15–20% | Includes regression cycles; scales with defect density |
| **Hypercare** | Post-go-live monitoring, critical defect support, knowledge transfer | 5–10% | Often omitted from proposals — declare explicitly if in or out of scope |

**Phase allocation rules:**
- Discovery Maturity = `Constrained`: Discovery phase may be 10–15% due to higher upfront scoping effort
- Discovery Maturity = `Deep`: Discovery phase may compress to 3–5%
- Framework Establishment must always be called out separately — conflating it with Script Development understates the true Phase 1 cost

---

## Output Format

Every PERT estimate output must include all five components:

### 1. Scope Summary
Brief statement of what is in and out of scope for this estimate — tiers, phases, platform/application count.

### 2. Test Case and Effort Summary Table

| Tier | Est. Test Cases | Complexity Split (S/M/C/HC) | O (hrs) | M (hrs) | P (hrs) | E (hrs) | ±σ |
|---|---|---|---|---|---|---|---|
| [Tier name] | [N] | [e.g. 20/50/25/5%] | [O] | [M] | [P] | [E] | [σ] |

### 3. Phase Effort Breakdown

| Phase | Effort (person-days) | % of Total | O | M | P | E | ±σ |
|---|---|---|---|---|---|---|---|
| Discovery | | | | | | | |
| Framework Establishment | | | | | | | |
| Script Development | | | | | | | |
| Execution & Reporting | | | | | | | |
| Hypercare | | | | | | | |
| **Total** | | 100% | | | | | |

### 4. Assumptions Block

List all assumptions that underpin the estimate. Every assumption must be stated — do not allow hidden assumptions to survive in the output.

```
Assumption 1: [what is assumed] — if incorrect: [impact on estimate]
Assumption 2: ...
```

### 5. Confidence Qualifier

| Qualifier | Basis |
|---|---|
| `High` | All three PERT inputs supported by evidence in `memory.md`; scope well-defined |
| `Medium` | One or more inputs estimated rather than evidence-based; scope mostly defined |
| `Low` | Multiple inputs estimated; scope unclear or Constrained Discovery applies |

---

## Guardrails

This skill must not:

- Produce a point estimate without a variance range
- Assume uniform complexity across all test cases in a tier
- Omit the Framework Establishment phase by folding it into Script Development
- Declare a tier out of scope without an explicit rationale statement
- Commit to delivery dates or project timelines — this skill sizes effort, not schedules

---

## Handoff

After completion, this skill returns output to:

**`estimation-sizing-thinking` skill** — for integration into the full estimation output package, which adds enablement/execution split, scale adjustments, and confidence framing before the estimate is delivered.

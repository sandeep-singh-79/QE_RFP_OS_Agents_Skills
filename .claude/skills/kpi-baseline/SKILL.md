---
name: kpi-baseline
description: Extract client-specified KPI targets from RFP artifacts, flag their absence when not found, and recommend sourced industry benchmark KPIs with confidence scores when client targets are unavailable. Capture pre-project baseline state. Use as a composable sub-skill invoked by estimation-sizing-thinking when KPIs, success metrics, or baseline establishment are in scope. Never recommend industry defaults without first checking for client-specified targets.
---

# Skill: KPI & Baseline Thinking

## Purpose

Ensure that KPIs, success metrics, and baseline measurements in QA proposals are grounded in either client-specified targets (extracted from RFP artifacts) or sourced, confidence-scored industry benchmarks — never inserted without evidence or client validation.

This skill is a **composable sub-skill**. It is invoked by `estimation-sizing-thinking` when KPIs and metrics are in scope. It does not perform orchestration, invoke agents, or design QA architecture.

> Use this skill to answer: *"What KPI targets has the client specified, and where they haven't — what industry-sourced benchmarks should we recommend with explicit confidence?"*

---

## Activation Conditions

This skill activates when **any** of the following are true:

1. `estimation-sizing-thinking` requires KPI or metrics content for a proposal or estimation output
2. The user explicitly requests KPI recommendations, success metric definitions, or baseline setting
3. A proposal section requires measurable outcomes or quality targets

---

## Context Scope

This skill may load **only**:

- `claude-memory/memory.md` — to scan for RFP-extracted findings containing KPI targets, quality thresholds, or success criteria
- `claude-memory/notes.md` — for any prior scoping or measurement decisions
- `claude-memory/artifacts.md` — to identify which artifacts may contain KPI or measurement requirements

It must **not** load `claude-memory/insights.md`, `claude-memory/decisions.md`, or `claude-memory/improvements.md` unless a specific KPI task requires prior engagement patterns.

---

## Responsibilities

### Step 1 — Scan for Client-Specified KPI Targets

Before recommending any KPI, scan `claude-memory/memory.md` for findings with any of the following properties:
- Evidence Type = `Requirement` or `Constraint`
- Description contains terms: target, threshold, coverage, rate, percentage, SLA, benchmark, metric, KPI, quality gate, acceptance criterion

**If client KPI targets are found:** Use them as the primary targets. List them explicitly with their Finding IDs. Do not replace client targets with industry benchmarks.

**If client KPI targets are not found:** Proceed to Step 2 — but flag their absence before doing so.

### Step 2 — Flag Absence of Client KPI Targets

If Step 1 finds no client-specified KPI targets, output the following flag **before** any benchmark recommendations:

```
⚠ NO CLIENT KPI TARGETS FOUND
Scan of claude-memory/memory.md found no client-specified KPI targets, thresholds, or quality metrics in the RFP artifacts.
Action: Industry benchmark KPIs applied below. Recommend confirming KPI targets with the client before finalising proposal commitments.
```

This flag must appear in the output and must not be suppressed or moved after the benchmark recommendations.

### Step 3 — Apply Industry Benchmark KPIs

When client targets are absent (or to supplement confirmed client targets with industry context), use the benchmark table below. Declare the source and confidence score for each benchmark used.

### Step 4 — Capture Baseline State

Record the pre-project baseline for each KPI using the Baseline Capture Template. If baseline data is not available, declare it explicitly — do not omit or estimate.

---

## Industry Benchmark KPI Table

| Metric | Industry Benchmark Range | Source | Confidence |
|---|---|---|---|
| **Code Coverage %** | 70–85% for unit tests; 60–75% for integration tests | IEEE Std 829 / ISTQB Advanced Test Analyst syllabus | Medium |
| **Automation Coverage %** | 60–80% of regression suite automated within 12 months of framework establishment | Capgemini World Quality Report 2023 | Medium |
| **Defect Escape Rate** | <5% of defects reaching production that originated in tested scope | ISTQB Glossary; industry practitioner consensus | Low |
| **Cycle Time Reduction** | 20–40% reduction in test cycle duration through automation and shift-left practices | Gartner Research: Agile QA Metrics (2022) | Medium |
| **Test Execution Time Reduction** | 30–60% reduction in regression execution time through automation | Capgemini World Quality Report 2023 | Medium |
| **Defect Detection Effectiveness** | >80% of critical defects detected before UAT | ISTQB Foundation Level syllabus; industry practitioner consensus | Low |
| **Test Case Pass Rate (final cycle)** | >95% pass rate in final execution cycle before release | Industry practitioner consensus | Low |

### Confidence Scoring Model

| Score | Tier | Definition |
|---|---|---|
| `High` | Peer-reviewed or primary standards body | Published in a peer-reviewed journal, IEEE standard, or international testing body standard (ISTQB, ISO/IEC) with direct citation available |
| `Medium` | Recognised industry report | Published in a named industry research report (Gartner, Capgemini, Forrester, IDC) within the last 4 years |
| `Low` | Community convention | Derived from practitioner consensus, vendor white papers, or community sources (e.g., Stack Overflow surveys, blog aggregations). Defensible as directional guidance only. |

**Usage rules:**
- Always declare the source and confidence score when using a benchmark KPI in a proposal
- `Low` confidence benchmarks must be framed as directional guidance, not commitments: *"Industry consensus suggests..."*
- `Medium` confidence benchmarks may be cited by report name but should not be treated as contractual targets
- `High` confidence benchmarks may be presented as established standards

---

## Baseline Capture Template

For each KPI in scope, capture the pre-project baseline state. If data is not available, declare it explicitly with the resolution path.

| KPI | Current Baseline | Data Source | Availability |
|---|---|---|---|
| Code Coverage % | [value or Not Provided] | [source artifact or system] | Confirmed / Not Provided — establish in Discovery |
| Automation Coverage % | [value or Not Provided] | [source artifact or system] | Confirmed / Not Provided — establish in Discovery |
| Defect Escape Rate | [value or Not Provided] | [source artifact or system] | Confirmed / Not Provided — establish in Discovery |
| Cycle Time (avg test cycle duration) | [value or Not Provided] | [source artifact or system] | Confirmed / Not Provided — establish in Discovery |
| Test Execution Time (regression suite) | [value or Not Provided] | [source artifact or system] | Confirmed / Not Provided — establish in Discovery |

**When baseline is Not Provided:**

```
Baseline: Not Provided
Resolution path: Baseline to be established during Discovery phase (Week 1–2). 
Client to provide access to [test management system / CI/CD pipeline metrics / defect tracking tool].
Proposal commitments are relative improvements from confirmed baseline — not absolute targets.
```

Do not use industry benchmarks as proxies for missing baselines. Missing baselines must be declared as assumptions with a resolution path.

---

## Output Format

Every KPI & Baseline output must include all four components:

### 1. Client-Specified KPI Summary
List all client-specified KPI targets found in `claude-memory/memory.md`, each with its Finding ID. If none found, display the `⚠ NO CLIENT KPI TARGETS FOUND` flag.

### 2. KPI Recommendations (with sources and confidence)

| KPI | Target | Basis | Source | Confidence |
|---|---|---|---|---|
| [metric] | [target value or range] | Client-specified (F[ID]) / Industry benchmark | [source name] | [High / Medium / Low] |

### 3. Baseline State

Use the Baseline Capture Template above. Populate all fields. Do not leave fields blank — use "Not Provided" with a resolution path if data is unavailable.

### 4. Assumptions Block

```
KPI Assumption 1: [what is assumed about targets or baseline] — if incorrect: [impact]
KPI Assumption 2: ...
```

---

## Guardrails

This skill must not:

- Insert KPI targets in a proposal without displaying either a client-specified source (Finding ID) or the `⚠ NO CLIENT KPI TARGETS FOUND` flag followed by sourced benchmarks
- Use industry benchmarks without declaring source and confidence score
- Use a missing or unknown baseline as if it were a confirmed value
- Replace `Not Provided` with a guessed or estimated baseline figure
- Commit to KPI targets as contractual obligations — KPIs in proposals are directional targets unless the client has explicitly specified them as binding

---

## Handoff

After completion, this skill returns output to:

**`estimation-sizing-thinking` skill** — for integration into the full estimation and sizing output package, which combines KPI targets with effort estimates, assumptions, and confidence framing before the output is delivered.

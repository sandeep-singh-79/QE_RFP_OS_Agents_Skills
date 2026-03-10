---
name: question-capability-mapping
description: Map RFP questions to QE capability domains and evaluation dimensions — surfacing what the client is actually assessing behind question wording. Optional skill applied between Stage 3.5 and Stage 4. Activates only when all three conditions are met: RFP questions exist in artifacts, Stage 3.5 is complete, Stage 4 has not started. Outputs a per-question capability mapping table with evaluation dimension analysis. Does not write answers, assess coverage, or duplicate Stage 3.5 output.
---

# Question → Capability Mapping Skill

> Skill Version: 1.0
> Phase: 3
> Status: Optional — activated only when RFP questions exist and capability coverage is complete

---

## Purpose

Interpret RFP questions to determine which QE capabilities the client is evaluating.

This skill ensures solution design addresses evaluation intent — not only the literal wording of questions. RFP questions are rarely capability-neutral; they signal what the client evaluator is assessing and how they expect the response to demonstrate QE maturity.

This skill bridges Stage 3.5 (Capability Coverage) and Stage 4 (Solution Design), ensuring the Test Architect understands both what capability gaps exist and what capabilities the client is explicitly probing for.

---

## Context Scope

This skill may load only the following:

| Source | Purpose |
|---|---|
| RFP question text | The questions to be mapped (from the RFP artifact) |
| `memory.md` | Existing findings — to avoid contradicting extracted evidence |
| `.claude/references/qe-capability-map.md` | Capability domain baseline for mapping |
| `notes.md` | Stage 3.5 capability coverage output and working context |
| `artifacts.md` | To verify whether RFP questions exist in registered artifacts (Activation Condition 1) |

**Rule:** This skill must not load full artifact documents, `insights.md`, `decisions.md`, `improvements.md`, or any agent file. Context scope is strictly limited to the five sources above.

---

## Activation Conditions

This skill must only run when all three conditions are true:

1. **RFP questions exist in artifacts** — verified by checking `artifacts.md` for an artifact containing questions, or `notes.md` for an extracted question inventory
2. **Solution design has not yet started** — Stage 4 has not been invoked in the current workflow execution
3. **Capability coverage has already been evaluated** — Stage 3.5 is complete, verified by checking `memory.md` for a Capability Coverage section or `notes.md` for Stage 3.5 output

**HALT rule:** If any condition is not met, the skill must not run. It must state which condition failed and return execution to the conductor.

Format:
```
SKILL HALT — Question → Capability Mapping not activated
Condition failed: [which condition]
Reason: [why the condition is not met]
Action: [return to conductor / wait for Stage 3.5 to complete]
```

---

## Responsibilities

When activated, this skill must:

1. **Parse each RFP question** — read the full question text and identify the subject, scope, and any technical vocabulary used
2. **Identify capability domains** — determine which domains from `qe-capability-map.md` are relevant to each question
3. **Determine evaluation intent** — identify what the client is actually assessing behind the literal wording (e.g., a question about "how do you manage test data" is evaluating Test Data Management — specifically data governance and compliance risk)
4. **Map to evaluation dimensions** — assign each question to one or more evaluation dimensions: Architecture maturity / Execution scalability / Tooling maturity / Governance discipline
5. **Produce structured output** — generate a capability mapping table per question plus an evaluation dimension statement

---

## Output Format

The output must follow this structure exactly. One block per question.

```
### Question Capability Mapping

---

**Q[n]:** [full RFP question text]

| Capability Domain | Capability | Why This Applies |
|---|---|---|
| [domain from qe-capability-map.md] | [specific capability] | [phrase or element in the question that supports this mapping] |

**Evaluation Dimension:** [Architecture maturity / Execution scalability / Tooling maturity / Governance discipline]
```

**Example:**

```
### Question Capability Mapping

---

**Q1:** Describe how your team would integrate automated testing into an existing CI/CD pipeline.

| Capability Domain | Capability | Why This Applies |
|---|---|---|
| CI/CD Integration | Pipeline test execution | Question explicitly references CI/CD pipeline integration |
| CI/CD Integration | QA quality gates | Integration implies enforcement of pass/fail criteria in pipeline |
| Automation Strategy | API automation | Pipeline integration requires service-level test automation |
| Automation Strategy | Test pyramid alignment | Pipeline integration typically requires a defined testing layer model |

**Evaluation Dimension:** Architecture maturity + Execution scalability
```

---

## Guardrails

1. **No unsupported mappings.** Every mapped capability must cite a specific phrase or element from the question that supports it. Capability mappings without textual justification are not permitted.

2. **No inferred domain expectations.** The skill must not assume a client is evaluating a capability that is not supported by the question wording. Inference beyond the text requires a declared assumption.

3. **No artifact override.** This skill must not modify, contradict, or reinterpret evidence already extracted in `memory.md`. Capability mappings are additive context — they do not replace findings.

4. **Unmapped questions must be recorded.** If a question cannot be mapped to any capability domain in `qe-capability-map.md`, record it as unmapped with the reason. Do not force a mapping.

Format for unmapped questions:
```
**Q[n]:** [question text]
**Status:** Unmapped
**Reason:** [why no domain in qe-capability-map.md applies — e.g., question is procedural / contractual / administrative]
```

---

## Memory Integration

Mapping results must be written to `notes.md` under the heading `## Question Capability Mapping`.

**Shorthand index** — write one line per question at the top of the section:
```
Q1 → CI/CD Integration + Automation Strategy
Q2 → Test Data Management + Compliance
Q3 → Observability + Non-functional Testing
```

**Full structured tables** — write the complete per-question output blocks (from the Output Format section) below the shorthand index.

**Append rule:** If `## Question Capability Mapping` already exists in `notes.md`, append new entries — do not overwrite. Preserve existing content.

This prevents repeated analysis and enables the Test Architect to reference mapping results at Stage 4 without re-running the skill.

---

## Handoff

After completing capability mapping, execution continues with **Stage 4 — Solution Design**.

The Test Architect must consider both inputs when designing the solution:

- **Stage 3.5 output** — Capability Coverage table (what gaps exist across the eight domains)
- **Question Capability Mapping output** — which specific capabilities the client is probing by question

If the Question Capability Mapping reveals a capability domain not surfaced in Stage 3.5, it must be added to the solution scope — it must not be silently ignored.

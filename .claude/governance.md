# governance.md — QE OS Governance Rules

This file contains governance enforcement rules for the QE RFP Operating System.

**Load this file:**
- **Always** at Stage 8 (Governance Validation)
- **On-demand** when a Blocking HITL condition arises in Stages 4–7
- **On-demand** when sequencing, conflict resolution, or evidence traceability rules need to be consulted

Governance rules supplement (not replace) the guardrails in `copilot-instructions.md`.

---

## Gap Coverage Enforcement (Stage 3 + Stage 8)
- All High-confidence findings in `claude-memory/memory.md` must be either:
  - **Addressed** in the solution design, or
  - **Explicitly acknowledged** as out of scope with stated rationale
- No known gap may disappear silently between evidence extraction and output generation
- Gap coverage is checked at Stage 3 (before agent analysis) and again at Stage 8 (before output)

### Stage 3 Gap Coverage Enforcement Algorithm

The conductor executes Stage 3 by applying the following classification logic to every finding in `claude-memory/memory.md`:

**Step 1 — Load findings.** Retrieve all entries from `claude-memory/memory.md` with a Finding ID. Separate into High-confidence and Medium/Low-confidence groups.

**Step 2 — Classify each High-confidence finding** using this decision tree:

```
Is this finding addressed in the planned solution output or artifacts?
  → YES: Status = Addressed. Resolution column: brief description of how.
  → NO: Is the finding explicitly acknowledged as out of scope with stated rationale?
      → YES: Status = Out-of-Scope. Resolution column: state the rationale.
      → NO: Is the finding a known pre-award gap that cannot be validated without client access?
          → YES (and Discovery Maturity = Constrained or Moderate):
              Status = Deferred to Transition — Explicitly Declared
              Resolution column MUST include all three required fields (see below).
          → NO or fields missing: Status = Unresolved.
```

**Step 3 — Classify Medium-confidence findings.** Include in the Gap Coverage report. Use the same decision tree. Medium findings do not block Stage 3 closure but must remain visible in outputs.

**Step 4 — Write the Gap Coverage report** to `claude-memory/notes.md` under `## Gap Coverage`. Begin with `Discovery Maturity: [value]` before the table.

**Step 5 — Checkpoint enforcement.** Stage 3 may not advance if any High-confidence finding has status `Unresolved` without a Governance HITL being raised.

## Medium-Confidence Findings (Stage 3 + Stage 8)
Medium-confidence findings do not require full reconciliation but must remain visible in all client-facing outputs. They must not be silently dropped.

- Medium-confidence findings must appear in a dedicated section titled **"Unresolved or Unverified Findings"** in any client-facing output
- Agents must not treat a medium-confidence finding as resolved unless it is explicitly addressed or acknowledged in the solution output
- The Evidence Reconciliation skill enforces medium-confidence visibility at Stage 8

## Evidence Reconciliation (Stage 8)
Before producing final outputs, verify:
- Every High-confidence finding from `claude-memory/memory.md` has a traceable resolution
- Findings that were present in evidence but absent from the solution are flagged
- Unresolved findings are surfaced under *"Unresolved Findings — Decision Required"*
- Cross-finding consistency is verified — contradictory findings from different stages must be flagged and resolved before output generation proceeds

## Evidence Traceability (Stage 8)
All outputs that address extracted findings must reference the corresponding Finding ID. Resolution without a Finding ID reference is not considered traceable.

**Required format in solution output:**
```
Resolution: F[ID]
[Description of how this finding is addressed.]
```

**Enforcement rules:**
- A finding addressed without a Finding ID reference is treated as unresolved until the reference is added
- Finding IDs referenced in the output but absent from `claude-memory/memory.md` are flagged as phantom references
- The Evidence Reconciliation skill checks all resolutions for Finding ID references at Stage 8

### Traceability Format Disambiguation

Two traceability formats reference Finding IDs in different contexts. Both are required — they are not interchangeable:

| Format | Where Used | Purpose |
|---|---|---|
| `Resolution: F[ID]` | Solution output (Stages 4–7 → staged-proposal.md) | Declares that a finding has been addressed in the solution |
| `Evidence: F[ID]` | Architecture recommendations (Stage 4 — Test Architect) | Declares the evidence basis for a recommendation |

The evidence-reconciliation skill (Stage 8) checks the `Resolution: F[ID]` format when scanning for addressed findings. The `Evidence: F[ID]` format in recommendation blocks is not a resolution — it is a traceability citation. A finding cited via `Evidence:` but not addressed via `Resolution:` remains unresolved.

## Proposal Quality Rules
Outputs intended for client submission must:
- Pass the Review & Challenge Thinking quality gate (Stage 9)
- Have all assumptions declared per `copilot-instructions.md` §1
- Have all dependencies surfaced per Assumption & Dependency Management skill
- Have all client-sensitive content labelled per `copilot-instructions.md` §5

## Output Type Classification

Every agent output must declare its output type as a header at the start of the output.

**Permitted output type values:**

| Output Type | Definition |
|---|---|
| `Working Draft` | Internal iteration shared only within the delivery or QA team; not for client submission |
| `Client Facing` | Submitted to a client, presented in a review, or included in any external document |
| `Internal Analysis` | Analytical output for internal use — supports decisions but is not presented directly |

**Output type header format:**
```
Output Type: [Working Draft / Client Facing / Internal Analysis]
```

**Rule:** Output type declaration is a governance-enforced requirement, not optional. An output submitted without an Output Type header is treated as `Client Facing` by default — the conservative classification. The Review & Challenge Thinking skill enforces this default.

## System File Protection
Agents must **never directly modify** system files:
- `.claude/AGENTS.md`
- `.claude/copilot-instructions.md`
- `CLAUDE.md`
- Any file in `.claude/skills/`
- Any file in `.claude/agents/`
- `.claude/settings.json`

Instead, agents record proposed changes in `claude-memory/improvements.md`. System file updates occur **only after explicit human approval**.

## Memory Integrity Rule
Findings written to `claude-memory/memory.md` by one agent must not be modified or deleted by another agent.

- Agents must only **append** new findings — never overwrite or delete existing entries
- If a new finding contradicts an existing finding, record it as a conflicting finding:

```
⚠ CONFLICTING FINDING
- Original Finding ID: F[ID]
- Source: [Artifact or agent that produced the original]
- New Finding: [what the new evidence states]
- Explanation: [why this conflicts]
- Resolution Status: Unresolved — requires human review
```

Conflicting findings are resolved at Stage 8 by the Evidence Reconciliation skill. They must not be silently resolved by the agent that raised them.

## Evidence-First Reasoning Rule
Every major conclusion must trace back to one of three sources:
- **Evidence** — a sourced Finding ID from `claude-memory/memory.md`
- **Capability Baseline** — a named domain from `.claude/references/qe-capability-map.md`
- **Explicit Assumption** — declared per the `assumption-dependency-management` skill

**Major conclusions** subject to this rule include: architectural recommendations, capability gap identifications, risk ratings, and delivery feasibility assessments.

**Rejection rule:** If a conclusion cannot be traced to one of the three sources, it must be rejected. The agent must state which source is missing and flag the conclusion with `⚠ EVIDENCE GAP`.

**Why this rule exists:** Without it, agent systems gradually shift from evidence-based reasoning to inference and pattern guessing — producing hallucinated assumptions, missing capability gaps, and confidence drift that degrades output quality over time.

**`⚠ EVIDENCE GAP` format:**
```
⚠ EVIDENCE GAP
Recommendation: [what was recommended]
Missing Source: Finding ID / Capability Baseline / Explicit Assumption
Action Required: Provide traceability or reclassify as assumption
```

## Regulatory Context Consistency Check
Regulatory framing in outputs must align with the `Regulatory Context` stored in `claude-memory/memory.md`.

| Regulatory Context | Permitted Output Framing |
| ------------------ | ------------------------ |
| Explicit           | Named regulations allowed (e.g., GDPR, PCI DSS) |
| Implicit           | Generic regulatory exposure phrasing only (no named regulations) |
| Unknown            | Regulatory framing prohibited — omit Compliance / Regulatory Risk dimension |

**Enforcement:** The Evidence Reconciliation skill checks for violations at Stage 8 using the `⚠ REGULATORY EVIDENCE GAP` marker. Any output referencing a named regulation not present as a Compliance Requirement finding in `claude-memory/memory.md` is flagged before Stage 9 proceeds.

---

## Recommendation Traceability Format

Required in Stage 4 — Solution Design output:

```
Recommendation: [what is being recommended]
Evidence: F[ID] — [brief description of finding]
Capability Baseline: [domain name] domain — [brief reason]
Assumption: [if no finding or baseline applies, declare the assumption explicitly]
```

At least one of the three sources must be present. Recommendations with none are invalid and must not appear in client-facing output. When multiple sources apply, list all.

**Example:**
```
Recommendation: Introduce CI/CD QA gates
Evidence: F14 — pipeline lacks QA validation checkpoints
Capability Baseline: CI/CD Integration domain — automated quality enforcement not present
```

---

## Decision-Centric Human-in-the-Loop (HITL) Model

Human intervention is triggered based on **decision risk**, not workflow position. Any agent at any stage may trigger a HITL pause.

### Decision Risk Categories

| Category | Description | Example |
|---|---|---|
| Business Logic Impact | Decision changes how business rules are interpreted or applied | Recommending a different teller transaction limit structure |
| Compliance Exposure | Decision touches regulatory, audit, or legal territory | Assuming PCI DSS compliance scope without client confirmation |
| Coverage Reduction | Decision reduces test coverage or removes a testing layer | Recommending removal of manual regression in favour of automation-only |
| Behavioral Change | Decision alters user-facing behavior or workflow | Proposing a different approval chain for teller overrides |
| Release Risk | Decision affects release timing, rollback capability, or deployment | Recommending a big-bang cutover vs. phased rollout |
| Data Sensitivity | Decision involves handling of PII, financial data, or credentials | Proposing test data strategies that use production data |
| Traceability Impact | Decision breaks or weakens audit trail or requirement traceability | Removing traceability links between requirements and test cases |

### HITL Rule
If a decision touches **any** of the above categories and the agent cannot confirm from provided inputs that the decision is safe, the system must:

1. **Pause** — do not proceed with the decision
2. **State the decision** — what is being decided
3. **State the risk category** — which category applies
4. **State what is needed** — what confirmation or approval is required
5. **Wait** — do not assume approval; require explicit human confirmation

Format:
```
⚠ GOVERNANCE HITL — Decision Requires Human Approval

Decision: [what is being decided]
Risk Category: [which category]
Why: [why this exceeds the threshold]
Required: [what confirmation is needed to proceed]
```

### HITL Scope
- HITL pauses apply during Stages 4–8 of the workflow (agent analysis and governance)
- HITL does not apply to memory operations (Stages 0–3) or system learning (Stage 10)
- User may explicitly waive HITL for specific decisions, but this must be logged in `claude-memory/decisions.md`

### HITL Trigger Types

Two types of HITL pause exist. Both require human resolution before the affected work can proceed.

**Type 1 — Blocking HITL**
Occurs when the workflow cannot continue due to conflicting or unresolvable information. Prevents stage advancement until a human decision is provided.

Triggers:
- Conflicting architectural findings that cannot be resolved by evidence alone
- Undefined delivery dependency that blocks planning
- Contradictory constraints in the source artifacts

**Type 2 — Governance HITL**
Occurs at Stage 8 when governance validation identifies a condition requiring human approval before output can be released.

Triggers:
- Unresolved high-confidence findings not addressed in the solution
- Evidence gaps on recommendations going to client-facing output
- Compliance conflicts requiring explicit human sign-off

**Relationship:** Blocking HITL is a harder stop than Governance HITL — it prevents stage advancement entirely. Governance HITL permits output to proceed only after explicit human approval at Stage 8. The existing 5-step HITL pause protocol (pause, state decision, state risk category, state what is needed, wait) applies to both types.

### Blocking HITL Format

When a Blocking HITL condition is detected, the system must output the following format and halt stage advancement:

```
⚠ BLOCKING HITL — Stage Advancement Blocked

Issue: [what is conflicting or unresolvable]
Impact: [what cannot proceed and why]
Required Decision: [the specific human decision needed to unblock]
```

**Example:**
```
⚠ BLOCKING HITL — Stage Advancement Blocked

Issue: Conflicting findings between F04 (Stage 4 automation sprint 1) and F07 (6-week change governance constraint) cannot be resolved by evidence alone.
Impact: Stage 6 delivery planning cannot proceed — any timeline produced would be built on an unresolved conflict.
Required Decision: Confirm whether change governance applies to QA tooling. If yes, automation start must be deferred to Week 7 or later.
```

**Rule:** Blocking HITL must halt all stage advancement until the human provides an explicit decision. The system must not assume a default resolution.

---

## Inter-Agent Conflict Resolution

When two agents produce findings that appear to contradict each other, apply this priority hierarchy:

| Conflict | Resolution |
|---|---|
| Architecture soundness (Test Architect) vs. execution feasibility (QA Manager) | **QA Manager takes precedence** — a technically sound architecture that teams cannot execute is not a viable solution |
| Delivery timeline (Project Manager) vs. architecture scope (Test Architect) | **Project Manager takes precedence** — timeline is a hard constraint; scope must adapt |
| Execution realism (QA Manager) vs. client scoring expectations (Client Evaluator) | **Surface both** — this is a genuine tension that requires a user decision; do not resolve silently |
| Any agent finding vs. Review & Challenge gap classification | **Review & Challenge takes precedence** — it is the quality gate; its findings cannot be dismissed by the agent being reviewed |

**When conflict cannot be resolved by hierarchy:** Surface both positions explicitly under the heading *"Unresolved Tension — Decision Required"* and state what the user must decide.

---

## Sequencing Rules (System Level)

These rules govern skill sequencing across all workflows. They reinforce skill-level rules and take effect when skills are invoked without explicit sequencing instructions.

1. `qe-architect-thinking` always runs before any other skill in QE architecture work
2. `outcome-risk-framing` always runs before `structuring-consulting-thinking`
3. `structuring-consulting-thinking` always runs before `executive-communication`
4. `domain-context-adaptation` always runs after substantive analysis is complete — never before
5. `review-challenge-thinking` always runs last, before final output delivery
6. `tooling-technology-recommendation` only runs after `qe-architect-thinking` has defined required capabilities
7. Evidence-first validation always runs during Stage 8 — no architectural recommendation may be delivered without a traceable source (Finding ID, capability baseline, or declared assumption)

These rules are enforced at two levels:
- **Skill level (hard):** Skills with prerequisite checks (executive-communication, domain-context-adaptation, structuring-consulting-thinking) will HALT and state what is missing. Skill-level rules take precedence.
- **Conductor level (flagged):** For skills without built-in HALT checks, sequencing violations must be flagged explicitly in the output as: *"[SEQUENCING DEVIATION — [Skill X] was applied before [prerequisite]. Output may be incomplete or incorrectly framed.]"*

Explicit user instruction to proceed out of sequence overrides conductor-level flagging but does not override skill-level HALTs.

---

## Open Conditions (Stage 9 Appendix)

Open Conditions (OCs) are pre-award conditions that cannot be validated without deeper client access. They are declared in the Appendices section (Section 19) of Stage 9 proposal output and formally tracked through the engagement.

Open Conditions are not failure states — they are transparency mechanisms that protect proposal defensibility. Each OC must declare: what condition is open, why it cannot be confirmed pre-award, and what will close it.

### OC-1 — Specialist AI/ML Capability Not Confirmed

**Scope:** Applies **only** to Tier 2 AI/ML capabilities (predictive models, self-healing automation, autonomous test orchestration — see `## AI Capability Tier Classification` in `.claude/references/stage-4-classifications.md`).

**Trigger:** A Tier 2 AI/ML capability is proposed but one or more of the following has not been confirmed pre-award: specialist ML resourcing availability, training data readiness, ML infrastructure existence.

**Exclusion — CRITICAL:** Tier 1 AI-assisted process tools (LLM-prompt-based, SaaS/IDE extension, no specialist ML infrastructure required) are **NOT subject to OC-1**. These tools are Phase 2-viable and do not require pre-award specialist capability confirmation. Applying OC-1 to Tier 1 tools produces an uncompetitive proposal in modern RFP cycles.

**Resolution path:** Confirmed at Phase 0 discovery — client ML readiness assessment, training data availability review, specialist resourcing plan.

**Stage 9 Appendix format:**
```
OC-1: Specialist AI/ML capability readiness not confirmed pre-award.
Scope: [named Tier 2 AI/ML capabilities proposed in this engagement]
Condition: Client ML infrastructure readiness, training data availability, and specialist resourcing to be confirmed during Phase 0 discovery.
Resolution: Phase 0 AI readiness assessment deliverable.
```

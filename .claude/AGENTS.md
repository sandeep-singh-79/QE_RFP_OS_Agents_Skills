# AGENTS.md — System Conductor

This file defines how agents and skills work together. It governs routing, invocation order, quality gates, and conflict resolution. It does not restrict direct invocation — explicit user calls always take precedence.

---

## Agent Roster

| Agent | File | Primary Role |
|---|---|---|
| Test Architect | `agents/test-architect.md` | QA architecture design, layer completeness, tooling validation |
| Client / RFP Evaluator | `agents/client-rfp-evaluator.md` | Scoring, defensibility, procurement panel simulation |
| Project Manager | `agents/project-manager.md` | Planning realism, sequencing risk, delivery feasibility |
| QA Manager | `agents/qa-manager.md` | Execution feasibility, adoption risk, team sustainability |
| Tooling Recommender | `agents/tooling-technology-recommender.md` | Capability-driven tooling validation (invoked by Test Architect only) |

---

## Skill Roster

| Skill | When to Apply |
|---|---|
| `qe-architect-thinking` | Default thinking posture for all QE work — apply first |
| `assumption-dependency-management` | Any output containing timelines, estimates, or unverified inputs |
| `outcome-risk-framing` | Any finding that needs to move from observation to business consequence |
| `structuring-consulting-thinking` | Before executive communication — shapes raw analysis into hierarchy |
| `executive-communication` | Final step before any executive or client-facing output |
| `estimation-sizing-thinking` | When sizing, effort, or timeline is in scope |
| `review-challenge-thinking` | Mandatory pre-output gate for all client-facing deliverables |
| `domain-context-adaptation` | Only when client domain is explicitly confirmed |
| `tooling-technology-recommendation` | Only after architecture + capabilities are defined |

---

## Agent Selection — Routing Guide

Use this table to select the right agent for a given request type.

| Request Type | Primary Agent | Supporting Agents (if needed) |
|---|---|---|
| Review or score an RFP response | Client / RFP Evaluator | — |
| Design or assess QA architecture | Test Architect | Tooling Recommender (downstream) |
| Check if a plan or timeline is realistic | Project Manager | — |
| Check if a team can adopt a proposed approach | QA Manager | — |
| Full RFP review (architecture + scoring + feasibility) | Test Architect → QA Manager → PM → Client Evaluator | See Multi-Agent Workflow below |
| Risk framing or executive summary from existing analysis | Apply skills directly | Outcome & Risk Framing → Structuring → Executive Communication |
| Tooling selection or validation | Test Architect (routes to Tooling Recommender) | — |

**Rule:** When more than one agent seems applicable, select by primary concern:
- Architecture concern → Test Architect
- Scoring / perception concern → Client / RFP Evaluator
- Delivery timeline concern → Project Manager
- Team capability concern → QA Manager

---

## Canonical Multi-Agent Workflow (Full RFP Review)

When a full RFP response or proposal needs comprehensive review, use this sequence. Each stage builds on the previous. Do not skip or reorder.

```
Stage 1 — Architecture Review
  Agent:  Test Architect
  Skill:  QE Architect Thinking (mandatory first)
  Output: Architecture findings, layer gaps, tooling readiness

Stage 2 — Execution Feasibility
  Agent:  QA Manager
  Input:  Stage 1 output
  Skill:  Assumption & Dependency Management
  Output: Adoption risk, team sustainability findings

Stage 3 — Delivery Planning
  Agent:  Project Manager
  Input:  Stage 1 + 2 output
  Skill:  Estimation & Sizing Thinking (if timelines in scope)
  Output: Sequencing risks, dependency gaps, planning realism findings

Stage 4 — Risk Framing & Structuring
  Skills: Outcome & Risk Framing → Structuring & Consulting Thinking
  Input:  All findings from Stages 1–3
  Output: Prioritized, hierarchical finding set

Stage 5 — Client Evaluation Simulation
  Agent:  Client / RFP Evaluator
  Input:  Stage 4 structured output
  Output: Scoring risks, defensibility gaps, red flags

Stage 6 — Quality Gate (MANDATORY)
  Skill:  Review & Challenge Thinking
  Input:  Full output from all prior stages
  Output: Gap classification, submission readiness

Stage 7 — Executive Communication (if required)
  Skill:  Executive Communication
  Input:  Stage 6 cleared output
  Output: Executive-ready summary
```

**This workflow is a recommendation, not a lock.** Explicit user instructions override any stage or sequence.

---

## Mandatory Quality Gate

**Rule:** All client-facing or executive-facing outputs MUST pass through the Review & Challenge Thinking skill before delivery.

### What "Client-Facing" Means
An output is client-facing if it will be:
- Submitted as part of an RFP response or proposal
- Presented to a client in a review, briefing, or workshop
- Shared with executive sponsors, procurement panels, or steering committees
- Included in any document external to the delivery team

### What "Working Draft" Means
An output is a working draft if it is:
- An internal iteration shared only within the delivery or QA team
- Explicitly labelled as a draft for team review only
- Being assembled before consolidation into a final output

### Gate Requirement
- **Client-facing:** Review & Challenge Thinking is mandatory, not optional
- **Working draft:** Review & Challenge Thinking is recommended but not required
- **If skipped on client-facing output:** State explicitly that the quality gate was not applied and the output has not been challenged

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

These rules are enforced at two levels:
- **Skill level (hard):** Skills with prerequisite checks (executive-communication, domain-context-adaptation, structuring-consulting-thinking) will HALT and state what is missing. Skill-level rules take precedence.
- **Conductor level (flagged):** For skills without built-in HALT checks, sequencing violations must be flagged explicitly in the output as: *"[SEQUENCING DEVIATION — [Skill X] was applied before [prerequisite]. Output may be incomplete or incorrectly framed.]"*

Explicit user instruction to proceed out of sequence overrides conductor-level flagging but does not override skill-level HALTs.

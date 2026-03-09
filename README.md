# QE RFP Operating System — User Guide

The QE OS is an AI-assisted system for reviewing, designing, and strengthening QA proposals and RFP responses. It uses a set of specialist agents and skills to ensure outputs are evidence-based, architecturally sound, execution-realistic, and defensible under client evaluation.

---

## What This System Does

| Capability | How |
|---|---|
| Reviews RFP responses for scoring risk and defensibility | Client / RFP Evaluator agent |
| Designs or validates QA architecture | Test Architect agent |
| Assesses whether a plan and timeline is realistic | Project Manager agent |
| Assesses whether teams can adopt a proposed approach | QA Manager agent |
| Structures raw findings into leadership-ready outputs | Structuring + Executive Communication skills |
| Enforces anti-hallucination, evidence traceability, and governance | System-wide via `copilot-instructions.md` + `AGENTS.md` |

---

## Two Modes of Use

### Mode 1 — Full RFP Review (Multi-Stage Workflow)

Use this when you have an RFP, a draft proposal, or a complete engagement scenario to work through end to end.

The system runs Stages 0–10:

| Stage | What Happens |
|---|---|
| 0 — Artifact Discovery | All documents indexed into `artifacts.md` |
| 1 — Evidence Extraction | Findings extracted from artifacts into `memory.md` |
| 2 — Memory Initialization | Workspace confirmed ready for agent work |
| 3 — Gap Coverage | All High-confidence findings accounted for |
| 3.5 — Capability Coverage | All 8 QE capability domains assessed |
| (Optional) Question → Capability Mapping | RFP questions mapped to evaluation intent |
| 4 — Solution Design | Test Architect architects the QA solution |
| 5 — Architecture Validation | QA Manager assesses execution feasibility |
| 6 — Delivery Validation | Project Manager assesses timeline and dependencies |
| 7 — Client Perspective | Client Evaluator simulates scoring and red flags |
| 8 — Governance Validation | Evidence traceability and quality rules enforced |
| 9 — Output Generation | Review & Challenge quality gate applied |
| 10 — System Learning | Improvement proposals recorded |

**To start a full review**, say:

> "I have an RFP to review. Here is the document: [paste or attach]. Run a full review."

The system will start at Stage 0 and progress through the workflow, pausing for human input at decision points.

---

### Mode 2 — Spot Task (Single Agent or Skill)

Use this when you need one specific thing — a scoring review, a risk framing, a defensibility check — without running the full workflow.

**Examples:**

| What you need | What to say |
|---|---|
| Score a draft section | "Review this methodology section as a client evaluator and flag scoring risks." |
| Check architecture completeness | "Review the architecture section — are all QA layers covered?" |
| Frame a finding as a business risk | "We found no test data strategy. Frame this as a business risk for the proposal." |
| Challenge a proposal before submission | "Punch holes in this proposal — where are we over-committing?" |
| Adapt language for a specific industry | "Adapt this proposal section for a retail banking audience." |
| Check a plan for delivery risks | "Review this timeline — are there any hidden dependencies or optimism?" |
| Size a piece of work | "Give me a directional estimate for 200 test cases across 3 applications." |

See `.claude/references/trigger-prompts.md` for full examples of what activates each agent and skill — and what does not.

---

## Key Files

### System Files (Read — do not modify directly)

| File | Purpose |
|---|---|
| `.claude/AGENTS.md` | Full QE OS execution harness — workflow, governance, routing, memory rules |
| `.claude/copilot-instructions.md` | System-wide guardrails — anti-hallucination, input validation, scope, confidentiality |
| `.claude/references/trigger-prompts.md` | Example prompts that should (and should not) activate each skill and agent |
| `.claude/references/qe-capability-map.md` | The 8 QE capability domains used for coverage assessment |

### Agent Files (define agent scope and behaviour)

```
.claude/agents/
├── test-architect.md
├── client-rfp-evaluator.md
├── project-manager.md
├── qa-manager.md
└── tooling-technology-recommender.md
```

### Skill Files (define skill logic, activation conditions, and guardrails)

```
.claude/skills/
├── qe-architect-thinking/
├── evidence-extraction/
├── capability-coverage/
├── evidence-reconciliation/
├── question-capability-mapping/       ← optional; maps RFP questions to capability domains
├── assumption-dependency-management/
├── outcome-risk-framing/
├── structuring-consulting-thinking/
├── executive-communication/
├── estimation-sizing-thinking/
├── review-challenge-thinking/
├── domain-context-adaptation/
└── tooling-technology-recommendation/
```

### Workspace Memory (generated during workflow execution)

| File | Purpose |
|---|---|
| `claude-memory/memory.md` | Structured findings extracted from artifacts — the system's evidence base |
| `claude-memory/notes.md` | In-progress analysis and intermediate outputs |
| `claude-memory/insights.md` | Reusable patterns from prior engagements |
| `claude-memory/artifacts.md` | Index of all input documents (created at Stage 0) |
| `claude-memory/decisions.md` | Major decisions with rationale (created when first needed) |
| `claude-memory/improvements.md` | Proposed improvements to the QE OS (created when first needed) |

Memory files are workspace-scoped. They accumulate across stages within a single engagement. Start a new engagement by clearing or archiving the `claude-memory/` files.

---

## Governance Rules (Summary)

The system enforces five standing rules automatically. You do not need to invoke them.

| Rule | What It Does |
|---|---|
| **Anti-hallucination** | No statistics, benchmarks, or client data invented. Every claim is traceable or flagged as an assumption. |
| **Input Validation Gate** | Work cannot start without a task type, primary content, and stated purpose. |
| **Evidence-First Reasoning** | Every architectural recommendation must reference a Finding ID, capability baseline, or declared assumption. Recommendations without traceable sources are flagged `⚠ EVIDENCE GAP`. |
| **Memory Integrity** | Findings in `memory.md` are append-only. Contradictions are preserved and flagged — not silently resolved. |
| **Quality Gate** | All client-facing outputs must pass the Review & Challenge skill before delivery. This cannot be skipped silently. |

---

## Human-in-the-Loop Pauses

The system will pause and request your decision when a conclusion touches:

- Business logic or process interpretation
- Compliance or regulatory scope
- Coverage reduction (removing a test layer)
- Data sensitivity (PII, financial data)
- Release risk (cutover strategy, rollback)

The pause format is:
```
⚠ HITL PAUSE — Decision Requires Human Approval
Decision: [what is being decided]
Risk Category: [which category]
Required: [what confirmation is needed to proceed]
```

You must respond explicitly. The system does not assume approval.

---

## How Evidence Works

This system is evidence-driven. Understanding the chain helps you get better outputs.

```
Artifacts (RFP, briefs, diagrams)
    ↓   [Stage 1 — Evidence Extraction]
memory.md  (findings with Finding IDs, F1, F2, ...)
    ↓   [Stages 3–7 — Agent Analysis]
Solution design that references Finding IDs
    ↓   [Stage 8 — Governance Validation]
Every recommendation traced to: Finding ID + Capability Domain + Assumption
    ↓   [Stage 9 — Quality Gate]
Client-facing output, challenged and cleared
```

Each Finding ID (e.g., `F14`) links a recommendation all the way back to the artifact it came from. This is what makes the system's outputs defensible under client or governance scrutiny.

---

## Frequently Used Prompts

**Start a full RFP review:**
> "Here is the RFP / proposal draft. Run a full review."

**Spot-check a section before submission:**
> "This is going to the client tomorrow. Review it from a scoring and defensibility perspective."

**Frame a gap as a business risk:**
> "We found [observation]. Frame this as a business risk with impact and urgency."

**Check if a timeline holds up:**
> "Review this delivery plan — does it hold up, or are there sequencing problems?"

**Run the optional question mapping:**
> "Before solution design, map these RFP questions to the QE capabilities they're evaluating."

**Challenge the whole output:**
> "Do a final challenge pass on this before we submit."

---

## System Improvement

If the system produces a weak output, the right action is:
1. Flag the finding — the Stage 10 retrospective is designed for this
2. Propose a change via `improvements.md` — agents write proposals there; you approve changes to system files
3. Never edit `.claude/AGENTS.md`, `.claude/copilot-instructions.md`, or skill files directly during a live engagement

Proposed improvements that accumulate 3+ evidence gap proposals trigger a human review flag before the next engagement.

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
| Infers applicable regulatory framework from client domain × geography | Stage 0 via `domain-regulatory-map.md` |
| Detects incumbent vendor presence and gates Section 15 accordingly | Stage 0 explicit confirmation prompt |
| Classifies engagement type, discovery maturity, application count, and vendor capability | Stage 0 via `stage-0-inputs.md` |
| Extracts and traces quantified value claims with evidence grounding | Stage 1 via Value Claim Trace Block |
| Classifies AI capabilities by tier (Tier 1 prompt-based / Tier 2 ML) and phases accordingly | Stage 4 AI Capability Tier Classification |
| Classifies benefit realisability (unconditional vs conditional) | Stage 4 Benefit Claim Classification |
| Produces risk-based test classification by change type | Stage 4 Risk-Based Test Classification |
| Drafts application clustering when multiple applications are in scope | Stage 4 Application Clustering Draft |
| Applies three-tier tooling framing (Confirmed / Suggested / Proposed) | Stage 4 + Stage 9 Tooling Three-Tier Framing |
| Generates canonical 19-section structured proposal output | Stage 9 via `stage-9-output-structure.md` |
| Applies go/no-go quality gate verdict before Stage 9 output | Review & Challenge skill — Gate Verdict |
| Provides PERT-based effort estimation with tier and phase breakdown | `pert-estimation` skill |
| Extracts KPI targets, flags absence, recommends sourced benchmarks | `kpi-baseline` skill |
| Adapts proposal language for confirmed client industry context | `domain-context-adaptation` skill |
| Structures raw findings into leadership-ready outputs | Structuring + Executive Communication skills |
| Enforces anti-hallucination, evidence traceability, and governance | System-wide via `copilot-instructions.md` + `AGENTS.md` |

---

## Two Modes of Use

### Mode 1 — Full RFP Review (Multi-Stage Workflow)

Use this when you have an RFP, a draft proposal, or a complete engagement scenario to work through end to end.

The system runs Stages 0–10:

| Stage | What Happens |
|---|---|
| 0 — Engagement Classification | Artifacts indexed; engagement type, application count, and vendor capability manifest captured; incumbent vendor confirmed; regulatory context inferred from domain × geography |
| 1 — Evidence Extraction | Findings extracted from artifacts into `memory.md`; value claim traces produced; regulatory context applied from Stage 0 |
| 2 — Memory Initialization | Workspace confirmed ready for agent work |
| 3 — Gap Coverage | All High-confidence findings accounted for |
| 3.5 — Capability Coverage | All 8 QE capability domains assessed |
| (Optional) Question → Capability Mapping | RFP questions mapped to evaluation intent |
| 4 — Solution Design | Test Architect architects the QA solution; benefit claims classified; risk-based test classification produced; application clustering drafted |
| 5 — Architecture Validation | QA Manager assesses execution feasibility; SME demand impact evaluated |
| 6 — Delivery Validation | Project Manager assesses timeline and dependencies; in-sprint automation DoD validated |
| 7 — Client Perspective | Client Evaluator simulates scoring and red flags |
| 8 — Governance Validation | Evidence traceability and quality rules enforced |
| 9 — Output Generation | Review & Challenge quality gate (Gate Verdict: Ready / Conditional / Not Ready) applied; canonical 19-section proposal output produced |
| 10 — System Learning | Improvement proposals recorded to `improvements.md` and promoted to `insights.md` |

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
| `.claude/governance.md` | HITL model, gap coverage rules, evidence traceability, output type classification, conflict resolution, sequencing rules |
| `.claude/SETUP.md` | Workspace initialization, file templates, and System Change Review Checklist |

### Reference Files (loaded on demand by stage action instructions)

| File | Purpose |
|---|---|
| `.claude/references/trigger-prompts.md` | Example prompts that should (and should not) activate each skill and agent |
| `.claude/references/qe-capability-map.md` | The 8 QE capability domains used for coverage assessment |
| `.claude/references/domain-regulatory-map.md` | Domain × Geography → Regulatory Framework inference table (used at Stage 0) |
| `.claude/references/stage-0-inputs.md` | Engagement input classification reference — engagement type, application count, Discovery Maturity, Vendor Capability Manifest, Engagement Signals |
| `.claude/references/stage-4-classifications.md` | AI tier, tooling tier, and benefit claim classification definitions used at Stage 4 |
| `.claude/references/stage-9-output-structure.md` | Canonical 19-section proposal output structure with per-section content rules, source inputs, and conditional trigger logic |
| `.claude/references/quality-gate-reference.md` | Quality gate scoring rules, Gate Verdict criteria, and Completeness Checklist |
| `.claude/references/memory-protocol.md` | Memory file protocols — append rules, summarisation thresholds, overwrite conditions |
| `.claude/references/stage-10-learning.md` | Stage 10 learning and improvement recording rules |

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
├── pert-estimation/                   ← PERT formula, 8 tiers, effort multipliers, phase breakdown
├── kpi-baseline/                      ← KPI extraction, flag-if-absent, sourced benchmarks, baseline capture
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

Two pause types exist:

**Governance HITL** — triggered at governance-layer decision points:
```
⚠ GOVERNANCE HITL — Decision Requires Human Approval
Decision: [what is being decided]
Risk Category: [which category]
Why: [why this exceeds the threshold]
Required: [what confirmation is needed to proceed]
```

**Blocking HITL** — triggered mid-workflow when stage advancement cannot continue:
```
⚠ BLOCKING HITL — Stage Advancement Blocked
Issue: [what is conflicting or unresolvable]
Impact: [what cannot proceed and why]
Required Decision: [the specific human decision needed to unblock]
```

You must respond explicitly to either type. The system does not assume approval.

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

**Get a sizing estimate:**
> "Give me a directional estimate for 200 test cases across 3 applications using PERT."

**Check KPI targets:**
> "Extract any KPI targets from this RFP. If none are stated, recommend industry benchmarks."

---

## System Improvement

If the system produces a weak output, the right action is:
1. Flag the finding — the Stage 10 retrospective is designed for this
2. Propose a change via `claude-memory/improvements.md` — agents write proposals there; you approve changes to system files
3. Never edit `.claude/AGENTS.md`, `.claude/copilot-instructions.md`, or skill files directly during a live engagement

Proposed improvements that accumulate 3+ evidence gap proposals trigger a human review flag before the next engagement.

---

## Current System Version

**Post-Manulife Retrospective (March 2026)**

All 12 improvements from the Manulife retrospective have been implemented. See [implementation-plan.md](implementation-plan.md) for the full task list and file change log.

Key capabilities added in this cycle:
- PERT-based effort estimation (`pert-estimation` skill) — 8 test tiers, effort multipliers, 5-phase breakdown
- KPI extraction and benchmark sourcing (`kpi-baseline` skill) — extracts client targets, flags absence, recommends sourced benchmarks
- Discovery Maturity classification — `Constrained / Moderate / Deep` drives gap status defaults at Stages 3 and 8
- `Deferred to Transition — Explicitly Declared` status — requires 3 mandatory fields; missing any one reverts to `Unresolved`
- Value Claim Trace Block — quantified benefit claims in Stage 1 now require an evidence source or are explicitly flagged
- Regulatory Control Mapping — Stage 8 blocks on `Compliance Requirement` findings without a control mapping table
- Review & Challenge Gate Verdict — go / conditional / not ready verdict replaces open-ended quality review

---

## Known Gaps (Ordered by Estimated ROI)

These gaps were identified during a framework evaluation in March 2026. They are listed in order of estimated return on investment — meaning the highest-impact, highest-frequency gaps appear first.

### 1. Stage 3.5 — No blocking condition for critical capability domain absence

**Gap:** Stage 3.5 (Capability Coverage) documents Missing and Partial domains but does not halt workflow progression when a critical capability domain (e.g., CI/CD Integration, Automation Strategy) is entirely absent with no remediation path declared. A proposal with a structural capability hole can reach Stage 4 and produce output without escalation.

**Contrast:** Stage 3 blocks if any High-confidence finding is `Unresolved`. Stage 3.5 has no equivalent enforcement.

**Fix needed:** Add a HITL block condition to Stage 3.5 — if any of the 8 QE capability domains is `Absent` AND no planned remediation is declared in the solution design, halt and require human confirmation before advancing to Stage 4.

---

### 2. Stage 0 — `plan.md` field misconfiguration flows silently into output structure

**Gap:** Engagement type (e.g., `qa_audit`, `managed_service`) and engagement signals (e.g., `incumbent_vendor_present`) set at Stage 0 control which of the 19 canonical output sections are generated. If `plan.md` is misconfigured or left at defaults, conditional sections are silently suppressed or incorrectly generated — and no downstream stage re-validates those fields before Stage 9 produces output.

**Example:** A `managed_service` engagement incorrectly classified as `transformation_partnership` will generate Section 8 (Transformation Roadmap) and Section 10 (Benefit Realisation) with wrong framing assumptions running through the full output.

**Fix needed:** Add a Stage 0 field validation step (or Stage 9 pre-output check) that confirms Engagement Type and Engagement Signals are explicitly set — not left at initialisation defaults — before Stage 9 begins rendering conditional sections.

---

### 3. Copilot pointer stub — no mechanical enforcement fallback

**Gap:** `.github/copilot-instructions.md` is a pointer stub that instructs GitHub Copilot to read `.claude/copilot-instructions.md` and `.claude/AGENTS.md`. Unlike Claude Code's `@<path>` include (which is a hard load), this is an instruction — followed almost always, but not mechanically enforced. If Copilot skips it under context pressure, the anti-hallucination and evidence sourcing rules are not active.

**Fix needed:** Add an inline summary of the 3–5 most critical non-overridable rules directly into `.github/copilot-instructions.md` as a fallback, so the most harmful failure modes (fabrication, missing sourcing flags) are guarded even without the full canonical file load.

---

### 4. File authority ambiguity — versioned files in workspace root vs. canonical `.claude/` files

**Gap:** The workspace root contains `agents/` and `skills/` folders with versioned Markdown files (e.g., `Test_Architect_Agent_v1.2.md`, `Client_RFP_Evaluator_Agent_v1.3.md`). The canonical, active agent and skill definitions live in `.claude/agents/` and `.claude/skills/`. Anyone opening the workspace and editing a root-level file is modifying a predecessor version with no effect on system behaviour — with no warning.

**Fix needed:** Archive or remove the root-level `agents/` and `skills/` folders, or add a clearly visible `README` in each that states they are superseded by `.claude/agents/` and `.claude/skills/`.

---

### 5. `improvements.md` — no tracked promotion path from proposal to implementation

**Gap:** Agents write improvement proposals to `claude-memory/improvements.md`. Human approval is required before changes are made to system files. However, there is no tracking mechanism in the framework for when approved proposals are actually promoted — proposals can accumulate indefinitely without being actioned, and there is no way to distinguish "approved but not yet implemented" from "awaiting approval".

**Fix needed:** Add a `Status` column to the `improvements.md` schema (`Proposed / Approved / Implemented / Rejected`) and add a Stage 10 check that flags any `Approved` improvements that have remained unimplemented for more than one engagement cycle.

---

### 6. `question-capability-mapping` skill — optional with no activation gate enforcement

**Gap:** The activation condition for `question-capability-mapping` requires three flags to be true simultaneously (RFP questions present in artifacts, Stage 3.5 complete, Stage 4 not yet started). These conditions are stated in `AGENTS.md` as rule text but are not enforced — the skill can be invoked mid-Stage 4 or skipped entirely when all three conditions are met, without triggering any system alert.

**Fix needed:** Add a HALT condition to the skill itself that checks activation preconditions and refuses to run if Stage 4 has already started, and a Stage 3.5 checkpoint note that prompts the conductor to confirm whether RFP questions are present before advancing.

---

### 7. `prompts/` folder — orphaned engagement artifact

**Gap:** The `prompts/` folder contains a single file (`manulife-rerun-master-prompt.md`) — an engagement-specific artifact from the Manulife engagement. It is not referenced by any system file and has no catalog function. Reusable trigger prompts live in `.claude/references/trigger-prompts.md`, not here. The folder's presence implies it has a system role it does not have.

**Fix needed:** Either archive the file alongside other Manulife engagement outputs, or repurpose the `prompts/` folder as a curated library of standardised entry prompts for common engagement scenarios — and update the README to reference it.

# Guardrail Implementation Plan

> **Purpose:** Track implementation of guardrails for the `.claude/` agent-skill system.  
> **Status:** Phase 2A complete. Phase 2B complete.  
> **Last Updated:** 2026-03-06  
> **Update Policy:** This file is updated after every sub-task completion, context compaction, or re-initialization.

---

## Status Key

- `[ ]` Not started
- `[~]` In progress
- `[x]` Completed
- `[!]` Blocked

---

## CRITICAL Priority

### Task 1: Anti-Hallucination & Fabrication Prevention
**File:** `.claude/copilot-instructions.md` (new)  
**Risk:** LLMs confabulate by default. Without explicit prohibition, fabricated data will appear in RFP outputs. No recovery from client trust damage.

- [x] 1.1 Create `.claude/copilot-instructions.md` with system-wide workspace instructions
- [x] 1.2 Add anti-hallucination rules: no invented statistics, no fabricated client data, no fictional case studies
- [x] 1.3 Add mandatory sourcing rule: every claim must be traceable to provided context or explicitly flagged as assumption
- [x] 1.4 Add "when uncertain" protocol: state uncertainty explicitly, never fill gaps with plausible-sounding content

### Task 2: Orchestration Conductor
**File:** `.claude/AGENTS.md` (new)  
**Risk:** Without routing logic, wrong agent gets invoked = structurally wrong output. User must know system internals to use it correctly.

- [x] 2.1 Create `.claude/AGENTS.md` as the system conductor
- [x] 2.2 Define agent selection criteria — which request types route to which agent
- [x] 2.3 Define canonical invocation order for multi-agent workflows (e.g., full RFP review)
- [x] 2.4 Define skill sequencing rules at system level (not just per-skill)
- [x] 2.5 Add inter-agent conflict resolution protocol (what takes precedence when agents disagree)

---

## HIGH Priority

### Task 3: Sequencing Enforcement (HALT Mechanism)
**Files:** Skills — `executive-communication`, `domain-context-adaptation`, `structuring-consulting-thinking`  
**Risk:** Advisory "Apply After X" rules get bypassed under time pressure. Polished but hollow content reaches clients.

- [x] 3.1 Add prerequisite check + HALT pattern to `executive-communication/SKILL.md`
- [x] 3.2 Add prerequisite check + HALT pattern to `domain-context-adaptation/SKILL.md` (strengthen existing gate)
- [x] 3.3 Add prerequisite check + HALT pattern to `structuring-consulting-thinking/SKILL.md`

### Task 4: Mandatory Quality Gate
**Files:** `.claude/AGENTS.md`, `review-challenge-thinking/SKILL.md`  
**Risk:** Under time pressure, review is the first step skipped. Over-commitments and weak assumptions ship to procurement panels unscreened.

- [x] 4.1 Add mandatory pre-output review rule in `AGENTS.md` for all client-facing or executive-facing outputs
- [x] 4.2 Add enforcement language in `review-challenge-thinking/SKILL.md` — not optional for High-priority deliverables
- [x] 4.3 Define what constitutes "client-facing" vs "working draft" to scope the gate appropriately

### Task 5: Input Validation Gate
**File:** `.claude/copilot-instructions.md`  
**Risk:** Agents produce speculative analysis presented as grounded findings. Confident garbage presented as analysis.

- [x] 5.1 Define minimum context requirements before any agent starts substantive work
- [x] 5.2 Add intake validation rules: what must be present vs what can be assumed
- [x] 5.3 Define "insufficient context" response protocol — what to say and ask for, not just halt

---

## Cleanup

### Task 6: Minor Fixes
**Files:** `.claude/agents/project-managerr.md`, `.claude/settings.json`

- [x] 6.1 Rename `project-managerr.md` → `project-manager.md`
- [x] 6.2 Review and update `settings.json` permissions to match actual workspace structure

---

## Phase 2A Completion Summary

| Priority | Tasks | Sub-tasks | Completed |
|----------|-------|-----------|-----------|
| CRITICAL | 2 | 9 | 9 |
| HIGH | 3 | 9 | 9 |
| Cleanup | 1 | 2 | 2 |
| **Total** | **6** | **20** | **20** |

---

## Phase 2B — MEDIUM + LOW Priority

### Task 7: Agent-Level Scope Enforcement (Gap #6 — MEDIUM)
**Files:** `.claude/agents/client-rfp-evaluator.md`, `.claude/agents/project-manager.md`, `.claude/agents/qa-manager.md`, `.claude/agents/test-architect.md`  
**Risk:** 4 of 5 agents have prohibited skills lists but no defined response when users push them out of scope. Under time pressure or unfamiliarity, users get silent compliance with out-of-scope requests instead of a redirect. `tooling-technology-recommender` already has the correct pattern — scale it.

**Pattern to replicate** (from `tooling-technology-recommender.md`):
> *"If asked to [prohibited action], decline and redirect to [correct agent] to complete [prerequisite] first."*

- [x] 7.1 Add scope protection + decline-and-redirect protocol to `client-rfp-evaluator.md`
- [x] 7.2 Add scope protection + decline-and-redirect protocol to `project-manager.md`
- [x] 7.3 Add scope protection + decline-and-redirect protocol to `qa-manager.md`
- [x] 7.4 Add scope protection + decline-and-redirect protocol to `test-architect.md`
- [x] 7.5 Add `copilot-instructions.md` §3 cross-reference to all 5 agents (including tooling-technology-recommender)

### Task 8: Confidentiality & Data Handling Guardrails (Gap #8 — LOW↑)
**File:** `.claude/copilot-instructions.md` (new section)  
**Risk:** The system routinely processes client-sensitive RFP content — procurement details, internal processes, team structures, budget constraints. No guardrails exist for how this data is handled, quoted, or retained. For a professional services / consulting tool, this is a credibility and trust gap.

- [x] 8.1 Add Section 5 to `copilot-instructions.md`: Confidentiality & Data Handling
- [x] 8.2 Define client data treatment rules: quoting, paraphrasing, attribution
- [x] 8.3 Define output sensitivity awareness: flag when outputs contain client-sensitive content
- [x] 8.4 Define data scope rules: outputs should not leak content from one RFP into another

### Task 9: Context Budget Management (Gap #9 — LOW)
**File:** `.claude/copilot-instructions.md` (new section) + agent/skill hygiene  
**Risk:** Duplicate content across agents and skills burns context window tokens silently. Large agent files with repeated preambles reduce the effective token budget available for actual analysis. Operational inefficiency — not a correctness risk, but degrades output quality as complexity grows.

- [x] 9.1 Add Section 6 to `copilot-instructions.md`: Context Efficiency Principles
- [x] 9.2 Define duplication avoidance rule: agents/skills reference shared rules by pointer, not repetition
- [x] 9.3 Define output conciseness guidance: prefer structured findings over verbose prose when context is constrained
- [x] 9.4 Audit agents for duplicated preamble content and flag candidates for consolidation

---

## Phase 2B Completion Summary

| Priority | Tasks | Sub-tasks | Completed |
|----------|-------|-----------|-----------|
| MEDIUM | 1 | 5 | 5 |
| LOW↑ | 1 | 4 | 4 |
| LOW | 1 | 4 | 4 |
| **Total** | **3** | **13** | **13** |

---

## Phase 2C — Trigger Prompts Validation Fixes

### Task 11: Fix Three Gaps Found During Live RFP Testing
**File:** `.claude/references/trigger-prompts.md`  
**Risk:** Inaccurate or missing test prompts produce false passes during validation, allowing enforcement gaps to go undetected. Found via live testing against the Libro Credit Union RFP (March 2026).

- [x] 11.1 Fix Input Validation Trigger 3 — add condition qualifier: prompt only halts when no document is attached; must not be used as a test when content is present in context
- [x] 11.2 Add §5 Confidentiality trigger/non-trigger prompts — entire guardrail section had zero test coverage
- [x] 11.3 Fix Domain Context Adaptation non-triggers — add domain-contradiction test case (user states wrong domain that conflicts with provided document)
- [x] 11.4 Fix Client Evaluator trigger prompts — add explicit note that a vendor response must be present; prompts implicitly assume it but do not state it

---

## Phase 2C Completion Summary

| Priority | Tasks | Sub-tasks | Completed |
|----------|-------|-----------|------|
| Test coverage | 1 | 4 | 4 |

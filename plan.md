# Guardrail Implementation Plan

> **Purpose:** Track implementation of critical and high-priority guardrails for the `.claude/` agent-skill system.  
> **Status:** COMPLETE  
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

## Completion Summary

| Priority | Tasks | Sub-tasks | Completed |
|----------|-------|-----------|-----------|
| CRITICAL | 2 | 9 | 9 |
| HIGH | 3 | 9 | 9 |
| Cleanup | 1 | 2 | 2 |
| **Total** | **6** | **20** | **20** |

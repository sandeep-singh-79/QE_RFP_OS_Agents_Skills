# Claude Memory

This file acts as the persistent memory and context store. It is updated after every change and always reflects the latest decisions, context, and rationale.

> **Update Policy:** Update this file after every task completion, context compaction, or re-initialization. Read this file first when resuming work.

---

## Prior Work (Completed)

Phase 1 — Skill/Agent audit implementation is complete. All 14 files (9 skills + 5 agents) were improved per audit recommendations. See `tasks.md` for the full historical record.

---

## Current Phase: Guardrail Implementation

### What We're Building
Implementing critical and high-priority guardrails for the `.claude/` agent-skill system based on a context engineering review.

### Plan Location
`plan.md` — source of truth for all tasks, sub-tasks, and status.

### System Architecture
- **Workspace:** `c:\Data\Projects\Agents & Skills`
- **Agent-skill system:** `.claude/` folder
  - `agents/` — 5 agent files (client-rfp-evaluator, project-manager, qa-manager, test-architect, tooling-technology-recommender)
  - `skills/` — 9 skill folders, each with `SKILL.md`
  - `settings.json` — permissions config
  - `references/` — contains trigger-prompts.md
- **Memory system:** `claude-memory/` (this folder)
- **Historical:** `tasks.md` (prior audit tasks)

### Current Context
- **ALL 6 TASKS COMPLETE — 20/20 sub-tasks done**
- Guardrail implementation phase is finished

### What Was Built
1. `.claude/copilot-instructions.md` — workspace-wide anti-hallucination rules, mandatory sourcing, input validation gate, scope boundary enforcement
2. `.claude/AGENTS.md` — system conductor: agent routing, canonical multi-agent workflow, quality gate rules, conflict resolution, system-level sequencing
3. HALT mechanism added to `executive-communication/SKILL.md`
4. HALT mechanism added to `domain-context-adaptation/SKILL.md` (strengthened existing gate)
5. HALT mechanism added to `structuring-consulting-thinking/SKILL.md`
6. Mandatory gate language added to `review-challenge-thinking/SKILL.md`
7. `project-managerr.md` renamed to `project-manager.md`
8. `settings.json` permissions updated to reflect actual workspace structure (.claude/**, agents/**, skills/**, claude-memory/**, plan.md, tasks.md)

### Key Design Decisions Implemented
1. Anti-hallucination rules in `copilot-instructions.md` — workspace-wide, always loaded, cannot be overridden except fabrication rules are absolute
2. Orchestration conductor in `AGENTS.md` — routing table, multi-agent workflow, conflict hierarchy
3. HALT pattern modeled on Tooling skill — prerequisites checked → explicit STOP message → state what's missing
4. Quality gate: mandatory for client-facing, recommended for working drafts, with warning label if skipped
5. Input validation: three minimum requirements → permitted assumptions with declaration → three-step insufficient context protocol

---

## Post-Implementation: Review & Cross-System Rollout

### Review Finding Fixed
During post-implementation review, a contradiction was found and fixed in `.claude/AGENTS.md`:
- The "Sequencing Rules" section said violations *"do not prevent execution — but must be flagged"*
- This contradicted the HALT mechanisms added to the skills
- Fixed: Section now distinguishes skill-level (hard HALT) from conductor-level (flagged deviation), with explicit precedence rule

### Cross-System Coverage Added
The guardrails in `.claude/` are not automatically read by all agentic systems. Each expects files in different locations. To solve this without duplicating content, thin pointer stubs were created:

| File | System | Mechanism |
|---|---|---|
| `CLAUDE.md` (root) | Claude Code | Native `@import` — hard loads `.claude/copilot-instructions.md` and `.claude/AGENTS.md` |
| `AGENTS.md` (root) | Codex, OpenCode | Pointer stub — instructs agent to read canonical files |
| `.github/copilot-instructions.md` | GitHub Copilot | Pointer stub — instructs Copilot to read canonical files |

### Single Source of Truth Rule
**Only ever edit `.claude/copilot-instructions.md` and `.claude/AGENTS.md`.**
The three pointer/stub files above reference the canonical files — they never need to change unless the canonical file paths change.

### Current State of All Files
- `.claude/copilot-instructions.md` — canonical guardrails (anti-hallucination, input validation, scope enforcement, system principles)
- `.claude/AGENTS.md` — canonical conductor (routing, workflow, quality gate, conflict resolution, sequencing rules)
- `CLAUDE.md` — Claude Code entry point (`@import` of both canonical files)
- `AGENTS.md` — Codex/OpenCode entry point (pointer stub)
- `.github/copilot-instructions.md` — GitHub Copilot entry point (pointer stub)
- `plan.md` — implementation plan, fully complete (20/20 sub-tasks)

# Claude Notes

Working notes for the current implementation phase. Updated during active work.

> **Update Policy:** Update after each sub-task. Use for in-progress thoughts, decisions in flux, and reminders.

---

## Prior Notes (Phase 1 — Audit)

All Phase 1 audit tasks completed. See `tasks.md` for historical record.

---

## Phase 2 — Guardrail Implementation Notes

### Implementation Order
1. Task 1 + Task 5 → both target `copilot-instructions.md` — implement together
2. Task 2 + Task 4 → both target `AGENTS.md` — implement together
3. Task 3 → modify 3 skill files independently
4. Task 6 → cleanup, do last

### Design Notes
- The HALT pattern from `tooling-technology-recommendation/SKILL.md` is the proven model. It uses a mandatory invocation check with explicit STOP instructions. Replicate this pattern for sequencing enforcement.
- `copilot-instructions.md` is always loaded into context (workspace instructions). Keep it concise — every word costs context budget.
- `AGENTS.md` defines agent coordination. It should answer: "I have an RFP to review — what do I invoke and in what order?"
- Quality gate scope: "client-facing" = anything going to client, procurement, or executive sponsor. "Working draft" = internal iteration.

### Phase 2A Complete (prior session)
- All 20 sub-tasks done as of 2026-03-06

### Phase 2B Complete (2026-03-06)
- Task 7 (5 sub-tasks): Scope Boundary Protocol added to all 5 agent files
- Task 8 (4 sub-tasks): Section 5 Confidentiality added to copilot-instructions.md
- Task 9 (4 sub-tasks): Section 6 Context Efficiency added to copilot-instructions.md
- Total: 33/33 sub-tasks complete across all phases
- All 10 original guardrail gaps now addressed
- Next: git commit to `guardrails/phase-2-implementation` branch

### Phase 2C Complete (2026-03-06)
- Trigger-prompts evaluated as agentic AI evaluator — 5 structural issues identified
- 10 prompts run live against Libro Credit Union RFP — 10/10 guardrails passed
- 3 gaps found in trigger-prompts.md reference file (not in guardrails themselves)
- Task 11 (4 sub-tasks): fixes applied to trigger-prompts.md
  - 11.1: Input Validation Trigger 3 — added test condition qualifier
  - 11.2: Section 5 Confidentiality — added trigger/non-trigger prompts (zero coverage before)
  - 11.3: Domain contradiction case added to Domain Context Adaptation non-triggers
  - 11.4: Client Evaluator triggers — added vendor response precondition note
- Insights logged to insights.md (5 findings from live test)
- Total across all phases: 37/37 sub-tasks

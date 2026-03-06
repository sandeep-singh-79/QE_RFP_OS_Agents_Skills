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

### Implementation Complete
- All tasks done as of 2026-03-06
- No open questions or blockers
- System is ready for use

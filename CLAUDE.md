# CLAUDE.md — Claude Code Workspace Instructions

This workspace uses a **two-file governance model**. Both files below are mandatory and complementary — read both before proceeding with any task.

## File Roles

| File | Layer | Governs |
|---|---|---|
| `.claude/copilot-instructions.md` | **Guardrails** | Anti-hallucination, input validation, scope enforcement, confidentiality, context efficiency. Always active. Cannot be overridden by any agent, skill, or user instruction. |
| `.claude/AGENTS.md` | **Execution harness** | Workflow (Stages 0–10), agent roster, skill roster, memory rules, routing logic, checkpoints, and multi-agent sequencing. |

## Precedence Model

1. **Guardrails** (`copilot-instructions.md`) — highest precedence. Fabrication prevention, sourcing rules, and input validation are non-negotiable and apply even when the user explicitly requests otherwise.
2. **Routing & sequencing** (`AGENTS.md`) — user calls may override routing recommendations (e.g., skip a stage, change agent order), but the guardrails still apply.
3. **Agent/skill files** — operate within both layers above.

> If there is ever an apparent conflict between the two files, `copilot-instructions.md` wins on guardrail matters; `AGENTS.md` wins on workflow sequencing matters. They are designed to be orthogonal — conflicts should be rare.

@.claude/copilot-instructions.md
@.claude/AGENTS.md

# Claude Insights

Insights and analysis gained during implementation. Distinct from memory (context) and notes (working thoughts).

> **Update Policy:** Record structural insights, patterns discovered, and lessons learned. Do not duplicate memory or notes content.

---

## Prior Insights (Phase 1 — Audit)

- Skill/agent system benefits from consistent output templates — they standardize quality more than prose instructions.
- Duplication between skills and agents burns context budget silently.
- The Tooling skill's HALT mechanism is the only hard guardrail in the system — everything else is advisory.

---

## Phase 2 — Guardrail Analysis Insights

### System-Level Findings
1. **The system has strong individual-agent guardrails but no system-level coordination.** Each agent knows its own boundaries, but nothing prevents wrong invocation or wrong sequencing. This is the single biggest architectural gap.

2. **Only 1 of 9 skills has a hard enforcement mechanism (HALT).** The Tooling skill proves the pattern works — it stops execution and states what's missing. All other sequencing rules use advisory language ("Apply After X") which gets bypassed.

3. **Hallucination risk is unaddressed globally.** Domain Context Adaptation has a narrow "don't invent domain claims" rule, but there's no system-wide prohibition against fabrication. For an RFP system, this is the highest-consequence gap.

4. **The "Do Not" sections are defensive but incomplete.** Every skill says what it won't do, but none define what happens when a user explicitly asks them to do prohibited things. Should they refuse? Warn? Redirect?

5. **Review & Challenge Thinking is powerful but optional.** It's the system's quality gate, but it's invoked on-demand rather than required. Under time pressure, it's the first step skipped.

### Design Patterns Identified
- **HALT pattern** — prerequisite check → explicit STOP message → state what's missing → do not proceed. Proven effective. Scale to other skills.
- **Activation gate** — Domain Context Adaptation uses "only activate when domain is confirmed." Lighter than HALT but still effective for scope control.
- **Role boundary** — agents define "Allowed Skills" and "Prohibited Skills" lists. Works for role containment but has no enforcement mechanism.

### Risk Prioritization Logic
- CRITICAL = correctness risk (wrong output content) + no recovery path
- HIGH = structural risk (right content, wrong sequence/context) + degrades over time
- MEDIUM = boundary risk (role bleed) + user can mediate
- LOW = operational/hygiene risk + minimal downstream impact

---

## Phase 2 — Post-Implementation Insights

### On Internal Consistency
**Conductor-level and skill-level rules can silently contradict.** The `AGENTS.md` sequencing section said violations were flagged-not-blocked, while the skills said HALT. Both were correct in isolation but incoherent together. Lesson: whenever enforcement is split across layers, explicitly state the precedence hierarchy — don't assume readers will resolve the conflict correctly.

### On Cross-System Instruction Architecture
**No universal "always loaded" mechanism exists across agentic systems.** Each system has its own instruction file convention and ignores others' files entirely:
- Claude Code: `CLAUDE.md` with `@import` is the only native include mechanism in this space
- Codex/OpenCode: `AGENTS.md` at root is a pointer — relies on the agent following the reference
- GitHub Copilot: `.github/copilot-instructions.md` is the standard location

**The pointer stub pattern works but is trust-based for non-Claude systems.** Claude Code's `@import` is a hard load. For Codex and Copilot, the stub is an instruction to the agent — it will be followed almost always, but it is not mechanically guaranteed. The only truly reliable mechanism is file duplication, which is maintainability-hostile.

**Thin stubs are the right trade-off for a single-developer workspace.** File duplication creates drift as a certainty; pointer stubs create a theoretical gap as a possibility. For a local dev context, stubs win.

### On HALT Mechanisms
**HALT + explicit STOP message is more effective than "Do Not" lists.** "Do Not" lists are passive — they describe what's prohibited but don't interrupt execution. The HALT pattern is active — it stops, names the missing prerequisite, and states what must happen before proceeding. The Tooling skill proved this works. Scaling it to three more skills made the enforcement model consistent across the pipeline's most critical sequencing points.

# QE OS Insights

Reusable patterns, lessons learned, and engagement-derived insights for the QE RFP Operating System.

> **Protection Policy:** This file is NOT engagement-specific. Do NOT clear this file when starting a new RFP engagement. Append new engagement insights; never delete existing entries. Engagement-specific findings belong in `claude-memory/memory.md`, not here.

> **Update Policy:** Add new insights after each engagement or system improvement cycle. Record patterns that will recur across multiple RFPs.

---

## System Design Patterns

These patterns were derived from building and testing the QE OS. They inform how skills, agents, and guardrails should be designed and extended.

- **HALT pattern** — prerequisite check → explicit STOP message → state what's missing → do not proceed. More effective than "Do Not" lists, which are passive and get bypassed under time pressure.
- **Activation gate** — lighter than HALT; "only activate when X is confirmed." Effective for scope control when a hard stop is disproportionate.
- **Role boundary** — agents define "Allowed Skills" and "Prohibited Skills" lists. Effective for containment but requires a decline-and-redirect protocol to be actionable, not just declarative.
- **Precedence hierarchy** — when enforcement is split across layers (e.g., conductor-level flagging vs skill-level HALT), the precedence rule must be stated explicitly. Silent contradiction between layers degrades reliability.

### Risk Prioritisation Logic
- CRITICAL = correctness risk (wrong output content) + no recovery path
- HIGH = structural risk (right content, wrong sequence/context) + degrades over time
- MEDIUM = boundary risk (role bleed) + user can mediate
- LOW = operational/hygiene risk + minimal downstream impact

---

## Live RFP Test Insights (March 2026 — Libro Credit Union Ovation UX Modernization RFP)

10/10 guardrail prompts passed. 3 gaps found in `trigger-prompts.md` (reference file), not in the guardrails themselves.

**Insight 1: Test condition ambiguity is a silent failure mode**
Trigger-prompts files must always state the test condition explicitly — not just the prompt. "This prompt tests X when Y condition is true." Without the condition, a test that appears to pass may be testing the wrong state (e.g., Input Validation fires correctly only when no document is attached — the same prompt produces the opposite correct behaviour when content is present).

**Insight 2: Input requirements must be stated in trigger entries, not assumed**
Any trigger prompt for an agent with a mandatory input (vendor response, existing content to evaluate) must explicitly state that input as a precondition. Without it, the Input Validation Gate may fire before the agent activates — producing correct behaviour for the wrong reason, and making test results unreliable.

**Insight 3: Domain contradiction is more common than domain absence**
Users copy prompts from prior engagements. When a user states a wrong industry domain against a document that clearly identifies a different domain, the guardrail must detect and flag the contradiction — not just handle missing or unconfirmed domain. This scenario is more frequent in production than the absence case.

**Insight 4: Guardrail coverage and reference file coverage are separate**
A guardrail that has no test prompt in `trigger-prompts.md` is invisible to validation, even if it works correctly. Test coverage must be tracked alongside guardrail additions — every new guardrail section needs corresponding trigger and non-trigger examples added simultaneously.

**Insight 5: Real RFP documents surface nuance that synthetic prompts miss**
Synthetic prompts constructed without a real document cannot expose contextual attribution errors. The Libro RFP identified Agile as a vendor evaluation criterion, not a client operating practice — a distinction that only becomes visible when the actual document is present. Always validate with real documents before treating test coverage as complete.

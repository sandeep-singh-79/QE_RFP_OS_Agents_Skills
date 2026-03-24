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

## Cross-System Instruction Architecture

**No universal "always loaded" mechanism exists across agentic systems.** Each system has its own instruction file convention:

| System | File | Mechanism |
|---|---|---|
| Claude Code | `CLAUDE.md` (root) | Native `@<path>` include — hard loads canonical files |
| Codex / OpenCode | `AGENTS.md` (root) | Pointer stub — instructs agent to read canonical files |
| GitHub Copilot | `.github/copilot-instructions.md` | Pointer stub — instructs Copilot to read canonical files |

**Thin stubs are the right trade-off for a single-developer workspace.** File duplication creates drift as a certainty; pointer stubs create a theoretical gap as a possibility. Claude Code's `@<path>` is a mechanically guaranteed hard load. For Codex and Copilot, the stub is an instruction — followed almost always but not mechanically enforced.

**Rule:** Only ever edit `.claude/copilot-instructions.md` and `.claude/AGENTS.md`. The three pointer/stub files reference the canonical files and never need to change unless canonical file paths change.

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

---

## Phase 15 — Manulife Proposal Review Insights (March 23, 2026)

Derived from: IP-MAN-01 to IP-MAN-04 — gaps identified by ChatGPT 5.4 second-pass review of the Manulife 7-workstream QE proposal.

**Insight 6: AI classification ≠ AI execution positioning (IP-MAN-01)**
A Tier 1 / Tier 2 AI classification table governs *what to include and under what conditions* — it does not govern *how AI is positioned in the narrative*. Without an explicit instruction to frame Tier 1 capabilities as named delivery mechanisms with phase-activation points, the pipeline will always render AI as tooling additions or optional enhancements. Tooling framing scores in the technology catalogue; execution mechanism framing scores in delivery confidence and commercial defensibility. These are scored differently by procurement evaluators. The fix is not to strengthen the classification logic — it is to add a Stage 9 rule that forces the narrative framing to follow from the classification result.

**Insight 7: Estimation-layer gates and proposal-layer sections are independent — they require explicit wiring (IP-MAN-02, IP-MAN-03)**
A scope validator flagging a missing discipline (e.g., Integration Testing, RBAC) operates on the estimation layer. It does not automatically produce a named section in the proposal narrative layer. These are two independent actions — the validator confirms scope coverage for sizing purposes; the proposal section is what evaluators see and score. Without explicit wiring (a Stage 9 rule: "if Category X = Present → produce named subsection Y"), the discipline will be present in workstream bullets but absent as a named, evaluator-visible layer. Named sections score; buried workstream bullets do not. Every estimation-layer gate that confirms scope must have a corresponding proposal-layer section rule — they cannot rely on each other implicitly.

**Insight 8: Named sections and workstream bullets serve different evaluator functions (IP-MAN-02, IP-MAN-03)**
Evaluators reviewing a QE proposal do not read every workstream bullet. They scan for named sections that correspond to evaluation criteria: "API testing", "RBAC validation", "integration testing model", "security controls". If the discipline is embedded only in workstream bullets, it is invisible to this scan. Named sections are evaluable artefacts; workstream bullets are implementation detail. Any discipline that will be scored independently — integration testing, RBAC, performance testing, data integrity — must appear as a named section regardless of how thoroughly it is covered in workstream content. This is a structural principle, not a content length principle.

**Insight 9: Phase 0 deliverable lists and Phase 0 exit criteria are structurally different — both are required (IP-MAN-04)**
A deliverable list answers: "what will be produced during Phase 0?" Exit criteria answer: "what conditions must all be true before Phase 1 can begin?" A deliverable list is an activity checklist; exit criteria are a readiness gate. Proposals that include only deliverable lists imply that Phase 1 start is schedule-driven — the calendar date triggers the transition, not a confirmed readiness state. Governance-oriented evaluators will flag this as a delivery risk. Both are required: the deliverable list for scope transparency, the exit criteria table for delivery confidence. Exit criteria must be verifiable (named condition + how it is confirmed) and must include an escalation statement — unsatisfied conditions at Phase 0 close are not silently carried forward.

---

## Phase 16 — GPT-5.4 Third-Pass Review Insights (March 23, 2026)

Derived from: IP-MAN-05 to IP-MAN-08 — gaps identified by ChatGPT 5.4 third-pass review of the Manulife 7-workstream QE proposal. These insights address governance accountability, environmental risk framing, baseline specificity, and the principle of specificity over abstraction in risk communication.

**Insight 10: Distributed accountability ≠ named accountability — procurement rubrics require a single consolidated owner statement (IP-MAN-05)**
A RACI table that distributes accountability across multiple activity rows is not the same as a single named accountability statement for delivery risk. Procurement evaluators applying a governance rubric often look explicitly for a "single accountable risk owner" — and a RACI table does not satisfy this expectation even if it covers the same ground indirectly. The fix is not to restructure the RACI — it is to add a named delivery risk ownership paragraph that consolidates the monitoring function into a single named role. Both the RACI and the ownership statement serve different evaluator needs: the RACI maps activity accountability across roles; the ownership statement answers the single-owner governance question directly. For multi-workstream engagements, always include both.

**Insight 11: Physical constraints (environment capacity) require explicit naming even when governance mechanisms are in place (IP-MAN-06)**
A governance framework and escalation path do not implicitly address environment capacity contention — they address decision-making when contention occurs. The constraint itself ("multiple concurrent workstreams may exceed available environment capacity") must be explicitly named before the governance mechanism is referenced as the resolution path. An evaluator who sees only the governance framework without the named constraint will not know what problem it is solving. Physical execution constraints and governance responses are separate statements — both must appear. For any engagement with 3+ simultaneous Tier A workstreams, name the environment capacity constraint before describing the coordination mechanism.

**Insight 12: Verifiable conditions require measurable definitions — not just condition labels (IP-MAN-07)**
A Phase 0 exit criterion stating "coverage baseline established" sounds verifiable but is not — it provides no shared definition of what constitutes a baseline. Both delivery teams and evaluators need to know exactly what will be measured and reported for the condition to be confirmed as met: automation coverage % per workstream, critical path completeness (pass/fail), and regression suite readiness level. Every exit criterion in a governance gate must specify the unit of measurement, not just the domain of measurement. This principle extends to all Phase 0 conditions: "test strategy approved" must specify what approval means (which stakeholders, what format); "environment readiness validated" must specify the validated dimensions.

**Insight 13: Specificity outperforms abstraction for risk communication — never add generic governance narratives over specific per-entry registers (IP-MAN-08)**
When a structured register with per-entry consequences already exists (e.g., a dependency register with "Impact if Missed" per row), adding a generic governance narrative for the same risk domain reduces, not increases, evaluator confidence. The register provides specific, traceable, reviewable accountability per dependency; the narrative provides abstract protocol language that adds no new information. The principle: when a specific, structured mechanism already covers a risk domain more precisely than prose can, adding prose overhead is negative ROI. The correct improvement when prose coverage seems thin is to strengthen the cross-reference from the prose narrative to the register — not to add redundant abstraction.

---

## Phase 17 — Post-Phase 16 Critical Re-evaluation Insights (March 24, 2026)

Derived from: IP-MAN-09 to IP-MAN-15 — seven new OS-layer gaps identified by full 4-lens critical review of the Manulife 7-workstream proposal after Phase 16 inserts. These insights address submission hygiene, accountability claim co-location, relative vs. absolute dating, gate threshold completeness, cross-section headcount coherence, joint governance participation accountability, and scope reconciliation.

**Insight 14: Role designations must replace personal names in any section a procurement panel will read (IP-MAN-09)**
Internal staff first names in open conditions, risk register entries, or governance sections expose internal org structure and signal unprofessional output to enterprise procurement panels. The fix is a submission hygiene rule applied at Stage 9 output time — not a recall at review time. Every role reference in client-facing sections must use a formal role designation (e.g., "R Systems Presales Lead", "R Systems QA Practice Lead"), not a first name or informal handle. This is a non-negotiable output format rule for competitive RFP submissions.

**Insight 15: An accountability claim and its disclosure must appear in the same section — not 12 sections apart (IP-MAN-10)**
When a proposal names a role as the single accountable owner in Section 11, but discloses that this role is unconfirmed in Section 17, an evaluator reading linearly will not make the connection. The accountability claim and its caveat must be co-located — not merely both present somewhere in the document. This is the co-location principle for disclosure: every named commitment that carries a material caveat or open condition must surface that caveat at the point of the commitment, not in a segregated risk or dependency section. Distance between claim and caveat is the same as silence.

**Insight 16: Phase 0 kick-off dates in competitive proposals must be relative to award, never absolute (IP-MAN-11)**
An absolute calendar date for Phase 0 kick-off in an unawarded competitive submission is always wrong — it assumes award timing that cannot be known. When the absolute date is also the anchor for a downstream milestone chain (functional clear → soak → NFR → tranche close), the error propagates through every dependent date. The only correct form is relative: "[Award + N business days]." This rule applies regardless of how realistic the assumed date seems at time of writing. Award timing is a client-controlled variable; every date below it in the cascade must acknowledge this.

**Insight 17: Specifying what is measured is necessary but not sufficient — every gate condition requires a pass/fail threshold (IP-MAN-12)**
IP-MAN-07 (Insight 12) established that exit criteria must specify what is measured. Phase 17 reveals the next gap: knowing what is measured without knowing the pass/fail threshold means the condition can be satisfied at zero — as long as the zero is documented. A gate without a threshold is a reporting activity. The upgrade from "documenting automation coverage %" to "Phase 0 cannot exit if any Tier A workstream records 'not ready' without a Manulife-approved recovery plan" converts a measurement condition into a governance gate. Every named exit criterion must specify: (1) what is measured, (2) who measures it, and (3) the condition under which the criterion passes or blocks.

**Insight 18: Named sub-pools in the Risk Register create an implicit promise — Team Structure must honour it (IP-MAN-13)**
When a Risk Register entry names a dedicated resource pool for a specific workstream ("dedicated SDET team for WS-7, separate from primary resourcing"), that commitment implicitly redefines the total headcount. If Section 12 shows only the primary pool, the proposal presents two internally inconsistent headcount figures — a smaller one visible to evaluators scoring Team Structure and a larger one buried in Risk. The principle: every resource commitment in the Risk Register must be reflected in the Team Structure headcount summary. The Risk Register and Team Structure sections must cohere — their combined commitment is what R Systems is actually proposing.

**Insight 19: Joint governance requires a named client-side participant and a dependency entry — otherwise it is a unilateral commitment (IP-MAN-14)**
A governance forum described as "comprising leads from both organisations" is not joint governance — it is a vendor-side structure hoping for client attendance. Joint governance has two required properties: (1) the client-side participant is named by role, and (2) the client's participation is tracked as a dependency with a Phase 0 confirmation date. Without both, the forum exists in narrative only. This principle extends to all joint governance structures: steering committees, quality review boards, joint escalation paths. The word "joint" requires at least one named client-side role and at least one corresponding dependency.

**Insight 20: Component counts and application counts are different layers — when both appear, reconcile them at the point of divergence (IP-MAN-15)**
In complex multi-workstream proposals, effort estimation is scoped at "application" level (e.g., 41 applications) while architectural breakdown uses "component" level (e.g., 199 microservices). Both figures are correct for their respective purposes, but placed in different sections of the same proposal without a linking sentence, they create evaluator ambiguity about the estimation basis. The fix is a single reconciliation sentence placed at the point the component count first appears: "[N] components represent the full decomposition of the [M] in-scope applications; effort was sized at workstream level against this component surface." Two sentences. Zero ambiguity. The principle: whenever a detailed breakdown figure differs from the estimation baseline figure by more than 2×, a reconciliation is mandatory.

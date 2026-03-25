---
name: review-challenge-thinking
description: Critically evaluate QA proposal outputs, RFP responses, strategies, and roadmaps to identify gaps, over-commitments, weak assumptions, missing ownership, and defensibility risks before they reach client or leadership audiences. Use as a pre-submission quality gate on any content that will face external or executive scrutiny. Trigger on final RFP review, QA strategy validation, roadmap review, or any output described as needing a 'sense check', 'challenge', or 'review'. This skill strengthens credibility without redesigning solutions.
---

# Skill: Review & Challenge Thinking

## Purpose
Critically evaluate outputs to identify gaps, risks, over-commitments, and weak assumptions — so that nothing reaches a client or leadership audience that cannot be defended.

Optimism bias is the most dangerous force in pre-sales QA work. Claims that feel reasonable when written will be challenged in scoring. This skill stress-tests content before that happens.

---

## Mandatory Gate — This Skill Is Not Optional for Client-Facing Outputs

**This skill is the final quality gate for all client-facing and executive-facing outputs.**

An output is client-facing if it will be submitted to a client, presented to procurement, shared with executive sponsors, or included in any document external to the delivery team. For these outputs, this skill is not optional and must run before delivery.

If this skill is not applied to a client-facing output:
- State explicitly in the output: *"[QUALITY GATE NOT APPLIED — this output has not been challenged for gaps, over-commitments, or defensibility risks. Apply Review & Challenge Thinking before client delivery.]"*
- Do not present the output as submission-ready

**For working drafts** (internal team review only): this skill is recommended but not required.

### Output Type Classification Default

If the content being reviewed does not include an `Output Type:` header, classify it as `Client Facing` by default.

**Rationale:** The conservative default prevents working-draft content from accidentally bypassing the quality gate review. If the submitter intended a working draft classification, they must state it explicitly. This skill must not assume lighter-weight treatment without explicit confirmation.

---

## Apply All Four Lenses — Do Not Skip Any

### 1. Stakeholder Challenge Lens
Evaluate from the perspective of the people who will actually read and score this:

- **Client evaluators** — "How will a skeptical procurement panel challenge this specific claim?"
- **Delivery / QA Managers** — "Can this realistically be executed with real teams and real constraints?"
- **Leadership / Steering Committee** — "Is this credible, controlled, and low-risk enough to sponsor?"

### 2. Over-Commitment Detection
Actively search for:
- Aggressive or unqualified timelines
- Implicit maturity assumptions — treating the client as more capable than stated
- Hidden or unacknowledged enablement effort
- Optimistic adoption expectations without a named transition path
- Statements that imply certainty without validation evidence

### 3. Ownership & Accountability Check
Identify every place where:
- Actions are proposed but owners are not assigned
- Responsibilities are implicitly assumed rather than stated
- Client-controlled dependencies are treated as if the vendor controls them
- Accountability is diffused across teams without a clear lead

### 4. Logical & Structural Coherence
Validate that:
- Conclusions are supported by the inputs actually provided
- No contradictions exist between sections
- Priorities stated in one section are consistent with risk levels in another
- Claims are internally consistent across the full document

---

## When Lenses Conflict — Resolution Rules

Different lenses may identify contradictory concerns. Apply these resolution rules:

1. **Stakeholder vs. Over-Commitment:** If the Stakeholder lens says a claim is credible but the Over-Commitment lens flags it as undeliverable, defer to Over-Commitment — credibility collapses during execution.

2. **Ownership vs. Logical Coherence:** If content is logically sound but ownership is unclear, flag as an Evidence gap (not Strategic) — the logic stands but the execution path is incomplete.

3. **Over-Commitment vs. Logical Coherence:** If optimistic commitments are internally consistent but unrealistic, classify as Execution gap — internal consistency does not override feasibility.

4. **Multiple High-Severity Findings:** When multiple lenses identify different Strategic gaps in the same content, list all findings under Strategic and note the compounding risk explicitly.

When in doubt, prioritize execution risk over presentation risk — a well-written undeliverable plan is worse than a poorly-written achievable one.

---

## Classify Every Finding — Then Act on the Classification

| Gap Type | Definition | What to Do |
|----------|-----------|------------|
| **Strategic gap** | The approach or scope itself is questionable | Escalate — this requires a rethink, not a polish |
| **Execution gap** | The plan is unlikely achievable as stated | Flag clearly — this will surface during delivery |
| **Evidence gap** | A claim needs validation or confirmation before it can stand | Mark as requiring sign-off before submission |
| **Presentation gap** | Content is correct but poorly communicated | Note for revision — lower urgency than the above |

Organise findings by gap type first, then by impact within each type. A Strategic gap in a minor section still outranks a Presentation gap in a major section.

### Required Actions for Each Gap Type

Apply these actions based on gap classification:

| Gap Type | Required Action |
|----------|-----------------|
| **Strategic gap** | **ESCALATE** — Requires fundamental rethink before submission; cannot be fixed with polish alone. Block submission until approach is validated. |
| **Execution gap** | **FLAG CLEARLY** — Will create delivery risk if unaddressed; needs stakeholder acknowledgment and acceptance or mitigation plan. |
| **Evidence gap** | **BLOCK SUBMISSION** — Requires client confirmation, validation, or additional supporting evidence before proceeding. Do not submit without resolution. |
| **Presentation gap** | **REVISE** — Fix formatting, clarity, or communication before submission, but lower urgency than above three types. |

**Prioritization rule:** Organize all findings by gap type first (Strategic → Execution → Evidence → Presentation), then by impact within each type. Do not mix gap types in priority order.

---

## Output Expectations

For every finding, state:
- The gap type
- What specific content triggered it
- Why it is a concern and what risk it creates if unaddressed

Do not rewrite content unless explicitly asked. Diagnosis is the output, not correction.

---

## Do Not

- Redesign solutions or propose alternative approaches
- Reprioritise strategy
- Rewrite or restructure content
- Change tone, domain framing, or risk levels

---

## Output Confidence Scoring

Before the quality gate clears, declare a confidence level for each major output section reviewed. Confidence reflects how well the section can withstand scrutiny — not how well it was written.

| Confidence | Meaning |
|---|---|
| `High` | All four lenses applied; no Strategic or Execution gaps found; evidence-backed throughout |
| `Medium` | Minor gaps found (Presentation or Evidence type); addressed or explicitly accepted by the team |
| `Low` | One or more Strategic or Execution gaps found; submission risk remains until resolved |

**Format:**
```
Section Confidence Scores:
- Strategy: [High / Medium / Low] — [one-line rationale]
- Estimation: [High / Medium / Low] — [one-line rationale]
- KPIs: [High / Medium / Low] — [one-line rationale]
- Risk: [High / Medium / Low] — [one-line rationale]
- Assumptions: [High / Medium / Low] — [one-line rationale]
```

If any section is not present in the output, declare: `[Section]: Not Present — ⚠ INCOMPLETE SECTION`.

If any section scores `Low`, the output must not be classified as submission-ready until the finding is resolved or explicitly accepted.

### Gate Verdict

After section scores are assigned, declare an overall gate verdict:

| Verdict | Condition | Stage 9 Impact |
|---|---|---|
| `Ready` | All sections scored High | Stage 9 may proceed |
| `Conditional` | Any section scored Medium, none scored Low | Stage 9 may proceed — flagged items must be acknowledged |
| `Not Ready` | Any section scored Low | Stage 9 blocked until Low-scored sections are resolved or explicitly accepted |

**Format:**
```
Gate Verdict: [Ready / Conditional / Not Ready]
Rationale: [one-line summary of what drives the verdict]
```

The gate verdict is a mandatory structured output. If omitted, the quality gate has not been correctly applied.

---

## Completeness Checklist

Run this checklist before declaring the quality gate passed. Any criterion not met must be flagged `⚠ INCOMPLETE SECTION`:

| Section | Minimum Completeness Criteria | Pass / ⚠ INCOMPLETE SECTION |
|---|---|---|
| Strategy | Governance model present AND metrics framework stated | |
| Estimation | Effort figures present AND assumptions declared | |
| KPIs | Client targets addressed OR `⚠ NO CLIENT KPI TARGETS FOUND` flag explicitly present | |
| Risk | Risk register entries present OR risk narrative with named risks present | |
| Assumptions | All assumptions surfaced AND each has an owner and resolution path | |
| Submission Hygiene | No internal staff first names in client-facing sections (OC, Risk Register, Dependency Register, Team Structure, Governance, Delivery Risk Ownership) — role designations only | Pass / ⚠ HYGIENE VIOLATION |

**Rule:** Do not mark the checklist as passed speculatively. Each criterion must be verified in the actual output content before being marked Pass.
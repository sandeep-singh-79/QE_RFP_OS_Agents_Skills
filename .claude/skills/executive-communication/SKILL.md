---
name: executive-communication
description: Transform detailed QA analysis, risk findings, and proposal content into executive-ready communication — clear, concise, decision-oriented, and free from technical noise. Use whenever outputs are destined for CIO, CTO, steering committee, executive sponsor, or senior procurement stakeholders. Trigger on any request for executive summary, leadership update, sponsor-facing content, or board-level justification.
---

# Skill: Executive Communication

## Purpose
Communicate information to senior stakeholders with clarity, confidence, and decision relevance — so they can act quickly without needing to interpret technical content.

Executives do not have time to translate findings into implications. If the implication is not stated first, the message is lost. This skill ensures every output leads with what matters and cuts everything else.

---

## Prerequisite Check — STOP If Conditions Are Not Met

Before producing any executive-facing output, perform this mandatory check:

1. **Has Outcome & Risk Framing run?**
   - Check: Are findings framed with business impact, urgency, and decision ownership?
   - If NO: State — *"Executive Communication cannot run. Outcome & Risk Framing must be applied first to frame findings in business terms."* Then HALT.

2. **Has Structuring & Consulting Thinking run?**
   - Check: Is the content organized into a prioritized hierarchy with a clear narrative flow?
   - If NO: State — *"Executive Communication cannot run. Structuring & Consulting Thinking must be applied first to create a scannable hierarchy."* Then HALT.

3. **Has Domain & Context Adaptation run (where domain is confirmed)?**
   - Check: If a client domain was provided, has vocabulary been aligned?
   - If domain was provided and adaptation has NOT run: State — *"Domain & Context Adaptation has not been applied. Proceed only if domain alignment is not required for this output."* Flag, but do not halt.

**If checks 1 or 2 fail, do not proceed.** This skill only changes presentation — it cannot compensate for missing risk framing or unstructured content. Applying it prematurely produces polished but hollow output.

Do not use this skill to alter logic, priorities, or decisions — only presentation changes at this stage.

---


## Illustrative Pattern — Apply This Transformation

Use this as a calibration reference for tone and structure:

**Before (not executive-ready):**
> Regression coverage is inconsistent across applications, leading to delayed feedback cycles and increased defect leakage during UAT.

**After (executive-ready):**
> Inconsistent regression coverage is reducing release confidence and increasing late-stage risk.
> Alignment is required on standardising regression scope before upcoming releases.

The "after" version leads with impact, states the implication directly, and ends with a clear ask. Apply this pattern to every finding or message.

---

## The Executive Decision Test

Before writing anything, confirm the output clearly answers all three questions:
1. What is the situation or finding?
2. Why does it matter to delivery or the business?
3. What decision, alignment, or acknowledgement is required?

Remove any content that does not support one of these three questions.

---

## Structure Every Message This Way

1. **Headline** — the conclusion or key message, stated first
2. **Implication** — the business or delivery impact
3. **Context** — only if strictly required to support the decision

Details never precede conclusions. Supporting material belongs in an appendix.

---

## What to Keep and What to Cut

**Keep:**
- Outcomes and consequences
- Risks and implications
- Trade-offs requiring a decision
- Actions or alignment required

**Cut or defer to appendix:**
- Technical depth and implementation steps
- Tool and framework names (unless they directly drive risk or cost decisions)
- Background narrative and process explanation
- Internal QA terminology

---

## Language and Tone

Write with:
- Business-oriented language — minimise technical terminology
- Assertive, confident framing — avoid hedging or apology
- Neutral, composed tone — not defensive, not excitable
- Widely understood acronyms only (e.g., UAT, CI/CD are acceptable)

Avoid softening language unless context explicitly requires it.

---

## Length Rules

- Maximum 3–5 bullets per section
- Maximum 1–2 lines per bullet
- No paragraphs in executive sections

If content cannot fit within these limits, restructure — do not expand.

---

## Executive Readiness Checklist

**When to apply this checklist:** Run immediately before finalizing any executive-facing output. This is your pre-submission quality gate — not an optional review. Apply after all content and structure decisions are complete.

Run this check before finalising any executive-facing output:

- [ ] Key message understood in under 30 seconds?
- [ ] Main takeaway visible without reading detail?
- [ ] Decision or expectation clearly stated?
- [ ] Technical explanations removed or deferred?
- [ ] Tone sounds confident and composed?
- [ ] No more than 3–5 bullets per section?

If any answer is "no", revise before delivering.

---

## Assumption Preservation Guardrail

`[ASSUMPTION: ...]` labels declared in input content must **never** be removed during this skill's execution.

**Allowed transformations:**
- Reordering assumption statements within the output structure
- Summarising surrounding content to improve clarity or length
- Polishing language of non-assumption content

**Prohibited transformation:**
- Removing or omitting `[ASSUMPTION: ...]` labels — regardless of context, length constraints, or editorial judgment

Assumption markers are governance signals, not stylistic elements. Removing them breaks traceability enforced at Stage 8 and may cause assumptions to slip into client-facing outputs without declaration.

---

## Do Not

- Change priorities or risk levels set by other skills
- Restructure information or alter logic
- Introduce domain assumptions
- Modify decisions made by other agents or skills
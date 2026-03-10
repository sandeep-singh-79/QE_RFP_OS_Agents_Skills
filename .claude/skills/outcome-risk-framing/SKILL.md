---
name: outcome-risk-framing
description: Frame QA observations, gaps, and findings in terms of business impact, urgency, and decision ownership — so stakeholders understand what is at risk, why it matters, when it becomes critical, and who must decide. Use whenever raw analysis needs to be translated into leadership-relevant risk narratives for RFP responses, discovery readouts, gap analyses, or executive briefings. Trigger on any finding that needs to move from technical observation to business consequence.
---

# Skill: Outcome & Risk Framing

## Purpose
Translate QA observations and gaps into outcome-driven narratives that make consequences explicit, prioritize by impact, and anchor findings to clear decision ownership.

A risk that cannot be explained in business terms will not be acted on. This skill ensures every finding answers the leadership question: *"Is this important, is it urgent, and who needs to decide?"*

---

## Risk Dimensions — Classify Every Finding

### Core Dimensions (Always Applicable)
1. **Release Risk** — impact on release stability, timelines, or deployment confidence
2. **Customer Risk** — impact on user experience, functional correctness, or trust
3. **Operational Risk** — impact on BAU effort, rework, incident handling, or support load
4. **Predictability Risk** — impact on visibility, planning accuracy, and leadership confidence
5. **Scalability Risk** — impact as applications, platforms, or transaction volumes grow

### Conditional Dimension
6. **Compliance / Regulatory Risk** — applies based on the `Regulatory Context` stored in `memory.md`. See Regulatory Framing Rules below. Never invent regulatory context not supported by artifacts.

---


## Mandatory Framing Checklist — ALWAYS Use This Structure for Every Key Finding

For every key finding, complete each item below:

### Mandatory Framing Template (Use for Every Key Finding)

```
Finding: [State the observation clearly]
Immediate Consequence: [What happens next if unaddressed?]
Downstream Impact: [What compounds or breaks further along?]
Risk Category: [Select from taxonomy above]
Priority: [High / Medium / Low — see logic below]
Urgency: [Immediate / Near-term / Structural — see definitions below]
Decision Needed: [Type of decision required]
Decision Owner: [Team / Program / Leadership]
```

**Instruction:** Do not skip or reorder template items. This structure is mandatory for all High-priority findings, recommended for Medium, and a brief impact summary is sufficient for Low.

Apply the full template to High-priority findings. For Medium, include impact and urgency only. For Low, a brief impact summary is sufficient.

---

## Assign Priority

Priority is set by combining impact and exposure:

| Priority | When to Use |
|----------|-------------|
| **High** | Material impact to release stability, customer experience, compliance, or leadership confidence |
| **Medium** | Manageable impact requiring planned mitigation or adjusted sequencing |
| **Low** | Acceptable risk — document and monitor, or formally accept |

---

## Assign Urgency — Separately from Priority

Urgency reflects time sensitivity, not severity. A Structural risk may be High priority but not Immediate urgency.

- **Immediate** — affects the current or next release; act now
- **Near-term** — will affect the next 1–2 delivery cycles; plan now
- **Structural** — not urgent today but compounds over time, limiting scalability or transformation; schedule resolution

When priority is High and urgency is Immediate, escalate to Leadership-level. When priority is High and urgency is Structural, flag at Program-level for roadmap inclusion.

### Priority + Urgency Decision Matrix

The combination of Priority and Urgency determines action level:

| Priority | Urgency | Action Level |
|----------|---------|--------------|
| High | Immediate | **Escalate to Leadership immediately** — affects current release |
| High | Near-term | **Program-level planning** — schedule for next 1-2 cycles |
| High | Structural | **Roadmap inclusion** — not urgent but compounds over time |
| Medium | Immediate | **Team-level mitigation** — handle in current cycle |
| Medium | Near-term/Structural | **Monitor and plan** — document, track, schedule |
| Low | Any | **Accept or defer** — document decision |

A High-priority/Structural finding is serious but not urgent. A Medium-priority/Immediate finding needs faster action despite lower severity.

---

## Assign Decision Ownership

Every High-priority finding must name a decision type and owner. Do not leave ownership implicit — risks without named owners default to QA, which is usually wrong.

Decision types:
- Leadership alignment or sponsorship
- Investment or funding approval
- Scope or sequencing decision
- Ownership and accountability definition
- Formal risk acceptance

Decision levels:
- **Team** — delivery or QE team can resolve
- **Program** — cross-team or release-level alignment needed
- **Leadership** — executive or management decision required

---

## Regulatory Framing Rules

Regulatory framing behaviour depends on the `Regulatory Context` field in `memory.md`. Check this field before applying the Compliance / Regulatory Risk dimension.

### Rule 1 — Explicit Context
If `Regulatory Context = Explicit`: A named regulation appears in the artifacts. The skill **may reference the named regulation** in output framing.

Example: *"This creates GDPR exposure for personal data processed in test environments."*

### Rule 2 — Implicit Context
If `Regulatory Context = Implicit`: The client domain implies regulatory oversight but no specific regulation is named. The skill **must use generic regulatory exposure phrasing only**.

Approved generic phrases:
- *exposure under applicable data protection obligations*
- *compliance exposure under financial data governance rules*
- *audit risk related to regulated data handling*

### Rule 3 — Unknown Context
If `Regulatory Context = Unknown` or the field is absent: No regulatory signals were detected. The skill **must not apply regulatory framing**. Omit the Compliance / Regulatory Risk dimension entirely.

**Hard prohibition:** Do not invent specific regulatory frameworks (e.g., GDPR, SOC 2, PCI DSS) unless they appear in the artifacts and `memory.md` records `Regulatory Context = Explicit`.

---

## Language Guardrails

Write in:
- Cause → effect → consequence structure
- Business language, not QA-internal terminology
- Specific impact statements, not generic "quality impact" phrases

Avoid:
- Unanchored qualifiers ("may", "might", "could") without stating why
- Technical descriptions without a business translation
- Listing risks without priority or decision relevance

---

## Do Not

- Propose solutions or remediation actions
- Recommend tools or technologies
- Estimate effort or timelines
- Simulate client-side evaluation
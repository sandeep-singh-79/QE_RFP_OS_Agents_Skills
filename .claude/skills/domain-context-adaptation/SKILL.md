---
name: domain-context-adaptation
description: Adapt language and framing of QA proposal outputs to align with a client's industry context, vocabulary, and business sensibilities — without altering architecture, logic, risk prioritization, or making unverified domain claims. Use this skill when a client's industry is explicitly known and confirmed, and outputs need to resonate with domain-specific stakeholders. Do not activate unless domain context has been explicitly provided.
---

# Skill: Domain & Context Adaptation

## Purpose
Adapt language and framing so outputs align with the client's industry context and business sensibilities, while remaining defensible, assumption-aware, and free from subject-matter overreach.

This skill improves resonance without altering architecture, logic, or risk prioritization. The goal is for the client to feel recognised — not for the proposal to simulate domain expertise it does not have.

---

## ⚠️ Activation Gate — Read This First

**Only activate this skill when domain context is explicitly known or confirmed by the user or provided context.**

If domain is assumed or inferred, do not adapt — state that domain context is needed before adaptation can proceed. Adapting without confirmed context risks making claims the proposal cannot stand behind.

---

## ⏱️ Sequencing Check — STOP If Conditions Are Not Met

**CRITICAL:** Domain adaptation must run AFTER substantive analysis is complete.

Before adapting any content, perform this mandatory check:

1. **Has QE Architect Thinking run?**
   - Check: Are capability requirements, architecture layers, and technical recommendations already defined?
   - If NO: State — *"Domain & Context Adaptation cannot run. QE Architect Thinking must define the technical substance first. Adapting before architecture contaminates analysis with unverified domain assumptions."* Then HALT.

2. **Has Outcome & Risk Framing run?**
   - Check: Are findings framed with business impact and decision ownership?
   - If NO: State — *"Domain & Context Adaptation cannot run. Outcome & Risk Framing must be applied first. Adapting before risk framing risks shifting the emphasis of findings based on domain assumptions."* Then HALT.

3. **Has Structuring & Consulting Thinking run?**
   - Check: Is content organized into a prioritized hierarchy?
   - If NO: State — *"Domain & Context Adaptation cannot run. Structuring & Consulting Thinking must run first. Adapting unstructured content risks embedding domain vocabulary in the wrong places."* Then HALT.

**If any check fails, do not proceed.** Domain adaptation only changes language and emphasis — it cannot build or fix missing architecture, risk framing, or structure.

---

## Domain Adaptation Intensity

Apply domain adaptation at an appropriate level based on context:

- **Light:** Replace 2-3 generic terms with domain vocabulary; minimal emphasis changes. Use when domain context is confirmed but industry-specific concerns are not central to the proposal.

- **Moderate (Default):** Systematic vocabulary alignment + highlight 2-3 domain-relevant concerns. Use for most RFP responses where industry context matters but deep domain immersion is not required.

- **High:** Deep vocabulary integration + regulated overlay + extensive concern emphasis. Use only when explicitly requested or when the proposal addresses highly regulated, audit-driven, or compliance-critical environments.

**When in doubt, use Moderate.** Excessive adaptation risks claiming expertise you don't have; insufficient adaptation makes outputs feel generic and disconnected from client reality.

---

### 1. Align Vocabulary
Substitute generic terms with commonly understood industry language. Examples:
- users → customers / members / subscribers / policyholders
- defects → customer-impacting issues
- production → live environment

Do not imply specific internal workflows or proprietary systems that have not been confirmed.

### 2. Emphasize Domain-Relevant Concerns
Highlight themes the client cares about — do not invent new concerns, only bring relevant ones forward:
- Stability and customer trust
- Availability and reliability
- Auditability and control
- Customer experience continuity

### 3. Keep Examples Generic and Safe
Use illustrative framing only:
- "for example, in customer-facing journeys"
- "in critical business flows"

Never name real client processes unless explicitly provided.

---

## Regulated Industries — Conditional Overlay

Apply only when explicitly requested or clearly relevant (BFSI, Insurance, Healthcare, Government).

When activated, acknowledge regulatory sensitivity at a high level only:
- Reference *types* of regulatory expectations — not specific regulations
- Reference *categories* of metrics or KPIs — not values
- Reference *benchmark themes* — not numbers
- Flag areas requiring validation or confirmation

Safe phrasing:
- "subject to applicable regulatory expectations"
- "metrics typically tracked in such environments may include…"
- "benchmark alignment would require client validation"

---

## Mandatory Guardrails

Do not:
- Assume specific regulations or standards apply
- Quote regulatory clauses or benchmark values
- Invent KPIs or thresholds
- Claim compliance or certification on behalf of the vendor
- Imply operational or regulatory ownership

All regulatory, metric, or benchmark references must remain indicative and non-committal.

---

## Explicit Exclusions

Do not:
- Define regulatory requirements or compliance scope
- Establish benchmarks or KPI targets
- Recommend tools or technologies
- Simulate deep domain expertise
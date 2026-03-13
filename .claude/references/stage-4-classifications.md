# Stage 4 — Classification Reference

> **Used by:** Test Architect at Stage 4 — Solution Design; Stage 9 Section 9 (tooling table column labelling and AI tier column).
> Load this file when AI Capability Tier Classification, Tooling Three-Tier Framing, Benefit Realisability Classification, Risk-Based Test Classification, or Application Clustering Draft is required. Contains the full procedure, values, formats, and rules for each.

---

## AI Capability Tier Classification

**When:** Mandatory at Stage 4. Classify every proposed AI or GenAI capability before assigning a roadmap phase. Classification determines whether OC-1 applies (see `governance.md`).

### Classification table

| Tier | Definition | Phase Viability | OC-1 Applies? |
|---|---|---|---|
| Tier 1 — AI-assisted process tools | Rule-based or LLM-prompt-based; no specialist ML infrastructure; available as SaaS or IDE extension (e.g., AI-assisted test case generation, story readiness checkers, LLM-based defect summarisation, coverage gap analysis) | Phase 2 onwards | **No** — Tier 1 tools are not subject to OC-1 deferral |
| Tier 2 — AI/ML predictive models | Requires training data, specialist ML resourcing, or ML infrastructure (e.g., self-healing test, predictive defect trending, autonomous test orchestration) | Phase 3–4 | **Yes** — OC-1 applies; defer confirmation to Phase 0 |

### Rule
Classification is mandatory — unclassified AI capabilities must not be assigned a phase.

OC-1 definition, scope, trigger, exclusion note, and Stage 9 Appendix format: see `## OC-1` in `.claude/governance.md`.

---

## Tooling Three-Tier Framing

**When:** Mandatory at Stage 4 and Stage 9. The blanket "defer all tooling decisions to Phase 0" rule is replaced by this model — Confirmed tools are named without deferral.

### Tier table

| Tier | Definition | Output Framing |
|---|---|---|
| Confirmed | Tool identified in Stage 1 findings as currently in use by the client | Listed without caveat — state as "currently in use" |
| Suggested | New-capability tool not currently in the client stack | "Suggested — subject to Phase 0 confirmation" |
| Proposed — Vendor Platform | Tool from Vendor Capability Manifest | "Proposed — subject to Phase 0 assessment" |

### Rule
Stage 9 tooling tables (Section 9) must display the tier label (Confirmed / Suggested / Proposed) alongside tool name and rationale. The `AI Tier` column in Section 9 uses the Tier 1 / Tier 2 classification from `## AI Capability Tier Classification` above.

---

## Benefit Realisability Classification

**When:** Mandatory at Stage 4 — applies to every benefit claim proposed by the Test Architect.

### Classification values

| Category | Definition | Example |
|---|---|---|
| `Unconditional` | Governance or practice change; no infrastructure or tooling dependency | Defect triage process adoption, mandatory stage gates, shift-left discipline |
| `Conditional — Client Infrastructure` | Requires CI/CD, environment, or tooling that the client controls | Shift-left automation requiring client CI/CD pipeline; environment-on-demand requiring client cloud provisioning |
| `Conditional — Vendor Delivery` | Requires vendor tool deployment or platform readiness before the benefit can be realised | GenAI-assisted test case generation via vendor platform; vendor observability tooling |

### Rule
Unarticulated benefit claims must not pass Stage 4. Every proposed benefit claim must have a row in the output table.

### Output format
Write all classifications to `claude-memory/notes.md` under `## Benefit Claim Classification`:

```
| Benefit Claim | Category | Dependency | Phase Realisation Earliest |
|---|---|---|---|
```

**Consumption:** Stage 9 Section 10 (Benefit Realisation) reads this table. Conditional claims must display their dependency and earliest-phase qualifier. Unconditional claims display without caveat.

---

## Risk-Based Test Classification

**When:** Conditional at Stage 4. Activation condition: `application_count > 1` OR Discovery Maturity = `Deep`.

### Tier determination
Risk Tier = change frequency × business impact × integration complexity.

| Risk Tier | Guidance |
|---|---|
| High | High change frequency AND high business impact AND/OR high integration complexity |
| Medium | Moderate on at least two of the three dimensions |
| Low | Low change frequency AND contained business impact AND/OR simple integrations |

### Output format

```
| Change Type | Risk Tier (High/Medium/Low) | Required Test Depth | Automation Priority |
|---|---|---|---|
```

### Rules
- Minimum 3 change types must be classified (e.g., product launch, regulatory change, BAU maintenance).
- This table must be produced **before** architecture pillars are finalised.
- If insufficient artefact evidence exists, raise as Open Condition at Stage 4 rather than producing an unsupported table: "OC — Insufficient evidence to produce risk-tier classification. To be confirmed in Phase 0 discovery."
- This table is referenced by Stage 9 Section 7 (QE Architecture / Pillars) within the test strategy pillar.

---

## Application Clustering Draft

**When:** Conditional at Stage 4. Activation condition: `application_count > 1`.

### Tier model

| Tier | Definition | Wave Sequencing |
|---|---|---|
| Tier A | Complex/high-risk applications — high automation maturity gap AND/OR critical business function | Later delivery waves |
| Tier B | Mid-complexity — moderate risk and integration complexity | Middle waves |
| Tier C | Stable/low-risk — low complexity, strong quick-win automation potential | First waves; recommended pilot candidates |

### Output format
Write to `claude-memory/notes.md` under `## Application Clustering Draft`:

```
| Application | Risk Level | Automation Maturity | Integration Complexity | Business Criticality | Tier Assignment |
|---|---|---|---|---|---|
```

Rate each dimension: High / Med / Low. Tier Assignment: A / B / C.

### Rules
- Source: Stage 1 evidence — named applications from technology landscape findings, Section 3 artefact signals.
- Unknown applications: write "Phase 0 — to be confirmed during discovery" in all dimension cells.
- This draft is consumed by Stage 6 (delivery planning — wave sequencing validation against tier assignments).
- Stage 9 Section 14 confirms this draft — it does not rebuild from scratch. Section 14 may refine tier assignments based on Stage 5–8 findings.
